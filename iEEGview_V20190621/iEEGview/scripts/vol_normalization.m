function [mri_mni,elec_norm] = vol_normalization(volpath,elec)
%This scripts is used to run the volume based registration for intracranial
%electrodes, volpath is the orginal volume file path for the individual
%subject, elec is the electrode coodinates for all the electrodes in the
%native brain space, elec_norm is the volume registered coordinates in MNI
%space, this function use some scripts from Fieldtrip
% by Guangye Li(liguangye.hust@gmail.com) @ 2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mri_acpc = ft_read_mri(volpath);
% mri = MRIread(volpath);
% mri_acpc.anatomy = permute(mri.vol, [2 1 3]);
% mri_acpc.dim=size(mri.vol);
% mri_acpc.unit='mm';
% mri_acpc.transform=mri.vox2ras1;
mri_acpc.coordsys = 'acpc';
% mri=rmfield(mri,'vol');
% mri_acpc.hdr=mri;
cfg=[];
cfg.nonlinear = 'yes';
cfg.spmversion = 'spm12';
mri_mni = ft_volumenormalise(cfg, mri_acpc);
elec_norm=elec;
elec_norm = ft_warp_apply(mri_mni.params, elec, 'individual2sn');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sometimes some points get [0 0 0] coordinates after normalization, this is because
% the brain template used in spm dim = [91 109 91], some value of the
% coordinates exceed this value, looks like generally Y value>109.
% So this problem should be solved. Deal with the [0 0 0] points below
% BY Guangye Li(liguangye.hust@Gmail.com)@2019@SJTU
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ele_cor=find(sum(abs(elec_norm),2)==0);
if ~isempty(ele_cor)
    pos_trans=[];
    for i=1:length(ele_cor)
        index=ele_cor(i);
        pos_org=elec(index,:);
        dev_x=(elec(:,1)-pos_org(1)).^2;
        dev_y=(elec(:,2)-pos_org(2)).^2;
        dev_z=(elec(:,3)-pos_org(3)).^2;
        sumdev=dev_x+dev_y+dev_z;
        [value,seqind]=sort(sumdev,'ascend');
        t=2;
        flag=0;
        usefulele=0;
        while flag==0
            refeleind=seqind(t);
            eletmp=elec(refeleind,:);
            eletmp_trans=elec_norm(refeleind,:);
            if sum(abs(eletmp_trans),2)~=0
                usefulele=usefulele+1;
                elenearby(usefulele,:)=eletmp;
                elenearby_trans(usefulele,:)=eletmp_trans;
            end
            t=t+1;
            if usefulele==4
                flag=1;
            end
        end
        meanvect=mean(elenearby_trans./elenearby);
        initial_x=[meanvect(1),0,0,0,meanvect(2),0,0,0,meanvect(3)];
        P1=elenearby;
        P2=elenearby_trans;
        n=size(elenearby_trans,1);
        F=@(x)arrayfun(@(n)norm([x(1)*P1(n,1)+x(2)*P1(n,2)+x(3)*P1(n,3),x(4)*P1(n,1)+x(5)*P1(n,2)+x(6)*P1(n,3),...
            x(7)*P1(n,1)+x(8)*P1(n,2)+x(9)*P1(n,3)]-P2(n,:)),[1:size(P1,1)]);
        if n<=6
            OPTIONS = optimset('Algorithm','levenberg-marquardt');
            x=lsqnonlin(F,initial_x,[],[],OPTIONS);
        else
            x=lsqnonlin(F,initial_x);
        end
        pos_trans(i,:)=(reshape(x,3,3)'*pos_org')';
        
    end
    elec_norm(ele_cor,:)=pos_trans;
end


end

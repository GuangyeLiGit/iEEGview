function [ ntala] = corBrainShifts(handle,tala)
%This function correct the possible brain shifts for grid electrodes or
%depth electrodes when grid electrodes are implanted simulataneously.
%By Guangye Li @liguangye.hust@Gmail.com¡¡@USA@2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ntala=tala;
seeg_pos = tala.seeg_pos;
if handle.ElectrodeIndex==1 % only depth electrodes are implanted, not correction
    ntala.pos=(mat2cell(tala.electrodes,ones(1,size(tala.electrodes,1)),3))';
    ntala.pos_org=(mat2cell(tala.electrodes,ones(1,size(tala.electrodes,1)),3))';
    ntala.electrodes=tala.electrodes;
elseif handle.ElectrodeIndex==2 % subdural grid electrodes
    ntala.pos=(mat2cell(tala.electrodesdur,ones(1,size(tala.electrodesdur,1)),3))';
    ntala.pos_org=(mat2cell(tala.electrodes,ones(1,size(tala.electrodes,1)),3))';
    ntala.electrodes=tala.electrodesdur;
elseif  handle.ElectrodeIndex==3  %subdural + depth electrodes
    if length(unique(tala.hem(seeg_pos+1:end)))==2  %bilateral
        % correct for each hemisephere
        ecg_cor=tala.electrodesdur(seeg_pos+1:end,:);
        ecg_org=tala.electrodes(seeg_pos+1:end,:);
        dep_org=tala.electrodes(1:seeg_pos,:);
        dep_cor=dep_org;
        ehem=tala.hem(seeg_pos+1:end);
        dhem=tala.hem(1:seeg_pos);
        leftecg=find(ehem==1);
        rightecg=find(ehem==2);
        leftdep=find(dhem==1);
        rightdep=find(dhem==2);
        if ~isempty(leftdep)
            [leftcordep,~]=depthDisplacementCorrection(dep_org(leftdep,:),ecg_org(leftecg,:),ecg_cor(leftecg,:),5,30);
            dep_cor(leftdep,:)=leftcordep;
        end
        if ~isempty(rightdep)
            [rightcordep,~]=depthDisplacementCorrection(dep_org(rightdep,:),ecg_org(rightecg,:),ecg_cor(rightecg,:),5,30);
            dep_cor(rightdep,:)=rightcordep;
        end
    else % single hemisephere
        if unique(tala.hem(seeg_pos+1:end))==1 % left
            ecg_cor=tala.electrodesdur(seeg_pos+1:end,:);

%           ecg_cor=tala.trielectrodes(seeg_pos+1:end,:);
            ecg_org=tala.electrodes(seeg_pos+1:end,:);
            dep_org=tala.electrodes(1:seeg_pos,:);
            dep_cor=dep_org;
            ehem=tala.hem(seeg_pos+1:end);
            dhem=tala.hem(1:seeg_pos);
            leftecg=find(ehem==1);
            leftdep=find(dhem==1);
            if ~isempty(leftdep)
                [leftcordep,~]=depthDisplacementCorrection(dep_org(leftdep,:),ecg_org(leftecg,:),ecg_cor(leftecg,:),5,30);
                dep_cor(leftdep,:)=leftcordep;
            end
        end
        
        if unique(tala.hem(seeg_pos+1:end))==2 % right
            ecg_cor=tala.electrodesdur(seeg_pos+1:end,:);
            ecg_org=tala.electrodes(seeg_pos+1:end,:);
            dep_org=tala.electrodes(1:seeg_pos,:);
            dep_cor=dep_org;
            ehem=tala.hem(seeg_pos+1:end);
            dhem=tala.hem(1:seeg_pos);
            rightecg=find(ehem==2);
            rightdep=find(dhem==2);
            if ~isempty(rightdep)
                [rightcordep,~]=depthDisplacementCorrection(dep_org(rightdep,:),ecg_org(rightecg,:),ecg_cor(rightecg,:),5,30);
                dep_cor(rightdep,:)=rightcordep;
            end
        end
        
    end
    ntala.pos_org=(mat2cell(tala.electrodes,ones(1,size(tala.electrodes,1)),3))'; 
    depecg_cor=[dep_cor;ecg_cor];
    ntala.electrodes(1:seeg_pos,:)=dep_cor;
    ntala.electrodes(seeg_pos+1:end,:)=ecg_cor;
%   selectrodestri=findTripointsDepth(cortex,dep_cor,handle.normdist);
    ntala.trielectrodes(1:seeg_pos,:)=dep_cor;
    ntala.pos=(mat2cell(depecg_cor,ones(1,size(depecg_cor,1)),3))';
    
end

end


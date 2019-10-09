%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Updated By LiGuangye(liguangye.hust@gmail.com)@2017.05.17@USA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Plot_In_RAS_WM_v2(ConfigurationPath,cpm,eleIndex,handles)
subject_directory = ConfigurationPath.subject_directory;
subject_name = ConfigurationPath.subject_name;
scriptdirectory = ConfigurationPath.iEEGview_directory;
switch cpm  %%% Cortical Parcellation methods,need to add handle here in GUI
    case 1
        segFile=[subject_directory,'/Segmentation/mri/wmparc.mgz'];
    case 2
        segFile=[subject_directory,'/Segmentation/mri/aparc.a2009s+aseg.mgz'];
    case 3
        segFile=[subject_directory,'/Segmentation/mri/aparc.DKTatlas+aseg.mgz'];
end

VOLWM=MRIread(segFile);% read volume
Mat=VOLWM.tkrvox2ras;% transformation matrix
save([subject_directory,'/Electrodes/VolWM'],'VOLWM','Mat');
Create_CLU_WM;
load([subject_directory,'/MATLAB/WholeCortex']);
load([subject_directory,'/Electrodes/electrodes_Final.mat']);
load([subject_directory,'/MATLAB/', subject_name, '.mat']);
Cord_ele_accu=[];
Cord_ele=[];
if eleIndex==2
    load([subject_directory,'/MATLAB/',subject_name,'.mat']);
    switch cpm  %%% Cortical Parcellation methods,need to add handle here in GUI
        case 1
            load([subject_directory,'/MATLAB/Cortex_Center_aparc.mat']);
        case 2
            load([subject_directory,'/MATLAB/Cortex_Center_aparc2009.mat']);
        case 3
            load([subject_directory,'/MATLAB/Cortex_Center_DKT40.mat']);
    end
    for ecg=1:length(tala.electrodes)
        vert_loc=cortex.vert-repmat(tala.electrodes(ecg,:),size(cortex.vert,1),1);
%         locindex=find(sum(abs(vert_loc),2)==0);
            [~,locindex]=min(sum(vert_loc.^2,2));
            locindex = locindex(1);
			CortDis=sum((cortex.vert-repmat(cortex.vert(locindex,:),size(cortex.vert,1),1)).^2,2);
			IndexInRange=find(CortDis<=5^2);
        if locindex<=size(M(2).vert,1) % left hemisphere
		    ana_locall=[];
            IndexInRang=setdiff(IndexInRange,[(size(M(2).vert,1)+1):length(cortex.vert)]);
            for ecgv=1:length(IndexInRange)
            ana_locall(ecgv)=find(M(2).table(:,5)==M(2).BV(IndexInRange(ecgv)));
			end
			EcgAnaAll=tabulate(ana_locall);
            [~,maxInd]=max(EcgAnaAll(:,3));
			ana_loc=EcgAnaAll(maxInd(1),1);
            elec_Info_Final.ana_label_name{1,ecg}=M(2).struct_names{ana_loc};
            Cord_ele_accu(:,ecg)=inv(Mat)*[tala.electrodes(ecg,:),1]';
            Cord_ele(:,ecg)=round(inv(Mat)*[tala.electrodes(ecg,:),1]');
            elec_Info_Final.ano_pos{1,ecg}=[Cord_ele(2,ecg),Cord_ele(1,ecg),Cord_ele(3,ecg)];
            elec_Info_Final.ana_label_index(1,ecg)=ana_loc;
            elec_Info_Final.ana_pos_accu{1,ecg}=[Cord_ele_accu(2,ecg),Cord_ele_accu(1,ecg),Cord_ele_accu(3,ecg)];
        else    % right hemisphere
            IndexInRang=setdiff(IndexInRange,[1:size(M(2).vert,1)]);
            IndexInRange=IndexInRange-size(M(2).vert,1);
		    ana_locall=[];
            for ecgv=1:length(IndexInRange)
            ana_locall(ecgv)=find(M(1).table(:,5)==M(1).BV(IndexInRange(ecgv)));
			end
			EcgAnaAll=tabulate(ana_locall);
            [~,maxInd]=max(EcgAnaAll(:,3));
			ana_loc=EcgAnaAll(maxInd(1),1);
            elec_Info_Final.ana_label_name{1,ecg}=M(1).struct_names{ana_loc};
            Cord_ele_accu(:,ecg)=inv(Mat)*[tala.electrodes(ecg,:),1]';
            Cord_ele(:,ecg)=round(inv(Mat)*[tala.electrodes(ecg,:),1]');
            elec_Info_Final.ano_pos{1,ecg}=[Cord_ele(2,ecg),Cord_ele(1,ecg),Cord_ele(3,ecg)];
            elec_Info_Final.ana_label_index(1,ecg)=ana_loc;
            elec_Info_Final.ana_pos_accu{1,ecg}=[Cord_ele_accu(2,ecg),Cord_ele_accu(1,ecg),Cord_ele_accu(3,ecg)];
        end
        
    end
elseif eleIndex==1 || eleIndex==3
  load([subject_directory,'/Electrodes/electrodeType.mat']);
% IntCont = ElectrodeLength.InterContactDistance;
eleclen = ElectrodeLength.ContactLength;
diam = ElectrodeLength.Diameter;
    load([subject_directory,'/Electrodes/electrode_raw.mat']);
    number_seq=cell2mat(elec_Info.number);
    vector=zeros(length(elec_Info.number),3);
    ele_number_seg(1)=1;
    for h=1:length(elec_Info.number)
        ele_number_seg(h)=sum(number_seq(1:h-1))+ele_number_seg(1);
    end
    % get the vector of axis
    vector=[];
    for h=1:length(elec_Info.number)
        vector(h,:)=(elec_Info_Final.pos{1,ele_number_seg(h)+1}-elec_Info_Final.pos{1,ele_number_seg(h)})/3.5;
    end
    len_cy=linspace(eleclen+1,2,2);
    ridus=linspace(diam/2+0.5,0.4,2);
    n_poit=[15,10];
    n_line=[11,11];
    ctx_index=[];
    ctx_index_loc=0;
    ctx_vox=[];
    trans=[];
    for  j=1:length(elec_Info.number)
        ele_end(j)=sum(number_seq(1:j));
        ele_srt(j)=ele_number_seg(j);
        ele_seq=[ele_srt(j):1:ele_end(j)];
        facealpha=[0.2,0.4];
        for k= 1:length(ele_seq)
            mm=0;
            ele=ele_seq(k);
            trans(ele,:)=elec_Info_Final.pos{1,ele};% center of each cylinder
            % For comparasion, plot the electrodes.
            new_pts=[];
            for kl=1:length(len_cy)
                figure;
                [cylinder,low_plt,up_plt]=cylinder3(trans(ele,:)-0.5*len_cy(kl)*vector(j,:),trans(ele,:)+0.5*len_cy(kl)*vector(j,:),ridus(kl),n_line(kl),[0.7 0.7 0.7],1,1);
                for jl=1:n_line(kl)
                    
                    sca_pts_x=linspace(cylinder.XData(jl,1),cylinder.XData(jl,2),n_poit(kl));
                    sca_pts_y=linspace(cylinder.YData(jl,1),cylinder.YData(jl,2),n_poit(kl));
                    sca_pts_z=linspace(cylinder.ZData(jl,1),cylinder.ZData(jl,2),n_poit(kl));
                    tmp_pts=[sca_pts_x',sca_pts_y',sca_pts_z'];
                    new_pts=[new_pts;tmp_pts];
                    
                end
                clf;
                close;
                
            end
            new_pts=unique(new_pts,'rows','stable');% remove repeat points
            new_pts=[new_pts;trans(ele,:)];
            new_pts=[new_pts,ones(length(new_pts),1)];
            new_Cord_ele=[];
            new_lindx=[];
            all_test_ana_name=[];
            new_Cord_ele_real=[];
            for al=1:length(new_pts)
                new_Cord_ele(:,al)=round(inv(Mat)*new_pts(al,:)');
                new_Cord_ele_real(:,al)=inv(Mat)*new_pts(al,:)';
            end
            new_Cord_ele_uni=unique(new_Cord_ele([2,1,3],:)','rows');
            for au=1:length(new_Cord_ele_uni)
                new_lindx(au)=VOLWM.vol(new_Cord_ele_uni(au,1),new_Cord_ele_uni(au,2),new_Cord_ele_uni(au,3));
                all_test_ana_name{1,au}=AsegWM.name{find(AsegWM.index==new_lindx(au)),1};
            end
            Get_Local_PTD;
            Get_PTD_WM_V3;
            uni_test_ana_name_table=tabulate(all_test_ana_name);
            [Pert,tmpInd]=max(cell2mat(uni_test_ana_name_table(:,3)));
            Cord_ele_accu(:,ele)=inv(Mat)*[trans(ele,:),1]';
            Cord_ele(:,ele)=round(inv(Mat)*[trans(ele,:),1]');
            elec_Info_Final.ano_pos{1,ele}=[Cord_ele(2,ele),Cord_ele(1,ele),Cord_ele(3,ele)];
            elec_Info_Final.ana_label_name{1,ele}=char(uni_test_ana_name_table(tmpInd(1),1));
            [maxv,max_loc]=max(histc(new_lindx,0:max(new_lindx)));
            elec_Info_Final.ana_label_index(1,ele)=max_loc-1;
            elec_Info_Final.ana_cube(1,ele)=length(new_Cord_ele_uni);
            elec_Info_Final.ana_pos_accu{1,ele}=[Cord_ele_accu(2,ele),Cord_ele_accu(1,ele),Cord_ele_accu(3,ele)];            
            elec_Info_Final.PTD(1,ele)=PTD;
            elec_Info_Final.LocalPTD(1,ele)=LocalPTD;
        end
    end
    if eleIndex==3 % localize ECoG electrodes here~
        load([subject_directory,'/MATLAB/',subject_name,'.mat']);
        switch cpm  %%% Cortical Parcellation methods,need to add handle here in GUI
            case 1
                load([subject_directory,'/MATLAB/Cortex_Center_aparc.mat']);
            case 2
            
                load([subject_directory,'/MATLAB/Cortex_Center_aparc2009.mat']);
            case 3
                load([subject_directory,'/MATLAB/Cortex_Center_DKT40.mat']);
        end
        ecogelectrodes=tala.electrodes(elec_Info_Final.seeg_pos+1:end,:);
        for ecg=1:size(ecogelectrodes,1)
            vert_loc=cortex.vert-repmat(ecogelectrodes(ecg,:),size(cortex.vert,1),1);
            [~,locindex]=min(sum(vert_loc.^2,2));
            locindex = locindex(1);
			CortDis=sum((cortex.vert-repmat(cortex.vert(locindex,:),size(cortex.vert,1),1)).^2,2);
			IndexInRange=find(CortDis<=5^2);
            if locindex<=size(M(2).vert,1) % left hemisphere
                ana_locall=[];
                IndexInRang=setdiff(IndexInRange,[(size(M(2).vert,1)+1):length(cortex.vert)]);
                for ecgv=1:length(IndexInRange)
                    ana_locall(ecgv)=find(M(2).table(:,5)==M(2).BV(IndexInRange(ecgv)));
                end
                EcgAnaAll=tabulate(ana_locall);
                [~,maxInd]=max(EcgAnaAll(:,3));
                ana_loc=EcgAnaAll(maxInd(1),1);
                elec_Info_Final.ana_label_name{1,elec_Info_Final.seeg_pos+ecg}=M(2).struct_names{ana_loc};
                Cord_ele_accu(:,elec_Info_Final.seeg_pos+ecg)=inv(Mat)*[ecogelectrodes(ecg,:),1]';
                Cord_ele(:,elec_Info_Final.seeg_pos+ecg)=round(inv(Mat)*[ecogelectrodes(ecg,:),1]');
                elec_Info_Final.ano_pos{1,elec_Info_Final.seeg_pos+ecg}=[Cord_ele(2,elec_Info_Final.seeg_pos+ecg),...
                    Cord_ele(1,elec_Info_Final.seeg_pos+ecg),Cord_ele(3,elec_Info_Final.seeg_pos+ecg)];
                elec_Info_Final.ana_label_index(1,elec_Info_Final.seeg_pos+ecg)=ana_loc;
                elec_Info_Final.ana_pos_accu{1,elec_Info_Final.seeg_pos+ecg}=[Cord_ele_accu(2,elec_Info_Final.seeg_pos+ecg),...
                    Cord_ele_accu(1,elec_Info_Final.seeg_pos+ecg),Cord_ele_accu(3,elec_Info_Final.seeg_pos+ecg)];
            else    % right hemisphere
                IndexInRang=setdiff(IndexInRange,[1:size(M(2).vert,1)]);
                IndexInRange=IndexInRange-size(M(2).vert,1);
                ana_locall=[];
                for ecgv=1:length(IndexInRange)
                    ana_locall(ecgv)=find(M(1).table(:,5)==M(1).BV(IndexInRange(ecgv)));
                end
                EcgAnaAll=tabulate(ana_locall);
                [~,maxInd]=max(EcgAnaAll(:,3));
                ana_loc=EcgAnaAll(maxInd(1),1);
                elec_Info_Final.ana_label_name{1,elec_Info_Final.seeg_pos+ecg}=M(1).struct_names{ana_loc};
                Cord_ele_accu(:,elec_Info_Final.seeg_pos+ecg)=inv(Mat)*[ecogelectrodes(ecg,:),1]';
                Cord_ele(:,elec_Info_Final.seeg_pos+ecg)=round(inv(Mat)*[ecogelectrodes(ecg,:),1]');
                elec_Info_Final.ano_pos{1,elec_Info_Final.seeg_pos+ecg}=[Cord_ele(2,elec_Info_Final.seeg_pos+ecg),...
                    Cord_ele(1,elec_Info_Final.seeg_pos+ecg),Cord_ele(3,elec_Info_Final.seeg_pos+ecg)];
                elec_Info_Final.ana_label_index(1,elec_Info_Final.seeg_pos+ecg)=ana_loc;
                elec_Info_Final.ana_pos_accu{1,elec_Info_Final.seeg_pos+ecg}=[Cord_ele_accu(2,elec_Info_Final.seeg_pos+ecg),...
                    Cord_ele_accu(1,elec_Info_Final.seeg_pos+ecg),Cord_ele_accu(3,elec_Info_Final.seeg_pos+ecg)];
            end
			elec_Info_Final.PTD(1,elec_Info_Final.seeg_pos+ecg)=1;
            elec_Info_Final.LocalPTD(1,elec_Info_Final.seeg_pos+ecg)=1;
        end
    end
else
    error('Check which kinds of electrodes to localize!') % This will never happen
end
  
elec_Info_Final_wm=elec_Info_Final;
elec_Info_Final_wm.cpm=cpm;
save([subject_directory,'/Electrodes/electrodes_Final_Anatomy_wm'],'elec_Info_Final_wm','AsegWM');

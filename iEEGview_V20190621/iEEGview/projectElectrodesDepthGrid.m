function [ tala ] = projectElectrodesDepthGrid(pathToSubjectDir,tala,handles)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
normdist=handles.normdist;
load(strcat(pathToSubjectDir,'/MATLAB/WholeCortex.mat'));
tala.trielectrodes=tala.electrodes;
tala.electrodesdur=tala.electrodes;
stdtala=struct;
for i=1:2 % hem loop
    ind=find(tala.hem==i); % left
    if i==1 && ~isempty(ind)
        hem='left';
    elseif i==2 && ~isempty(ind)
        hem='right';
    else
        hem=[];
        %         error('No hemisphere information is found! Please check electrode information~');
    end
    if ~isempty(hem)
        if handles.ElectrodeIndex==1
            cortexhem=eval([hem,'cortex']);
            stdtala.electrodes=tala.electrodes(ind,:);
%           stdtala.trielectrodes=findTripointsDepth(cortexhem,stdtala.electrodes,normdist);
            tala.electrodesdur(ind,:)=stdtala.electrodes;
            tala.trielectrodes(ind,:)=stdtala.electrodes;
            clear cortexhem
        elseif handles.ElectrodeIndex==2
            cortexouthem=eval([hem,'cortexout']);
            cortexoutcoaser=coarserModel(cortexouthem,0.1,handles);
            stdtala.electrodes=tala.electrodes(ind,:);
            [ stdtala ] = projectElectrodes(handles,cortexoutcoaser, stdtala, normdist);
            tala.electrodesdur(ind,:)=stdtala.trielectrodes;
            tala.trielectrodes(ind,:)=stdtala.trielectrodes;
            clear cortexouthem
        elseif handles.ElectrodeIndex==3
            cortexhem=eval([hem,'cortex']);
            seegind=[1:tala.seeg_pos];
            ecogind=[(tala.seeg_pos+1):size(tala.electrodes,1)];
            seeghem=intersect(seegind,ind);
            ecoghem=intersect(ecogind,ind);
            if ~isempty(seeghem)
                selectrodes=tala.electrodes(seeghem,:);
%               selectrodestri=findTripointsDepth(cortexhem,selectrodes,normdist);
                tala.trielectrodes(seeghem,:)=selectrodes;
                tala.electrodesdur(seeghem,:)=tala.electrodes(seeghem,:);
            end
            if ~isempty(ecoghem)
                cortexouthem=eval([hem,'cortexout']);
                talae.electrodes=tala.electrodes(ecoghem,:);
                cortexoutcoaser=coarserModel(cortexouthem,0.1,handles);
                [ talae  ] = projectElectrodes(handles,cortexoutcoaser,talae,normdist);
                tala.electrodesdur(ecoghem,:)=talae.trielectrodes;
                tala.trielectrodes(ecoghem,:)=talae.trielectrodes;
                clear cortexouthem
            end
        else
            error('Wrong electrode type inputs,please check the electrodes index!');
        end
    end
end
end


function handles = plotactivations(M,eleS,activations,kernelpara,sub_info,pathToSubjectDir,handles)
%plot activation maps here
% M is the cortex struct with two attributes, vert and tri.
% eleS is the electrode information struct. with attributes: electrodes, number,name,elenum_per_subject
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cortex= M;
tala= eleS;
tala.activations = activations;
subjectID = sub_info;

%% Brain model calculation
% global View;
if ~handles.CalculationFlag_Activation

    %%%%updated by Guangyeli @liguangye.hust@Gmail.com @USA @2018.02.01
    %Projecting the electrodes
    handles.normdist=kernelpara(4);
    if handles.ElectrodeIndex==2
        tala.electrodes=cell2mat(tala.pos_org');
        tala=projectElectrodesDepthGrid(pathToSubjectDir,tala,handles);
        tala.electrodes=tala.electrodesdur;
    elseif handles.ElectrodeIndex==3
        electrodes_Pos=cell2mat(tala.pos_org');
        tala.electrodes(tala.seeg_pos+1:end,:)=electrodes_Pos(tala.seeg_pos+1:end,:);
        tala=projectElectrodesDepthGrid(pathToSubjectDir,tala,handles);
        tala.electrodes(tala.seeg_pos+1:end,:)=tala.electrodesdur(tala.seeg_pos+1:end,:);
    else
        tala=projectElectrodesDepthGrid(pathToSubjectDir,tala,handles);
        %no change
    end
    %Computing the electrode contributions
    %Compute the contributions of the given electrodes:
    if kernelpara(1)==1
        kernel = 'gaussian';
    else
        kernel = 'linear';    
    end
    parameter = 10;
    cutoff = kernelpara(2);
    Dis_surf=kernelpara(3);
    %See also |electrodesContributions| for a more thorough information on its arguments)
    [ vcontribs ] = electrodesContributions( cortex, tala, kernel, parameter, cutoff, Dis_surf, handles);
    % normalizing vcontribs by number of electrodes 
    vcontribs_norm = vcontribs;

    for idx=1:length(vcontribs)

        v_norm = sum(vcontribs(idx).contribs(:,3));

        if size(vcontribs(idx).contribs,1) > 1

            vcontribs_norm(idx).contribs(:,3) = vcontribs(idx).contribs(:,3) ./ v_norm;

        end
    end

    handles.CalculationFlag_Activation = 1;
    handles.vcontribs_norm_Activation = vcontribs_norm;
    handles.vcontribs_Activation = vcontribs;
end
% vcontribs=vcontribs_norm;

vcontribs_norm = handles.vcontribs_norm_Activation;
vcontribs = handles.vcontribs_Activation;

%% Display options
viewstruct.what2view = {'brain','activations'};

% param.electrodes_pos = input('What side of the brain do you want to view? ("front"|"top"|"lateral"|"isometric"|"right"|"left"): ');
% global View
param.electrodes_pos = handles.Side;

if strcmp(param.electrodes_pos,'front')
%%%%%front view%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   viewstruct.lightpos=[0,180,0];
    viewstruct.viewvect=[180,0];
elseif strcmp(param.electrodes_pos,'top')
%%%%%top view%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 viewstruct.lightpos=[0,0,80];
    viewstruct.viewvect=[0,90];
elseif strcmp(param.electrodes_pos,'isometric')
%%%%%isometric view%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 viewstruct.lightpos=[-100,80,45];
   viewstruct.viewvect=[-108,30];
   
elseif strcmp(param.electrodes_pos,'right')
    viewstruct.viewvect     = [90, 0];
     viewstruct.lightpos     = [150, 0, 0];
elseif strcmp(param.electrodes_pos,'left')
     viewstruct.viewvect     = [270, 0];
     viewstruct.lightpos     = [-150,0, 0];
else
    error('wrong input, check your spelling');
end

viewstruct.material     = 'dull';
viewstruct.enablelight  = 1;
viewstruct.enableaxis   = 0;
viewstruct.lightingtype = 'gouraud';
viewstruct.enablecortexcolor=0;
viewstruct.enablewhitematter=0;

II = strmatch('activations', viewstruct.what2view,'exact');
if ~isempty(II)
    cmapstruct.basecol          = [0.97, 0.92, 0.92];
else
    cmapstruct.basecol          = [0.7, 0.7, 0.7];
end
cmapstruct.fading           = true;
cmapstruct.enablecolormap   = true;
cmapstruct.enablecolorbar   = true;
cmapstruct.color_bar_ticks  = 4;
ix = 1;
%% Brain activation plot
figure; % c
cmapstruct.cmap = colormap('Jet'); close(gcf); %because colormap creates a figure
cmapstruct.ixg2 = floor(length(cmapstruct.cmap) * 0.15);
cmapstruct.ixg1 = -cmapstruct.ixg2;

%cmapstruct.cmin = -log(0.05/mean(tala.elenum_per_subject));
cmapstruct.cmin = str2double(get(handles.edit_Cmin,'string'));
cmapstruct.cmax = str2double(get(handles.edit_Cmax,'string'));
% cmapstruct.cmax = max(tala.activations(:,ix));

% save the activateBrain structure in subjectDir/MATLAB
placeToSaveFile = strcat(pathToSubjectDir, '/MATLAB/', subjectID, '_Activations.mat');
save(placeToSaveFile, 'cmapstruct', 'cortex', 'ix', 'tala', 'vcontribs', 'viewstruct','vcontribs_norm');
% run activateBrain to generate the visualization
[~,handles] = activateBrain(cortex, vcontribs_norm, tala, ix, cmapstruct, viewstruct, handles);

end % end of function


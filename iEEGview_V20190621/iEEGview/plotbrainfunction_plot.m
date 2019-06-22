function handles = plotbrainfunction_plot(subjectID,pathToSubjectDir,handles)

placeToSaveFile = [pathToSubjectDir, '/MATLAB/', subjectID, '.mat'];
if ~exist(placeToSaveFile)
    fprinf('No Electrodes files detected! Please run the Electrode reconstruction first!');    
else
    load(placeToSaveFile);
end
%% Display options
param.electrodes_pos = handles.Side;
viewstruct.what2view = handles.Comp;

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
figure;% c
cmapstruct.cmap = colormap('Jet'); close; %because colormap creates a figure
cmapstruct.ixg2 = floor(length(cmapstruct.cmap) * 0.15);
cmapstruct.ixg1 = -cmapstruct.ixg2;

%cmapstruct.cmin = -log(0.05/mean(tala.elenum_per_subject));
cmapstruct.cmin = 0;
cmapstruct.cmax = max(tala.activations(:,ix));

% save the activateBrain structure in subjectDir/MATLAB
placeToSaveFile = strcat(pathToSubjectDir, '/MATLAB/', subjectID, '.mat');
save(placeToSaveFile, 'cmapstruct', 'cortex', 'ix', 'tala', 'vcontribs', 'viewstruct','vcontribs_norm');
% run activateBrain to generate the visualization
[~,handles] = activateBrain_v2(cortex, vcontribs_norm, tala, ix, cmapstruct, viewstruct, handles);

end % end of function


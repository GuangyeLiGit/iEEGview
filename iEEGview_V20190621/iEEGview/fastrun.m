function handles = fastrun(subjectID,ixv,cortexcolor,ViewVector,handles)
placeToSaveFile = strcat(handles.ConfigurationPath.subject_directory, '/MATLAB/', subjectID, '.mat');
load(placeToSaveFile);

%% Display options
viewstruct.what2view ={'brain'};

if strcmp(ViewVector,'front')
%%%%%front view%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   viewstruct.lightpos=[0,180,0];
    viewstruct.viewvect=[180,0];
elseif strcmp(ViewVector,'top')
%%%%%top view%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 viewstruct.lightpos=[0,0,80];
    viewstruct.viewvect=[0,90];
elseif strcmp(ViewVector,'isometric')
%%%%%isometric view%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 viewstruct.lightpos=[-100,80,45];
   viewstruct.viewvect=[-108,30];
   
elseif strcmp(ViewVector,'right')
    viewstruct.viewvect     = [90, 0];
     viewstruct.lightpos     = [150, 0, 0];
elseif strcmp(ViewVector,'left')
     viewstruct.viewvect     = [270, 0];
     viewstruct.lightpos     = [-150,0, 0];   
else
    error('wrong input, check your spelling');
end

sel = handles.cpm;
viewstruct.cpm = sel;
viewstruct.material     = 'dull';
viewstruct.enablelight  = 1;
viewstruct.enableaxis   = 0;
viewstruct.lightingtype = 'gouraud';
viewstruct.enablecortexcolor=cortexcolor;
viewstruct.enablewhitematter=0;

II = strmatch('activations', viewstruct.what2view,'exact');
if ~isempty(II)
    cmapstruct.basecol          = [0.7, 0.7, 0.7];
else
    cmapstruct.basecol          = [0.80, 0.80, 0.80];
end
cmapstruct.fading           = true;
cmapstruct.enablecolormap   = true;
cmapstruct.enablecolorbar   = true;
cmapstruct.color_bar_ticks  = 4;

ix=ixv;
tala.activations(:,ix)=1;
%% Brain activation plot
figure; % c
cmapstruct.cmap = colormap('Jet'); close; %because colormap creates a figure
cmapstruct.ixg2 = floor(length(cmapstruct.cmap) * 0.15);
cmapstruct.ixg1 = -cmapstruct.ixg2;

cmapstruct.cmin = 0;
cmapstruct.cmax = max(tala.activations(:,ix));


% run activateBrain to generate the visualization
[~,handles] = activateBrain_v2(cortex, vcontribs, tala, ix, cmapstruct, viewstruct,handles);
end

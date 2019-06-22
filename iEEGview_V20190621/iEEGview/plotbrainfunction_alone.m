function handles = plotbrainfunction_alone(a, b, c, d, e, f, g,handles)

cortex.vert = a;
cortex.tri = b;
tala = c;
tala.elenum_per_subject=length(c.name);
tala.activations = d;
subjectID = e;
pathToSubjectDir = f;

if get(handles.checkbox_ReCalculation,'value')
    handles.CalculationFlag = 0;
end
%% Brain model calculation

%%%%updated by Guangyeli @liguangye.hust@Gmail.com @USA @2018.02.01
% opengl neverselect
handles.normdist=30;
tala=projectElectrodesDepthGrid(pathToSubjectDir,tala,handles);
[tala]=corBrainShifts(handles,tala); % Correction only once
%Computing the electrode contributions
%Compute the contributions of the given electrodes:
if g(1)==1
    kernel = 'gaussian';
else
    kernel = 'linear';    
end
parameter = 10;
cutoff = g(2);
Dis_surf=g(3);
%See also |electrodesContributions| for a more thorough information on its arguments)
[ vcontribs ] = electrodesContributions(cortex, tala, kernel, parameter, cutoff, Dis_surf,handles);
% normalizing vcontribs by number of electrodes 
vcontribs_norm = vcontribs;
 
for idx=1:length(vcontribs)
    
    v_norm = sum(vcontribs(idx).contribs(:,3));
    
    if size(vcontribs(idx).contribs,1) > 1
        
        vcontribs_norm(idx).contribs(:,3) = vcontribs(idx).contribs(:,3) ./ v_norm;
        
    end
end
% global View
handles.CalculationFlag = 1;
handles.vcontribs = vcontribs;
handles.vcontribs_norm = vcontribs_norm; 
elec_Info_Final=tala;
% save the activateBrain structure in subjectDir/MATLAB
placeToSaveFile = strcat(pathToSubjectDir, '/MATLAB/', subjectID, '.mat');
% save(placeToSaveFile, 'cortex', 'ix', 'tala', 'vcontribs', 'vcontribs_norm');
save(placeToSaveFile, 'cortex', 'tala', 'vcontribs', 'vcontribs_norm');
save([pathToSubjectDir, '/Electrodes/electrodes_Final.mat'],'elec_Info_Final','tala');
end % end of function


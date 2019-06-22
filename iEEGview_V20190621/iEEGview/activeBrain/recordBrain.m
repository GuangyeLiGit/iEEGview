function [ mov ] = recordBrain( M, vcontribs, subjstructs, stimuluscode, stimulusstrcell, range, cmapstruct, viewstruct, filename, pos )
%RECORDBRAIN    Capture activateBrain's graphical output into an avi file.
%
%   Iteratively calls activateBrain with an activation data column of
%   passed activation matrix and captures figure contents into an avi
%   file.
%
%
%   CALLING SEQUENCE:
%       recordBrain( M, vcontribs, subjstructs, stimuluscode, stimulusstrcell, range, cmapstruct, viewstruct, filename, pos )
%
%   INPUT:
%       M:              struct('vert', Vx3matrix, 'tri', Tx3matrix) - brain model (eventually the one altered by projectElectrodes, see <help projectElectrodes>)
%       vcontribs:      struct('vertNo', index, 'contribs', [subj#, el#, mult;...]) - structure containing the vertices that are near the electrode grids; this structure contains the multipliers
%       subjstructs:    field of structures, for each subject: struct('activations', NsubjxLsubjMatrix, 'trielectrodes', Nsubjx1Matrix) - enhanced subjstructs (output of projectElectrodes), where 'trielectrodes' is a matrix of coordinates of the projected electrodes
%       stimuluscode:   vector providing indices into stimulusstrcell at each frame:
%       stimulusstrcell:cell of strings; at each frame displays appropriate figure title as indexed by stimuluscode
%       range:          vector specifying which samples of the activation data matrix (which columns or this matrix) will be sequentially displayed; its maximum value is {min(Lsubj) of all subj}
%       cmapstruct:     controls the mapping of the values onto the colorbar, see cmapstruct below
%       viewstruct:     specifies the viewing properties, see below
%       filename:       string specifying filename of the captured .avi file
%       pos:            specifies the window position of the figure whose contents is to be captured
%
%      structure cmapstruct:
%       cmapstruct.cmap - the colormap to use (e.g. colormap('Jet'))
%       cmapstruct.basecol - the RGB triples that specifies the colour that the colormap fades into (e.g. [0.7, 0.7, 0.7])
%       cmapstruct.fading - boolean value specifying whether or not you want to use the fading capability (if set to false, the first value of colormap will be set to basecol and the rest of the cmap remains untouched)
%       cmapstruct.ixg1 and
%       cmapstruct.ixg2
%           The previous two indices are spanning the range at cmapstruct.cmap
%           that will be faded into basecol; they represent a "fading
%           strip of cmap" - if the strip is positioned somewhere centrally on the cmap, then the colours
%           will fade into the middle value of <ixg2 and ixg1> from both sides; if the
%           fading is supposed to happen at the edges of the colorbar, please set:
%           for fading at low values, please set:
%            ixg2 to the index of cmap whose value starts the fading into basecol
%            ixg1 = -ixg2 (because the fading affects always only a half of the strip from each side)
%            (e.g. ixg2 = 15; ixg1 = -15;)
%           for fading at high values, please set:
%            ixg2 = length(cmap) + half_of_the_strip_length (because the fading affects always only a half of the strip from each side)
%            ixg1 = length(cmap)- half_of_the_strip_length (because the fading affects always only a half of the strip from each side)   
%            (e.g. ixg2 = 64 + 15; ixg1 = 64 - 15;)
%       cmapstruct.cmin - the value of the signal that is considered to be the minumum of the colormap (cmapstruct.basecol will be preserved as the first index of colormap)
%       cmapstruct.cmax - the value of the signal that is considered to be the maximum of the colormap
%       cmapstruct.enablecolormap - boolean specifying whether colormap is applied
%       cmapstruct.enablecolorbar - when enablecolormap true, this boolean specifies whether colorbar is displayed
%
%      structure viewstruct:
%       viewstruct.what2view - a column cell of strings specifying what shall be visualized:
%           possible values: 'brain' - shows the grey brain
%                            'activations' - shows the activations
%                            'electrodes' - shows the original electrode locations
%                            'trielectrodes' - shows the projected electrode locations
%                                 (e.g. {'brain', 'activations'} )
%       viewstruct.viewvect - vector used by the view command (e.g. [-90, 0])
%       viewstruct.material - string used by the material command (e.g. 'dull')
%       viewstruct.enableaxis - boolean specifying whether axes are displayed or not
%       viewstruct.enablelight - boolean specifying whether light is used or not - it should be always used so that the surface of the brain is visible with all its sulci
%       viewstruct.lightpos - vector specifying the coordinates of the light (respectively to current axes), used by light command (e.g. [-200, 0, 0])
%       viewstruct.lightingtype - string specifying the type of lighting technique, used by the lighting command (e.g. 'gouraud')
%
%   OUTPUT:
%       mov:            the .avi movie frames
%
%   REMARK:
%       Other values (e.g. winheight, winwidth, quality, ...) are to be set
%       directly by altering the code below.
%       The arguments pos and filename are useful when rendering on machines with several
%       CPU's - in this case, call recordBrain with different pos and filename
%       for each process (because the .avi is captured from what is seen on the
%       figure - no windows should overlay the displayed figures and the
%       screensaver must be off).
%
%   Example:
%       recordBrain( M, vcontribs, subjstructs, stimuluscode, {'hand', 'shoulder'}, 1 : 120, cmapstruct, viewstruct, 'testavi',  [1 50]);
%
%   For more information, see activateBrain.
%
%   See also DEMRECORDBRAIN, ACTIVATEBRAIN, PROJECTELECTRODES, ELECTRODESCONTRIBUTIONS.

%   Author: Jan Kubanek
%   Institution: Czech Technical University in Prague
%   Date: August 2005
%   This procedure is a part of the activeBrain Matlab package which was
%   designed for internal purposes of the BCI group at the Wadsworth Institute,
%   Albany, NY.


subjs = subjstructs;
S = length(subjstructs);

fig = figure;
clf;
winwidth = 640;
winheight = 480;
set(fig, 'Position', [pos(1) pos(2) winwidth winheight]);
set(fig, 'DoubleBuffer', 'on');

mov = avifile(filename);
mov.compression = 'none';
mov.quality = 100;
mov.fps = 12;

for col = range,
    fprintf('Processing frame %d\n', col);
    for s = 1 : S,
        subjs(s).activations = subjstructs(s).activations(:, col);
    end

    clf; set(gca, 'Color', 'none'); set(gcf, 'Color', 'k'); grid off;
    activateBrain( M, vcontribs, subjs, 1, cmapstruct, viewstruct );
    
    if stimuluscode(col) > 0 && stimuluscode(col) <= 2,
        title(gca, stimulusstrcell{stimuluscode(col)});
    end
    
    frame = getframe(gca);
    mov = addframe(mov, frame);
end

mov = close(mov);
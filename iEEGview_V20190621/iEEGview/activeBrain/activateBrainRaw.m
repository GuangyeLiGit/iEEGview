function [cBar] = activateBrain( M, vcontribs, subjstructs, range, cmapstruct, viewstruct )

%ACTIVATEBRAIN  Visualize activations on a brain model.
%
%   Data for each subject passed in the subjstructs field (see also INPUT).
%
%   The subjstructs.trielectrodes and vcontribs are output of the
%   projectElectrodes and electrodesContributions functions, respectively.
%
%   Each subjectstructs(i).activation matrix NsubjxLsubj may consist of 
%   different number of activations Lsubj; however, it must consists of 
%   equal number of electrodes Nsubj as is the length of
%   subjectstructs(i).electrodes.
%
%   The activations can be displayed sequentially as specified by range.
%
%
%   CALLING SEQUENCE:
%       activateBrain( M, vcontribs, subjstructs, range, cmapstruct, viewstruct )
%
%   INPUT:
%       M:              struct('vert', Vx3matrix, 'tri', Tx3matrix) - brain model (eventually the one altered by projectElectrodes, see <help projectElectrodes>)
%       vcontribs:      struct('vertNo', index, 'contribs', [subj#, el#, mult;...]) - structure containing the vertices that are near the electrode grids; this structure contains the multipliers
%       subjstructs:    field of structures, for each subject: struct('activations', NsubjxLsubjMatrix, 'trielectrodes', Nsubjx1Matrix) - enhanced subjstructs (output of projectElectrodes), where 'trielectrodes' is a matrix of coordinates of the projected electrodes
%       range:          vector specifying which samples of the activation data matrix are to be sequentially displayed; its maximum value is {min(Lsubj) for all subj}
%       cmapstruct:     controls the mapping of the values onto the colorbar, see cmapstruct below
%       viewstruct:     specifies the viewing properties, see below
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
%   Example:    
%       activateBrain( M, vcontribs, subjstructs, 1, cmapstruct, viewstruct )
%           see cmapstruct and viewstruct example (usual) values above
%
%   See also DEMO, PROJECTELECTRODES, ELECTRODESCONTRIBUTIONS, RECORDBRAIN.

%   Author: Jan Kubanek
%   Institution: Czech Technical University in Prague
%   Date: August 2005
%   This procedure is a part of the activeBrain Matlab package which was
%   designed for internal purposes of the BCI group at the Wadsworth Institute,
%   Albany, NY.



%Data for the visualization of the electrodes
markers = 'o+*.xsd^v><ph'; %electrode marker type for each subject
colours = {'r', 'g', 'b', 'y'};

Ss = length(subjstructs);
Mm = length(M.vert);

La = length(vcontribs);
actvert = zeros(La, 1);
for a = 1 : La,
    actvert(a) = vcontribs(a).vertNo;
end

C = zeros(La, 1); %zero vector of activation colours
Cindexed = nan(Mm, 1); %NaN vector of activation colours, numbers inserted where appropriate

%The loop is subject to Matlab6.5 JIT acceleration (although trisurf is not a built-in function):
fprintf('Computing the activations....');
cix = 0;
for r = range, %for specified activation samples
    for a = 1 : La, %for all activated vertices
        contribs = vcontribs(a).contribs; %reallocate for speed
        subjcontr = zeros(Ss, 1); %maximum number of subjects that are able to contribute to the averaging process at a vertex
        sci = 0; %index into subjcontr
        while ~isempty(contribs),
            sci = sci + 1;
            subjNo = contribs(1, 1);
            subjcontrIx = find(contribs(:, 1) == subjNo);
            elNos = contribs(subjcontrIx, 2);
            multips = contribs(subjcontrIx, 3);
            activs = subjstructs(subjNo).activations(elNos, r);
            subjcontr(sci) = activs' * multips;
            contribs(subjcontrIx, :) = [];
        end
        
        cix = cix + 1;
        C(cix) = sum(subjcontr) / sci; %the mean value
    end
    fprintf('done\n');
    fprintf('Displaying....');
    
%Prepare for plotting
    hold on;
    
%Adjust the color values and the colormap
    cmap = cmapstruct.cmap;
    grey = cmapstruct.basecol;        
    ixg2 = cmapstruct.ixg2;
    ixg1 = cmapstruct.ixg1;
    cmin = cmapstruct.cmin;
    cmax = cmapstruct.cmax;
    
    cmapL = length(cmap);
    
    if cmapstruct.enablecolormap,
        if cmapstruct.fading,
            ixL = ixg2 - ixg1 + 1;
            ixLm = floor(ixL/2);
            highmult = zeros(ixL, 1);
            lowmult = zeros(ixL, 1);
            highmult(1 : ixLm) = (ixLm - 1: -1 : 0) / ixLm;
            lowmult(ixLm + 1 : ixL) = (0 : 1 : (ixL - ixLm) - 1) / (ixL - ixLm);
            centermult = 1 - highmult - lowmult;
            li = 1; hi = ixL;
            
            ixbrainc = (ixg2 + ixg1) / 2; %the basecol            
            if ixbrainc < 1, ixbrainc = 1; end
            if ixbrainc > cmapL, ixbrainc = cmapL; end
            
            if ixg1 < 1, hi = hi + ixg1 - 1; ixg1 = 1; end
            if ixg2 > cmapL, li = ixg2 - cmapL + 1; ixg2 = cmapL; end
            cpart = cmap(ixg2: -1 : ixg1, :);
            greyM = ones(hi - li + 1, 1) * grey;
            lowmultM = lowmult(li : hi) * ones(1, 3);
            highmultM = highmult(li : hi) * ones(1, 3);
            centermultM = centermult(li : hi) * ones(1, 3);    
            cpart2 = cpart .* highmultM + cpart .* lowmultM + greyM .* centermultM;
            cmap(ixg2 : -1 : ixg1, :) = cpart2;
            CindexedNIx = ((C - cmin) / (cmax - cmin) * cmapL) + 1;
            %adjust the index range so that it matches colorbar
            nic = find(CindexedNIx < 1);
            CindexedNIx(nic) = 1;
            nic = find(CindexedNIx > cmapL);
            CindexedNIx(nic) = cmapL;
            Cindexed(actvert) = CindexedNIx; %the values were computed for activated vertices only
        else
            cmap(1, :) = grey;
            %the 2 in the following overcomes the grey at 1:
            CindexedNIx = ((C - cmin) / (cmax - cmin) * cmapL) + 2;
            %adjust the index range so that it matches colorbar
            nic = find(CindexedNIx < 2);
            CindexedNIx(nic) = 2;
            nic = find(CindexedNIx > cmapL);
            CindexedNIx(nic) = cmapL;
            
            Cindexed(actvert) = CindexedNIx; %the values were computed for activated vertices only
            ixbrainc = 1; %the basecol
        end
            
        colormap(cmap);
        
        if cmapstruct.enablecolorbar,
            caxis([cmin, cmax]);
            cBar=colorbar('location','West');
            set(cBar,'YAxisLocation','left');
            set(cBar,'FontSize',6);
%             cBarPos=get(cBar,'Position');
%             set(cBar,'Position',cBarPos+[0.04 -0.01 -0.005 +0.02]);
        else
            cBar=[];
        end
    end


%Please specify viewstruct.what2view (see above in comments) to display the brain surface and/or the activations

%grey brain:
    I = strmatch('brain', viewstruct.what2view,'exact');
    if ~isempty(I),
        if ~exist('ixbrainc', 'var')
            disp('You are trying to display the brain but did not provide colormap (enablecolomap == false) information, setting to grey...');
            colormap('Bone');
            ixbrainc = 32;
        end
        
%        trisurf(M.tri, M.vert(:, 1), M.vert(:, 2), M.vert(:, 3), 'FaceVertexCData', ixbrainc, 'CDataMapping', 'direct', 'linestyle', 'none');
    end
    
%activations on it:
    I = strmatch('activations', viewstruct.what2view,'exact');
    if ~isempty(I),
        trisurf(M.tri, M.vert(:, 1), M.vert(:, 2), M.vert(:, 3), 'FaceVertexCData', Cindexed, 'FaceColor', 'interp', 'CDataMapping', 'direct', 'linestyle', 'none');
    end

    if viewstruct.enableaxis,
        axis equal;        
    else
        axis equal off;
    end
    view(viewstruct.viewvect);
    material(viewstruct.material);
    if viewstruct.enablelight,
        light('Position', viewstruct.lightpos, 'Style', 'infinite');
    end
    lighting(viewstruct.lightingtype);
    
%Please specify viewstruct.what2view (see above in comments) if you want to display the electrodes
    for k = 1 : Ss;
       %original electrode locations:       
       I = strmatch('electrodes', viewstruct.what2view,'exact');
       if ~isempty(I),
           patch(subjstructs(k).electrodes(:, 1), subjstructs(k).electrodes(:, 2), subjstructs(k).electrodes(:, 3), colours{k}, 'FaceColor', 'none', 'LineStyle', 'none', 'Marker', markers(k + Ss), 'MarkerEdgeColor', colours{k}, 'MarkerFaceColor', 'none');
       end
       
       %transformed electrode locations
       I = strmatch('trielectrodes', viewstruct.what2view,'exact');
       if ~isempty(I),
           patch(subjstructs(k).trielectrodes(:, 1), subjstructs(k).trielectrodes(:, 2), subjstructs(k).trielectrodes(:, 3), colours{k}, 'FaceColor', 'none', 'LineStyle', 'none', 'Marker', markers(k), 'MarkerEdgeColor', colours{k}, 'MarkerFaceColor', 'none');
       end
    
        fprintf('done\n');
    end

    hold off;
end
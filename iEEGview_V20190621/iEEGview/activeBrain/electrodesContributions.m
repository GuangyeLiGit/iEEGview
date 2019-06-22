function [ vcontribs ] = electrodesContributions( M, subjstructs, kernel, param, cutoff,dis_cutoff,handles)
%ELECTRODESCONTRIBUTIONS    Compute the coefficients of activated vertices.
%
%   Computes contribution values of subject electrode grids at affected brain
%   model vertices (those vertices that are near the electrodes as specified
%   by the parameters) - see also INPUT: kernel.
%
%   The output vcontribs is required by the
%   activateBrain( M, vcontribs, subjstructs, range, cmapstruct, viewstruct ) function
%
%
%   CALLING SEQUENCE:
%       [ vcontribs ] = electrodesContributions( M, subjstructs, kernel, param, cutoff)
%
%   INPUT:
%       M:              struct('vert', Vx3matrix) - brain model (eventually the one altered by projectElectrodes.m, see <help projectElectrodes>)
%       subjstructs:    field of structures, for each subject: struct('electrodes', Nsubjx3matrix)
%       kernel:         a function whose values (at a certain vertex distance from an electrode) is being used for the multiplication of the electrode value (the multiplication is done by activateBrain); the multiplier is understood to be the contribution of an electrode to the vertex
%           possible values: 'linear', 'gaussian'
%       param:          parameter of the kernel function
%                       (for 'linear', this is the point of the linear function at which it is zero; for 'gaussian', this is the standart deviation)
%       cut-off:        only those vertices vert whose distance(vert, electrode) < cuf-off are considered to be altered by a near electrode (the more distant ones will not be displayed by activateBrain)
%
%   OUTPUT:
%       vcontribs:      struct('vertNo', index, 'contribs', [subj#, el#, mult;...]) - structure containing the vertices that are near the electrode grids; this structure contains the multipliers
%
%   REMARK:
%       There are several electrodes on subject's electrode grid that can
%       contribute with its multipliers to a vertex; the contribution is then a 
%       scalar product (a weigted sum) of these multipliers and electrode values;
%       only the contributions of distinct subjects are averaged by activateBrain.
%
%   Example:
%       [ vcontribs ] = electrodesContributions( M, subjstructs, 'linear', 10, 10)
%           computes contributions using linear 'fade-out' function,
%           supposing that the interelectrode distance is 10 (the parameter
%           cutoff might be set to a higher value when using a single
%           subject (nicer smearing), but should be set equal to param for
%           multiple subject usage (so that zero values far from the
%           subject electrode do not contribute to the averaging at a
%           vertex close to the electrode of another subject)
%
%   See also DEMO, PROJECTELECTRODES, ACTIVATEBRAIN.

%   Author: Jan Kubanek
%   Institution: Czech Technical University in Prague
%   Date: August 2005
%   This procedure is a part of the activeBrain Matlab package which was
%   designed for internal purposes of the BCI group at the Wadsworth Institute,
%   Albany, NY.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Updated by Guangye Li @liguangye.hust@Gmail.com @USA @2018.02.01

%CONTRIBUTION PART---------------
%For the projected electrodes, compute the contribution values
Vv2 = length(M.vert);
affvert = [];
vcontribs = [];
NMAX = 1 / (sqrt(2*pi) * param); %precompute; value of the pdf at 0 shall be 1
Ss = length(subjstructs);
eleIndex = handles.ElectrodeIndex;
for subj = 1 : Ss,
   disp(sprintf('Computing the electrode contributions to the vertices:'));
   disp(sprintf('   processing subject %d', subj));   
   tmptext = get(handles.edit_State,'string');
    tmptext{end+1} = ['Computing the electrode contributions to the vertices:'];
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    tmptext{end+1} = ['   processing subject ', num2str(subj)];
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));pause(0.001);

   Ee = size(subjstructs(subj).electrodes, 1);
%    d_e_trie=zeros(1,Ee);
   for eg = 1 : Ee,
       disp(sprintf('      processing electrode %d', eg));       
       tmptext = get(handles.edit_State,'string');
        tmptext{end+1} = ['      processing electrode ', num2str(eg)];
        fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
        set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));pause(0.001);

       dvect = zeros(1, Vv2);
       disp(sprintf('           computing distances', eg));  
       tmptext = get(handles.edit_State,'string');
        tmptext{end+1} = ['           computing distances'];
        fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
        set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));pause(0.001);
        
       trielectrode = subjstructs(subj).trielectrodes(eg, :); %reallocate
%        electrodes=subjstructs(subj).electrodes(eg, :); 
       vert = M.vert; %reallocate
%        d_e_trie(eg)=norm(electrodes-trielectrode);
       for v = 1 : Vv2,
%       compute the distance ||eg - v||^2 and store into a vector dvect
           delta = trielectrode - vert(v, :);
           dvect(v) = delta * delta';
       end
       disp(sprintf('           OK', eg));  
       tmptext = get(handles.edit_State,'string');
        tmptext{end+1} = ['           OK'];
        fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
        set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));pause(0.001);
        
       disp(sprintf('           computing contributions', eg));       
        tmptext = get(handles.edit_State,'string');
        tmptext{end+1} = ['           computing contributions'];
        fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
        set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));pause(0.001);
        
        
%       find all vertices closevert that are closer to eg than sigma2
        if subjstructs(subj).seeg_pos==0
       closevert = find(dvect < cutoff^2);
        elseif subjstructs(subj).seeg_pos==Ee
            closevert = find(dvect < dis_cutoff^2);
        elseif subjstructs(subj).seeg_pos>0 && subjstructs(subj).seeg_pos<Ee
            if eg<=subjstructs(subj).seeg_pos
                closevert = find(dvect < dis_cutoff^2);
            else
                closevert = find(dvect < cutoff^2);
            end
        else
            error('Please check the parameter seeg_pos!');
        end
       if isempty(closevert),
           disp(sprintf('No close vertices from electrode %d of subject %d were found', eg, subj));
           tmptext = get(handles.edit_State,'string');
            tmptext{end+1} = ['No close vertices from electrode ',num2str(eg),' of subject ',subj,' were found'];
            fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
            set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));pause(0.001);
       end
            for k = 1 : length(closevert),
                vs = closevert(k); %so that special conditions do not need to be tested instead of "for vs = closevert"
                %           compute the contribution value mult of eg to vs by feeding the distance dvect(vs) into a normalized gaussian kernel function               
                switch kernel
                    case 'gaussian'
                        sigma = param;
                        mult = exp(-0.5 * dvect(vs) / sigma^2) / (sqrt(2*pi) * sigma * NMAX);
                    case 'linear'
                        x0 = sqrt(dvect(vs)); %sqrt and exp are built-in
                        if x0 > param 
                            mult = 0;
                        else
                            mult = (1 - x0 / param);
                        end
                    otherwise
                        tmptext = get(handles.edit_State,'string');
                           tmptext{end+1} = ['Error! Unknown kernel type. Please refer to <help electrodescontribs>.'];
                           fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
                           set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));pause(0.001);
                        error('Unknown kernel type. Please refer to <help electrodescontribs>.');
                end
                %           check whether vs already in affvert
                ix = find(affvert == vs);
                %           if yes
                %               add [subj, eg, mult] to its existing structure
                if ~isempty(ix),
                    vcontribs(ix).contribs = [vcontribs(ix).contribs; subj, eg, mult];
                    %           else
                    %               put [subj, eg, mult] to a newly created structure, put vs
                    %               into affvert
                else
                    vcontribs(end + 1).vertNo = vs;
                    vcontribs(end).contribs = [subj, eg, mult];
                    affvert(end + 1) = vs;
                end
            end
    
       disp(sprintf('           OK', eg));
       tmptext = get(handles.edit_State,'string');
       tmptext{end+1} = ['           OK'];
       fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
       set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));pause(0.001);      
   end
end
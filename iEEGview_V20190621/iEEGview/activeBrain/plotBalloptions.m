function plotBalloptions(tala,handles)
%UNTITLED Summary of this function goes here
%  By Guangye Li(liguangye.hust@Gmail.com)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ballRadius = str2double(get(handles.edit_BallRadius,'string'));
ballColor = str2num(get(handles.edit_BallColor,'string'));

ballRadius_Trielectrodes = str2double(get(handles.edit_BallRadius_Trielectrodes,'string'));
ballColor_Trielectrodes = str2num(get(handles.edit_BallColor_Trielectrodes,'string'));

handles.electrode_view = get(handles.popupmenu_ElectrodesView,'value');
if get(handles.checkbox_DP_Electrodes,'value')
    pos= tala.electrodes;
    if get(handles.checkbox_ColorAnalysis,'value')
        
        if tala.seeg_pos==size(tala.electrodes,1)
            for i=1:tala.seeg_pos
                elename=tala.electrodes_name{i};
                
                if ~isempty(strfind(elename,'ctx')) || ~isempty(strfind(elename,'cortex'))|| ~isempty(strfind(elename,'Cortex'))
                    plotBalls(pos(i,:),'r',ballRadius,handles);
                elseif ~isempty(strfind(elename,'WhiteMatter')) || ~isempty(strfind(elename,'wm')) || ~isempty(strfind(elename,'WM'))
                    plotBalls(pos(i,:),'g',ballRadius,handles);
                elseif ~isempty(strfind(elename,'Hippocampus'))
                    plotBalls(pos(i,:),[0.5 0.1 1],ballRadius,handles);
                elseif ~isempty(strfind(elename,'Amygdala'))
                    plotBalls(pos(i,:), [0 0.1 0.8],ballRadius,handles);
                elseif ~isempty(strfind(elename,'Putamen'))
                    plotBalls(pos(i,:), [0.9 0.9 0],ballRadius,handles);
                else
                    plotBalls(pos(i,:),[0 0 0],ballRadius,handles);
                end
                hold on;
            end
        elseif tala.seeg_pos==0 % ecog
            color=[];
            stdpath=[handles.ConfigurationPath.iEEGview_directory,'/iEEGview/StdbrainModel/MNI'];
            
            switch handles.cpm
                case 1
                    load([stdpath,'/MATLAB/Cortex_Center_aparc.mat']);
                case 2
                    load([stdpath,'/MATLAB/Cortex_Center_aparc2009.mat']);
                case 3
                    load([stdpath,'/MATLAB/Cortex_Center_DKT40.mat']);
            end
            for i=1:size(tala.electrodes,1)
                elename=tala.electrodes_name{i};
                for j=1:size(M(1).struct_names,1)
                    if ~isempty(strmatch(elename,M(1).struct_names{j},'exact'))
                        color(i,:)=M(1).table(j,1:3)/255;
                        
                    end
                end
                
            end
            plotBalls(pos,color,ballRadius,handles);
            
        else % seeg+ecog
            if handles.electrode_view==1 || handles.electrode_view==3
                for i=1:tala.seeg_pos
                    elename=tala.electrodes_name{i};
                    if ~isempty(strfind(elename,'ctx')) || ~isempty(strfind(elename,'cortex'))|| ~isempty(strfind(elename,'Cortex'))
                        plotBalls(pos(i,:),'r',ballRadius,handles);
                    elseif ~isempty(strfind(elename,'WhiteMatter')) || ~isempty(strfind(elename,'wm')) || ~isempty(strfind(elename,'WM'))
                        plotBalls(pos(i,:),'g',ballRadius,handles);
                    elseif ~isempty(strfind(elename,'Hippocampus'))
                        plotBalls(pos(i,:),[0.5 0.1 1],ballRadius,handles);
                    elseif ~isempty(strfind(elename,'Amygdala'))
                        plotBalls(pos(i,:), [0 0.1 0.8],ballRadius,handles);
                    elseif ~isempty(strfind(elename,'Putamen'))
                        plotBalls(pos(i,:), [0.9 0.9 0],ballRadius,handles);
                    else
                        plotBalls(pos(i,:),[0 0 0],ballRadius,handles);
                    end
                    hold on;
                end
            end
            if handles.electrode_view==2 || handles.electrode_view==3
                color=[];
                stdpath=[handles.ConfigurationPath.iEEGview_directory,'/iEEGview/StdbrainModel/MNI'];
                
                switch handles.cpm
                    case 1
                        load([stdpath,'/MATLAB/Cortex_Center_aparc.mat']);
                    case 2
                        load([stdpath,'/MATLAB/Cortex_Center_aparc2009.mat']);
                    case 3
                        load([stdpath,'/MATLAB/Cortex_Center_DKT40.mat']);
                end
                for j=1:size(tala.electrodes,1)-tala.seeg_pos
                    elename=tala.electrodes_name{j+tala.seeg_pos};
                    %                     color(j,:)=[0 0 0];
                    for k=1:size(M(1).struct_names,1)
                        if ~isempty(strmatch(elename,M(1).struct_names{k},'exact'))
                            color(j,:)=M(1).table(k,1:3)/255;
                            break;
                            
                        end
                    end
                    
                end
                plotBalls(pos(tala.seeg_pos+1:end,:),color,ballRadius,handles);
                
            end
        end
        
    else
        if tala.seeg_pos==size(tala.electrodes,1) || tala.seeg_pos==0
            
            plotBalls(pos,repmat(ballColor,size(pos,1),1),ballRadius,handles);
        else
            switch handles.electrode_view
                case 1
                    plotBalls(pos(1:tala.seeg_pos,:),repmat(ballColor,size(pos(1:tala.seeg_pos,:),1),1),ballRadius,handles);
                case 2
                    plotBalls(pos(tala.seeg_pos+1:end,:),repmat(ballColor,size(pos(tala.seeg_pos+1:end,:),1),1),ballRadius,handles);
                case 3 % seeg+ecog
                    plotBalls(pos,repmat(ballColor,size(pos,1),1),ballRadius,handles);
            end
        end
    end
end

if get(handles.checkbox_DP_Trielectrodes,'value')
    
    pos= tala.trielectrodes;
    if get(handles.checkbox_ColorAnalysis,'value')
        
        if tala.seeg_pos==size(tala.trielectrodes,1)
            for i=1:tala.seeg_pos
                elename=tala.electrodes_name{i};
                
                if ~isempty(strfind(elename,'ctx')) || ~isempty(strfind(elename,'cortex'))|| ~isempty(strfind(elename,'Cortex'))
                    plotBalls(pos(i,:),'r',ballRadius,handles);
                elseif ~isempty(strfind(elename,'WhiteMatter')) || ~isempty(strfind(elename,'wm')) || ~isempty(strfind(elename,'WM'))
                    plotBalls(pos(i,:),'g',ballRadius,handles);
                elseif ~isempty(strfind(elename,'Hippocampus'))
                    plotBalls(pos(i,:),[0.5 0.1 1],ballRadius,handles);
                elseif ~isempty(strfind(elename,'Amygdala'))
                    plotBalls(pos(i,:), [0 0.1 0.8],ballRadius,handles);
                elseif ~isempty(strfind(elename,'Putamen'))
                    plotBalls(pos(i,:), [0.9 0.9 0],ballRadius,handles);
                else
                    plotBalls(pos(i,:),[0 0 0],ballRadius,handles);
                end
                hold on;
            end
        elseif tala.seeg_pos==0 % ecog
            color=[];
            stdpath=[handles.ConfigurationPath.iEEGview_directory,'/iEEGview/StdbrainModel/MNI'];
            
            switch handles.cpm
                case 1
                    load([stdpath,'/MATLAB/Cortex_Center_aparc.mat']);
                case 2
                    load([stdpath,'/MATLAB/Cortex_Center_aparc2009.mat']);
                case 3
                    load([stdpath,'/MATLAB/Cortex_Center_DKT40.mat']);
            end
            for i=1:size(tala.trielectrodes,1)
                elename=tala.electrodes_name{i};
                for j=1:size(M(1).struct_names,1)
                    if ~isempty(strmatch(elename,M(1).struct_names{j},'exact'))
                        color(i,:)=M(1).table(j,1:3)/255;
                        break;
                        %                     else
                        %                         color(i,:)=[0 0 0];
                    end
                end
                
            end
            plotBalls(pos,color,ballRadius,handles);
            
        else % seeg+ecog
            if handles.electrode_view==1 || handles.electrode_view==3
                for i=1:tala.seeg_pos
                    elename=tala.electrodes_name{i};
                    if ~isempty(strfind(elename,'ctx')) || ~isempty(strfind(elename,'cortex'))|| ~isempty(strfind(elename,'Cortex'))
                        plotBalls(pos(i,:),'r',ballRadius,handles);
                    elseif ~isempty(strfind(elename,'WhiteMatter')) || ~isempty(strfind(elename,'wm')) || ~isempty(strfind(elename,'WM'))
                        plotBalls(pos(i,:),'g',ballRadius,handles);
                    elseif ~isempty(strfind(elename,'Hippocampus'))
                        plotBalls(pos(i,:),[0.5 0.1 1],ballRadius,handles);
                    elseif ~isempty(strfind(elename,'Amygdala'))
                        plotBalls(pos(i,:), [0 0.1 0.8],ballRadius,handles);
                    elseif ~isempty(strfind(elename,'Putamen'))
                        plotBalls(pos(i,:), [0.9 0.9 0],ballRadius,handles);
                    else
                        plotBalls(pos(i,:),[0 0 0],ballRadius,handles);
                    end
                    hold on;
                end
            end
            if handles.electrode_view==2 || handles.electrode_view==3
                color=[];
                stdpath=[handles.ConfigurationPath.iEEGview_directory,'/iEEGview/StdbrainModel/MNI'];
                
                switch handles.cpm
                    case 1
                        load([stdpath,'/MATLAB/Cortex_Center_aparc.mat']);
                    case 2
                        load([stdpath,'/MATLAB/Cortex_Center_aparc2009.mat']);
                    case 3
                        load([stdpath,'/MATLAB/Cortex_Center_DKT40.mat']);
                end
                for j=1:size(tala.electrodes,1)-tala.seeg_pos
                    elename=tala.electrodes_name{j+tala.seeg_pos};
                    for k=1:size(M(1).struct_names,1)
                        if ~isempty(strmatch(elename,M(1).struct_names{k},'exact'))
                            color(j,:)=M(1).table(k,1:3)/255;
                            break;
                   
                        end
                    end
                    
                end
                plotBalls(pos(tala.seeg_pos+1:end,:),color,ballRadius,handles);
                
            end
        end
    else
        if tala.seeg_pos==size(tala.electrodes,1) || tala.seeg_pos==0
            plotBalls(pos,repmat(ballColor_Trielectrodes,size(pos,1),1),ballRadius_Trielectrodes,handles);
            
        else
            switch handles.electrode_view
                case 1
                    plotBalls(pos(1:tala.seeg_pos,:),repmat(ballColor_Trielectrodes,size(pos(1:tala.seeg_pos,:),1),1),ballRadius_Trielectrodes,handles);
                case 2
                    plotBalls(pos(tala.seeg_pos+1:end,:),repmat(ballColor_Trielectrodes,size(pos(tala.seeg_pos+1:end,:),1),1),ballRadius_Trielectrodes,handles);
                case 3 % seeg+ecog
                    plotBalls(pos,repmat(ballColor_Trielectrodes,size(pos,1),1),ballRadius_Trielectrodes,handles);
            end
        end
    end
end

end



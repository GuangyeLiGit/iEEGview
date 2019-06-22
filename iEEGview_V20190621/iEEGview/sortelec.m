function [elecMatrix,elecInfo] = sortelec(handles)
% this function works on the active MATLAB figure

hold on;
h = datacursormode; 
done = 0;
ecog_done = 0;
elecNum = 0;
elecInfo=[];
disp('Click on the first electrode and hit enter');
disp('Enter = label electrode');
disp('0 = remove last electrode');
disp('1 = stop labeling');
disp('Please select 4 electordes per pin');

% c
tmptext = get(handles.edit_State,'string');
tmptext{end+1} = ['Click on the first electrode...'];
fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
tmptext{end+1} = ['Click OK to confirm the selection or Select again'];
fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
tmptext{end+1} = ['Please select 4 electordes per pin...'];
fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
tmptext{end+1} = [];
fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end))

% probably going to change this so 0 means stop and any other number means
% remove that electrode from matrix
global SelectionResponse;
set(handles.uipanel_ChannelSelection,'visible','on');
set(handles.pushbutton_SelectAgain,'visible','on');
switch handles.ElectrodeIndex
    case 1
        while ~done
            if mod(elecNum,4)==0
                pinnum=inputdlg('Type in a pin name (click OK without typing to stop selection):'); %c
                pinnum = pinnum{1}; %c
                if isempty(pinnum)
        %             tmpMessage = ['All electrodes selected? Then Press 1 to finish!'];
                    SelectionResponse.StopSelectionFlag = 1;
                    message = ['All sEEG electrodes selected?'];
                    set(handles.pushbutton_SelectAgain,'visible','off');
        %             disp(tmpMessage);
                else
        %             tmpMessage = 'Click OK without input to confirm the slection. Press 0 to select this electrode again.';
                    SelectionResponse.StopSelectionFlag = 0;
                    message = 'Confirm the selection?';
                end
                set(handles.text_SelectInformation,'String',message);
            end
            if mod(elecNum,4)~=0 || (mod(elecNum,4)==0 && ~isempty(pinnum)) %c
                m = sprintf('Select sEEG electrode %d', elecNum + 1);
                disp(m);
                % c
                tmptext = get(handles.edit_State,'string');    
                tmptext{end+1} = ['Select sEEG electrode ' num2str(elecNum + 1) '...'];
                set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end))

            end %c
        %     userResponse = input('');
            uiwait(handles.figure1);
        %     SelectionResponse.flag = 0;
        %     while ~SelectionResponse.flag % if there is not any reponse, wait
        %     end
        %     userResponse = ChannelSelection_GUI(StopSelectionFlag);
        %     userResponse = str2num(userResponse);
            if isempty(SelectionResponse.Response) % if enter was pressed before any typing     
                cursor = getCursorInfo(h); % store cursor location
                elecNum = elecNum + 1;            
                % write label on figure and store handle in t
                figure(handles.figure_ele);
                t(elecNum)=text(cursor.Position(1), cursor.Position(2), cursor.Position(3),... % position
                    num2str(elecNum),... % number
                    'FontSize', 15,...
                    'Color', 'red',...
                    'BackgroundColor', [.7 .9 .7],...
                    'HorizontalAlignment', 'center',...
                    'VerticalAlignment', 'middle',...
                    'FontWeight', 'bold'); %#ok<*SAGROW> removes warning for t
                elecMatrix(elecNum, 1) = cursor.Position(1);
                elecMatrix(elecNum, 2) = cursor.Position(2);
                elecMatrix(elecNum, 3) = cursor.Position(3);
                elecInfo.loc{elecNum}=elecMatrix(elecNum,:);
                elecInfo.name{elecNum}=pinnum;

            elseif SelectionResponse.Response == 0 && elecNum ~= 0 % remove last electrod
                delete(t(elecNum)); % remove from figure
                elecNum = elecNum - 1;
                if elecNum
                    elecMatrix = elecMatrix(1:elecNum, :); % remove from matrix
                    pinnum=elecInfo.name{elecNum};
                else
                    elecMatrix = [];
                    pinnum = [];
                end
                figure(handles.figure_ele);
            elseif SelectionResponse.Response == 1 % stop labeling
                datacursormode off;            
                saveas(gcf,[handles.ConfigurationPath.subject_directory '/Electrodes/ElectrodesMarker'],'fig');
                done = 1;
        %         close;
            end   
        end
    case 2
        while ~done
            m = sprintf('Select ECoG electrode %d', elecNum + 1);
            disp(m);
            tmptext{end+1} = ['Select ECoG electrode ' num2str(elecNum + 1) '...' ];
            fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
%             tmptext{end+1} = [];
%             fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
            set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end))
            set(handles.pushbutton_SelectStop,'visible','on');
            SelectionResponse.StopSelectionFlag = 0;
%             userResponse = input('');
            uiwait(handles.figure1);

            if isempty(SelectionResponse.Response) % if enter was pressed before any typing

                cursor = getCursorInfo(h); % store cursor location

                elecNum = elecNum + 1;

                % write label on figure and store handle in t
                figure(handles.figure_ele);
                t(elecNum)=text(cursor.Position(1), cursor.Position(2), cursor.Position(3),... % position
                    num2str(elecNum),... % number
                    'FontSize', 15,...
                    'Color', 'red',...
                    'BackgroundColor', [.7 .9 .7],...
                    'HorizontalAlignment', 'center',...
                    'VerticalAlignment', 'middle',...
                    'FontWeight', 'bold'); %#ok<*SAGROW> removes warning for t

                elecMatrix(elecNum, 1) = cursor.Position(1);
                elecMatrix(elecNum, 2) = cursor.Position(2);
                elecMatrix(elecNum, 3) = cursor.Position(3);
                elecInfo.loc{elecNum}=elecMatrix(elecNum,:);
                elecInfo.name{elecNum}=num2str(elecNum);
            elseif SelectionResponse.Response == 0 && elecNum ~= 0 % remove last electrode

                delete(t(elecNum)); % remove from figure
                elecNum = elecNum - 1;
                if elecNum
                    elecMatrix = elecMatrix(1:elecNum, :); % remove from matrix
%                     pinnum=elecInfo.name{elecNum};
                else
                    elecMatrix = [];
%                     pinnum = [];
                end
                figure(handles.figure_ele);
%                 elecMatrix = elecMatrix(1:elecNum, :); % remove from matrix

            elseif SelectionResponse.Response == 1 % stop labeling
                datacursormode off;
                saveas(gcf,[handles.ConfigurationPath.subject_directory '/Electrodes/ElectrodesMarker'],'fig');
                done = 1;         
            end       
        end

    case 3
%         first select the SEEG electrode and then the ECoG
        fprintf('Notes: Please first select the SEEG electrode\n');
        fprintf('Once finishing the selection and then input 1 !\n');
        fprintf('Then please select the ECoG electrode!\n');
        fprintf('Please hit ''space'' to continue~ \n');
        
        tmp = ['Notes: Please first select the SEEG electrode. '...
            'Once finishing the selection then please select the ECoG electrode!'];
        tmptext = get(handles.edit_State,'string');
        tmptext{end+1} = tmp;
        fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
        set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end))
        
%         input('');
        disp('Now start select SEEG electrodes.')
        tmptext = get(handles.edit_State,'string');
        tmptext{end+1} = 'Now start select SEEG electrodes...';
        fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
        set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end))
        
        disp('Please select 4 contacts per each electrode shaft');
        tmptext = get(handles.edit_State,'string');
        tmptext{end+1} = 'Please select 4 contacts per each electrode shaft...';
        fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
        set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));
        
        seeg_done=0;
        ecog_done=0;
        elecNum_ecog=0;
        elecMatrix_ecog=[];
        elecInfo_ecog=[];
        
        set(handles.pushbutton_SelectStop,'visible','off');
        
        while ~seeg_done
            if mod(elecNum,4)==0
                pinnum=inputdlg('Type in a pin name (click OK without typing to stop selection):'); %c
                pinnum = pinnum{1}; %c
                if isempty(pinnum)
        %             tmpMessage = ['All electrodes selected? Then Press 1 to finish!'];
                    SelectionResponse.StopSelectionFlag = 1;
                    message = ['All sEEG electrodes selected?'];
                    set(handles.pushbutton_SelectAgain,'visible','off');
        %             disp(tmpMessage);
                else
        %             tmpMessage = 'Click OK without input to confirm the slection. Press 0 to select this electrode again.';
                    SelectionResponse.StopSelectionFlag = 0;
                    message = 'Confirm the selection?';
                end
                set(handles.text_SelectInformation,'String',message);
            end
            if mod(elecNum,4)~=0 || (mod(elecNum,4)==0 && ~isempty(pinnum)) %c
                m = sprintf('Select sEEG electrode %d', elecNum + 1);
                disp(m);
                % c
                tmptext = get(handles.edit_State,'string');    
                tmptext{end+1} = ['Select sEEG electrode ' num2str(elecNum + 1) '...'];
        %         tmptext{end+1} = [];
                set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end))

            end %c
        %     userResponse = input('');
            uiwait(handles.figure1);
        %     SelectionResponse.flag = 0;
        %     while ~SelectionResponse.flag % if there is not any reponse, wait
        %     end
        %     userResponse = ChannelSelection_GUI(StopSelectionFlag);
        %     userResponse = str2num(userResponse);
            if isempty(SelectionResponse.Response) % if enter was pressed before any typing     
                cursor = getCursorInfo(h); % store cursor location
                elecNum = elecNum + 1;            
                % write label on figure and store handle in t
                figure(handles.figure_ele);
                t(elecNum)=text(cursor.Position(1), cursor.Position(2), cursor.Position(3),... % position
                    num2str(elecNum),... % number
                    'FontSize', 15,...
                    'Color', 'red',...
                    'BackgroundColor', [.7 .9 .7],...
                    'HorizontalAlignment', 'center',...
                    'VerticalAlignment', 'middle',...
                    'FontWeight', 'bold'); %#ok<*SAGROW> removes warning for t
                elecMatrix(elecNum, 1) = cursor.Position(1);
                elecMatrix(elecNum, 2) = cursor.Position(2);
                elecMatrix(elecNum, 3) = cursor.Position(3);
                elecInfo.loc{elecNum}=elecMatrix(elecNum,:);
                elecInfo.name{elecNum}=pinnum;

            elseif SelectionResponse.Response == 0 && elecNum ~= 0 % remove last electrod
                delete(t(elecNum)); % remove from figure
                elecNum = elecNum - 1;
                if elecNum
                    elecMatrix = elecMatrix(1:elecNum, :); % remove from matrix
                    pinnum=elecInfo.name{elecNum};
                else
                    elecMatrix = [];
                    pinnum = [];
                end
                figure(handles.figure_ele);
%                 elecMatrix = elecMatrix(1:elecNum, :); % remove from matrix
%                 pinnum=elecInfo.name{elecNum};
            elseif SelectionResponse.Response == 1 % stop labeling
                datacursormode off;            
                saveas(gcf,[handles.ConfigurationPath.subject_directory '/Electrodes/ElectrodesMarker'],'fig');
                seeg_done = 1;
        %         close;
            end   
        end
        disp('Now please select ECoG electrodes! Press 1 once finishing');
        set(handles.pushbutton_SelectStop,'visible','on');
        set(handles.pushbutton_SelectAgain,'visible','on');
        set(handles.text_SelectInformation,'String','Select the ECoG electrode');
        SelectionResponse.StopSelectionFlag = 0;
        figure(handles.figure_ele);
        datacursormode on;
        while ~ecog_done
            m = sprintf('Select ECoG electrode %d', elecNum_ecog + 1);
            disp(m);
            tmptext = get(handles.edit_State,'string');   
            tmptext{end+1} = ['Select ECoG electrode ' num2str(elecNum_ecog) '...'];
            set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end))

%             userResponse = input('');
            uiwait(handles.figure1);

            if isempty(SelectionResponse.Response) % if enter was pressed before any typing

                cursor = getCursorInfo(h); % store cursor location

                elecNum_ecog = elecNum_ecog + 1;

                
                % write label on figure and store handle in t
                figure(handles.figure_ele);
                t(elecNum_ecog)=text(cursor.Position(1), cursor.Position(2), cursor.Position(3),... % position
                    num2str(elecNum_ecog),... % number
                    'FontSize', 15,...
                    'Color', 'red',...
                    'BackgroundColor', [.7 .9 .7],...
                    'HorizontalAlignment', 'center',...
                    'VerticalAlignment', 'middle',...
                    'FontWeight', 'bold'); %#ok<*SAGROW> removes warning for t

                elecMatrix_ecog(elecNum_ecog, 1) = cursor.Position(1);
                elecMatrix_ecog(elecNum_ecog, 2) = cursor.Position(2);
                elecMatrix_ecog(elecNum_ecog, 3) = cursor.Position(3);
                elecInfo_ecog.loc{elecNum_ecog}=elecMatrix_ecog(elecNum_ecog,:);
                elecInfo_ecog.name{elecNum_ecog}=num2str(elecNum_ecog);
            elseif SelectionResponse.Response == 0 && elecNum_ecog ~= 0 % remove last electrode

                delete(t(elecNum_ecog)); % remove from figure
                elecNum_ecog = elecNum_ecog - 1;
                if elecNum
                    elecMatrix_ecog = elecMatrix_ecog(1:elecNum_ecog, :); % remove from matrix
                else
                    elecMatrix_ecog = [];
                end
                figure(handles.figure_ele);
%                 elecMatrix_ecog = elecMatrix_ecog(1:elecNum_ecog, :); % remove from matrix

            elseif SelectionResponse.Response == 1 % stop labeling
                datacursormode off;
                saveas(gcf,[handles.ConfigurationPath.subject_directory '/Electrodes/ElectrodesMarker'],'fig');
                ecog_done = 1;         
            end       
        end
        elecInfo.loc=[elecInfo.loc,elecInfo_ecog.loc];
        elecInfo.name=[elecInfo.name,elecInfo_ecog.name];         
        elecInfo.seeg_points=elecNum;
        elecMatrix=[elecMatrix;elecMatrix_ecog];
    otherwise
        tmptext{end+1} = ['Error! Wrong Electrode Type!'];
        fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
        set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end))
        error('Wrong Electrode Type!');
        
end
set(handles.uipanel_ChannelSelection,'visible','off');
end

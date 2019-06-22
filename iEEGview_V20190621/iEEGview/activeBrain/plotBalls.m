function [] = plotBalls(electrodes, color, radius,handles)
%PLOTBALLS  Plots electrodes in assigned color
% R should be in the same number of electrodes.
lc=load([handles.ConfigurationPath.iEEGview_directory '/iEEGview/elec_colormap.mat']); % c
lc=lc.elec;
ELS = size(electrodes, 1);
R=[];
if isempty(color) && length(radius)>1 && length(unique(radius))~=1;
    ind=1;
    color=zeros(ELS,3);
    RR=linspace(0.2,5,ELS);
    R = radius; %sphere radius
else
    ind=0;
    if isempty(color)
     color='k';
    end
    R=unique(radius);
end
if size(color,1)==1
    color=repmat(color,ELS,1);
end


for els = 1 : ELS,    
    %original electrode locations:
    xe = electrodes(els, 1);
    ye = electrodes(els, 2);
    ze = electrodes(els, 3);
    %generate sphere coordinates (radius 1, 20-by-20 faces)
    [X, Y, Z] = sphere(100);
    if ind==1
        %place the sphere into the spot:
        color_index=round((radius(els)-min(radius))*length(lc)/(max(radius)-min(radius)));
        radius_index=round((radius(els)-min(radius))*length(RR)/(max(radius)-min(radius)));
        if color_index==0 ;
            color_index=1;
        end
        color(els,:)=lc(color_index,:);
        
         color(els,:)=[0.9,0,0];
        if radius_index==0;
            radius_index=1;
        end
       R(els)=RR(radius_index);   
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        X = R(els) * X + xe;
        Y = R(els)* Y + ye;
        Z = R(els)* Z + ze;
        hold on;
       surf(X, Y, Z,'FaceColor',color(els,:),'EdgeColor', 'none','facealpha',0.35);
        
    else
        X = R * X + xe;
        Y = R * Y + ye;
        Z = R * Z + ze;
        hold on;
        surf(X, Y, Z, 'FaceColor',color(els,:),'EdgeColor','none','facealpha',1);
    end
end

hold off;
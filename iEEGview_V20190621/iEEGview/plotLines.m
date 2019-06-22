function [ ] = plotLines(electrodes,name,number,color, thickness)
%PLOTBALLS  Plots electrodes in assigned color

ELS = size(electrodes, 1);
ELN= length(name);
if ELS~=ELN
    error('check the name and location number of electrodes~~ ');
end
m=0;

       for i=1:length(number)
           m=number{i}+m;
           plot3(electrodes(m-number{i}+1:m,1),electrodes(m-number{i}+1:m,2),electrodes(m-number{i}+1:m,3),'--','color',color,'LineWidth',thickness);          
%             text(electrodes(m,1)+4,electrodes(m,2)+4,electrodes(m,3)+3,name{m}(1),'Fontsize',14,'Fontweight','bold');
           hold on;
       end
       

end
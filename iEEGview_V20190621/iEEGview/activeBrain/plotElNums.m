function [ ] = plotElNums(electrodes, ch, fontsize)
%PLOTBALLS  Plots electrodes in assigned color

ELS = size(electrodes, 1);
for els = 1 : ELS,    
    %original electrode locations:
    X = electrodes(els, 1);
    Y = electrodes(els, 2);
    Z = electrodes(els, 3);
    elnum=sprintf('%d', ch(els));
    
    if nargin == 2
        text(X, Y, Z, elnum);
    else
        text(X, Y, Z, elnum,'FontSize',fontsize,'FontWeight','bold','color','b');
    end;
end

hold off;
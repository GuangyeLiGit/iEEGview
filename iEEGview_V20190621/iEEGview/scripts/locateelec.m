function [X_dat,Y_dat,Elec_Name_Show]=locateelec(VW,ELEC,SLN,Name)
    switch VW
        case 'A'
            elec_slice=round(ELEC(:,1));
            elec_cood=[2,3];
        case 'S'
            elec_slice=round(ELEC(:,2));
            elec_cood=[3,1];
        case 'C'
            elec_slice=round(ELEC(:,3));
            elec_cood=[2,1];
    end
    X_dat=[];
    Y_dat=[];
    Elec_Name_Show=[];
    if ~isempty(intersect(elec_slice,SLN))
        index_x=find(elec_slice==SLN);
        X_dat=ELEC(index_x,elec_cood(1));
        if VW=='A'
            Y_dat=repmat(256,length(index_x),1)-ELEC(index_x,elec_cood(2));            
        else
            Y_dat=ELEC(index_x,elec_cood(2));
        end
        Elec_Name_Show=Name(index_x);
    end
end
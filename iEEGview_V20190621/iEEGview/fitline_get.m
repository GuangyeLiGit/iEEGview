function [p,point_t]=fitline_get(A)
%%%%%%%%%%%%% function written by Guangye LI @2016.11.10 %%%%%%%%%%%%%%%
%%%% A is the pint array, 3 dimension
n=size(A,1);    
F=@(p)arrayfun(@(n)norm(cross(A(n,:)-[p(1),p(2),p(3)],[p(4),p(5),p(6)]))/norm([p(4),p(5),p(6)]),[1:size(A,1)]);
if n<=6
    OPTIONS = optimset('Algorithm','levenberg-marquardt');
    p=lsqnonlin(F,[1 1 1 1 1 1],[],[],OPTIONS);
else
    p=lsqnonlin(F,[1 1 1 1 1 1]);
end
P=A(1,:);
syms dd
%%%get plane  %%%%
[tt]=solve(p(4)*(p(1)+dd*p(4)-P(1))+p(5)*(p(2)+dd*p(5)-P(2))+p(6)*(p(3)+dd*p(6)-P(3))==0);

point_t=[p(1)+tt*p(4),p(2)+tt*p(5),p(3)+tt*p(6)];
point_t=eval(point_t);

%%%%%%check the direction vector of the line +up/-down %%%%%%%%%%%%%%%%%%%%
VEC=A(end,:)-A(1,:);
[val,ind]=max(abs(VEC));
if sign(VEC(ind))~=sign(p(3+ind))
    p(4:6)=-1*p(4:6);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
%%
 



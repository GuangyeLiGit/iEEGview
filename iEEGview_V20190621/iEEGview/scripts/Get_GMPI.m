%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% This script is used to calculate the Proximal Tissue Density (PTD)
%%%%% for each contact
%%%%% PTD=(nGray-nWhite)/(nGray+nWhite)
%%%%% by Li Guangye(liguangye.hust@gmail.com) @2017/12/29 @USA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
GMPI=[];
WMdis=white.vert(:,:)-repmat(trans(ele,:),length(white.vert),1);
GMdis=cortex.vert(:,:)-repmat(trans(ele,:),length(cortex.vert),1);
WMdisNorm=[];
GMdisNorm=[];
for iW=1:length(WMdis)
WMdisNorm(iW)=norm(WMdis(iW,:));
end
for jG=1:length(GMdis)
GMdisNorm(jG)=norm(GMdis(jG,:));
end

[mWMdis,mWMind]=min(WMdisNorm);
[mGMdis,mGMind]=min(GMdisNorm);
GMPI=dot((trans(ele,:)-white.vert(mWMind,:)),(cortex.vert(mGMind,:)-white.vert(mWMind,:)))/norm(cortex.vert(mGMind,:)-white.vert(mWMind,:));




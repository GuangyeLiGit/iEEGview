function Tstring = Time2String(T)
Tstring = [num2str(T.Year) '_' num2str(T.Month) '_' num2str(T.Day) '_' num2str(T.Hour) '_' num2str(T.Minute) '_' num2str(roundn(T.Second,0))];
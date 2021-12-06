function [sep,fin,fout,s] = compute_cluster_separability(filenames)

nfiles=length(filenames);
Sin=[];
Sout=[];
for i=1:nfiles
    load(filenames{i},'Ssorted','Bsorted');
    n=length(Ssorted);
    IDX_uppertriangle=triu(true(n),1);
    IDX_in=IDX_uppertriangle & sum(Bsorted,3)>0;
    IDX_out=IDX_uppertriangle & sum(Bsorted,3)==0;
    Sin=[Sin; Ssorted(IDX_in)];
    Sout=[Sout; Ssorted(IDX_out)];
end
s=linspace(0,1,200);
fin=ksdensity(Sin,s);
fin=fin/trapz(s,fin);
fout=ksdensity(Sout,s);
fout=fout/trapz(s,fout);
sep=acos(trapz(s,sqrt(fin).*sqrt(fout)));
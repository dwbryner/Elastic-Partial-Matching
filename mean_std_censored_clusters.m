function [fmean,qmean,tmean,fsig,qsig,fvar_avg,qvar_avg] = mean_std_censored_clusters(fk,qk,tk,labels,T)

nlabels=max(labels);

% Compute cross-sectional class means of SRVFs and variances
tmean=zeros(nlabels,T);
fmean=zeros(nlabels,T);
qmean=zeros(nlabels,T);
qsig=zeros(nlabels,T);
fsig=zeros(nlabels,T);
for i=1:nlabels
    [qmean(i,:),qsig(i,:),tmean(i,:)]=mean_censored_functions(qk(labels==i,:),tk(labels==i,:),T);
    [fmean(i,:),fsig(i,:),~]=mean_censored_functions(fk(labels==i,:),tk(labels==i,:),T);
end

% Avg cross-sectional variances for functions and for SRVFs
fvar=fsig.^2;
qvar=qsig.^2;
fvar_avg=zeros(nlabels,1);
qvar_avg=zeros(nlabels,1);
for i=1:max(labels)
%     g=fvar(i,fvar(i,:)>0);
    g=fvar(i,:);
    fvar_avg(i)=trapz(linspace(0,1,length(g)),g);
%     h=fvar(i,qvar(i,:)>0);
    h=qvar(i,:);
    qvar_avg(i)=trapz(linspace(0,1,length(h)),h);
end

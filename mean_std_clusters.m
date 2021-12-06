function [fmean,qmean,fsig,qsig,fvar_avg,qvar_avg] = mean_std_clusters(fk,qk,labels)

T=length(qk(1,:));
nlabels=max(labels);

% Compute cross-sectional class means of SRVFs and variances
fmean=zeros(nlabels,T);
qmean=zeros(nlabels,T);
qsig=zeros(nlabels,T);
fsig=zeros(nlabels,T);
for i=1:nlabels
    fmean(i,:)=mean(fk(labels==i,:),1);
    qmean(i,:)=mean(qk(labels==i,:),1);
    fsig(i,:)=std(fk(labels==i,:));
    qsig(i,:)=std(qk(labels==i,:));
end

% Avg cross-sectional variances
fvar=fsig.^2;
qvar=qsig.^2;
fvar_avg=zeros(nlabels,1);
qvar_avg=zeros(nlabels,1);
t=linspace(0,1,T);
for i=1:max(labels)
    fvar_avg(i)=trapz(t,fvar(i,:));
    qvar_avg(i)=trapz(t,qvar(i,:));
end
% mean_varcross=mean(qvar_avg(qvar_avg~=0));
clear
close all
clc

% Add all subfolders to path
addpath(genpath(pwd))

load USA_Euro_covid_data_30NOV2020
tid=linspace(0,1,T);
qk=zeros(K,T);
for k=1:K
    qk(k,:)=f_to_q(fk(k,:),tid);
end
qref=mean(qk);
dref=zeros(K,1);
for k=1:K
    dref(k)=sqrt(trapz(tid,(qk(k,:)-qref).^2));
end
[~,idxref]=min(dref);
qref=qk(idxref,:);
fkalign=zeros(K,T);
fkalign(idxref,:)=fk(idxref,:);
for k=1:K
    disp(num2str(k));
    if k~=idxref
        gam=DynamicProgrammingQ(qk(k,:),qref,0,1);
        fkalign(k,:)=spline(tid,fk(k,:),gam);
    end
end

figure(1); clf; hold on;
figure(2); clf; hold on;
for k=1:K
    figure(1); plot(tk(k,:),fk(k,:),'LineWidth',2);
    figure(2); plot(tid,fkalign(k,:),'LineWidth',2);
end
figure(1);
xlim([0 max(tk(:,end))]);
ylim([0 0.03]);
box;
xlabel('Days Since First Case');
ylabel('Normalized Infection Rate');
set(findall(gcf,'-property','FontSize'),'FontSize',16);
set(findall(gcf,'-property','FontName'),'FontName','times');
figure(2);
xlim([0 1]);
ylim([0 0.03]);
box;
xlabel('Scaled Time');
ylabel('Normalized Infection Rate');
set(findall(gcf,'-property','FontSize'),'FontSize',16);
set(findall(gcf,'-property','FontName'),'FontName','times');

        
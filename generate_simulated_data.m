clear; 
close all;
clc;

% Set parameters to generate Gaussian mixture model functions

T=100; % Number of sample points per function
num_per_class=17; % Number of functions per class
warping_amount=0.1; % Parameter to control amount of random diffeo warping
mu=[0.25 0.5 0.75]; % Means for Gaussian humps
sig2=[0.01 0.01 0.01]; % Variances for each Gaussian
alpha=[0.2 0.5 0.8; 0.5 0.5 0.5; 0.8 0.5 0.2]; % Gaussian mixture coeffs
[num_classes,~]=size(alpha); % Classes correspond to rows of alpha
K=num_per_class*num_classes; % Total number of functions in the dataset

%% Generate randomly warped Gaussian mixture model functions

[fk,qk,tk,gammak,labels_true] = simulate_censored_data(alpha,mu,sig2,...
    warping_amount,num_per_class,T);

% load sim_data

% save('sim_data.mat','fk','tk','qk','K','T','labels_true')


%% Plot data

clr=hsv(num_classes);

% Plot data colored according to class label
figure(1); clf; hold on;
for k=1:K
    plot(tk(k,:),fk(k,:),'color',clr(labels_true(k),:),'LineWidth',2);
end
xlim([0 max(tk(:,end))]);
ylim([0 0.81]);
xlabel('Time')
ylabel('Function Value')
set(findall(gcf,'-property','FontSize'),'FontSize',16)
set(findall(gcf,'-property','FontName'),'FontName','times')

% Plot classes in separate windows
figure(2); clf; ha=tight_subplot(1,3,0.03,0.1,0.01);
for k=1:K
    axes(ha(labels_true(k))); hold on;
    plot(tk(k,:),fk(k,:),'color',clr(labels_true(k),:));
    box on
    xlim([0 max(tk(:,end))]);
    ylim([0 0.81]);
    set(gca,'YTickLabel',[]);
%     xlabel('Depth')
%     ylabel('Speed of Sound (m/s)')
    title(['Class ' num2str(labels_true(k))]);
    set(findall(gcf,'-property','FontSize'),'FontSize',16)
    set(findall(gcf,'-property','FontName'),'FontName','times')
end
tid=linspace(0,1,T);
f1=alpha(1,1)*exp(-(tid-mu(1)).^2/sig2(1))+alpha(1,2)*exp(-(tid-mu(2)).^2/sig2(2))+...
    alpha(1,3)*exp(-(tid-mu(3)).^2/sig2(3));
% f1=f1/trapz(tid,f1);
axes(ha(1)); 
plot(tid,f1,'k--','LineWidth',2);
f2=alpha(2,1)*exp(-(tid-mu(1)).^2/sig2(1))+alpha(2,2)*exp(-(tid-mu(2)).^2/sig2(2))+...
    alpha(2,3)*exp(-(tid-mu(3)).^2/sig2(3));
% f2=f2/trapz(tid,f2);
axes(ha(2)); 
plot(tid,f2,'k--','LineWidth',2);
f3=alpha(3,1)*exp(-(tid-mu(1)).^2/sig2(1))+alpha(3,2)*exp(-(tid-mu(2)).^2/sig2(2))+...
    alpha(3,3)*exp(-(tid-mu(3)).^2/sig2(3));
% f3=f3/trapz(tid,f3);
axes(ha(3)); 
plot(tid,f3,'k--','LineWidth',2);



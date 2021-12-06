clear; 
close all;
clc;

% Add all subfolders to path
addpath(genpath(pwd))

% Load dataset
% load USA_Euro_covid_data_30NOV2020
load sim_data

tid=linspace(0,1,T);

% Set lambda parameter (used 0.25 for COVID data and 0.01 for sim data)
lambda=0.25;

%% Select data pair

idx=randsample(K,2);
% idx(1)=75;
% idx(2)=13;

t1=tk(idx(1),:);
t2=tk(idx(2),:);
f1=fk(idx(1),:); 
f2=fk(idx(2),:); 
q1=qk(idx(1),:);
q2=qk(idx(2),:);
c1=t1(end);
c2=t2(end);

[cmax,idxmax]=max([c1,c2]);

%% Compute preshape and shape distances

% Set grid
num_a=50;
agrid=exp(linspace(-log(2),log(2),num_a));

% Set gradient descent parameters
stepsize=1e-4;
tol=1e-3;
maxit=300;
plotevol=false;

% Compute preshape distance
Dp=preshape_distance(q1,q2,t1,t2,lambda);
disp(['c1 = ' num2str(c1)])
disp(['c2 = ' num2str(c2)])
disp(['Preshape Dist: ' num2str(Dp)])

% Compute shape distance (elastic)
q2e=f_to_q(f2,t1);
gam=DynamicProgrammingQ(q2e,q1,0,1);
gam=gam*c1;
q2enew=spline(t1,q2e,gam).*sqrt(gradient(gam,t1));
De=sqrt(trapz(t1,(q1-q2enew).^2));
f2new=spline(t1,f2,gam);
disp(['Elastic Dist: ' num2str(De)]);

% Compute shape distance (elastic partial matching)
% profile on
[Ds,f2best,q2best,t2best,g]=shape_distance(q1,t1,q2,t2,f2,lambda,tid,agrid,stepsize,...
    tol,maxit,plotevol);
% profile viewer
% profile off
disp(['Partial Elastic Dist: ' num2str(Ds)])
disp(['c2new = ' num2str(t2best(end))])



%% Plot results

clr=lines(4);

% Plot diffeomorphisms
figure(1); clf; hold on; 
b=min([t1(end),t2best(end)]);
plot(t1,gam,'color',clr(3,:),'LineWidth',2);
plot(t2best,g,'color',clr(4,:),'LineWidth',2);
plot(b,spline(t2best,g,b),'o','color',clr(4,:),'LineWidth',2,'MarkerSize',10);
axis equal tight;
box;
xlabel('t')
ylabel('g(t)')
legend('\gamma(t)','g(t)','Location','NorthWest');
set(findall(gcf,'-property','FontSize'),'FontSize',16);
set(findall(gcf,'-property','FontName'),'FontName','times');

% Plot functions
figure(2); clf; hold on;
plot(t1,f1,'color',clr(1,:),'LineWidth',4);
plot(t2,f2,'color',clr(2,:),'LineWidth',2);
plot(t1,f2new,'color',clr(3,:),'LineWidth',2);
plot(t2best,f2best,'color',clr(4,:),'LineWidth',2);
% xlim([0,max([c1,c2,t2best(end)])])
% ylim([0,0.04])
axis tight
box;
xlabel('t')
ylabel('f(t)')
% % Use this legend for COVID data
% legend(statenames{idx(1)},statenames{idx(2)},[statenames{idx(2)} ' (elastic)'],...
%     [statenames{idx(2)} ' (elastic, partial)'],'Location','northoutside'); 
% Use this legend for simulated data
legend('(c_1,f_1)','(c_2,f_2)','(c_2,f_2) (elastic)','(c_2,f_2) (partial elastic)','Location','northoutside')
set(findall(gcf,'-property','FontSize'),'FontSize',16)
set(findall(gcf,'-property','FontName'),'FontName','times')

% % Plot SRVFs
% figure(3); clf; hold on;
% plot(t1,q1,'color',clr(1,:),'LineWidth',4);
% plot(t2,q2,'color',clr(2,:),'LineWidth',2);
% plot(t1,q2enew,'color',clr(3,:),'LineWidth',2);
% plot(t2best,q2best,'color',clr(4,:),'LineWidth',2);
% % xlim([0,max([c1,c2,t2best(end)])])
% % ylim([0,0.04])
% axis tight
% box;
% xlabel('t')
% ylabel('f(t)')
% % legend(statenames{idx(1)},statenames{idx(2)},[statenames{idx(2)} ' (elastic)'],...
% %     [statenames{idx(2)} ' (elastic, partial)'],'Location','northoutside');
% legend('(c_1,f_1)','(c_2,f_2)','(c_2,f_2) (elastic)','(c_2,f_2) (partial elastic)','Location','northoutside')
% set(findall(gcf,'-property','FontSize'),'FontSize',16)
% set(findall(gcf,'-property','FontName'),'FontName','times')


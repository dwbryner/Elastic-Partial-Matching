clear
close all
clc

% Add all subfolders to path
addpath(genpath(pwd))

load USA_Euro_covid_data_30NOV2020

% Set lambda
lambda=0.25;

% Set grid
num_a=50;
agrid=exp(linspace(-log(2),log(2),num_a));

% Set gradient descent parameters
stepsize=1e-4;
tol=1e-3;
maxit=300;
plotevol=false;

% Select random function pairs to test
npairs=25;
idx=zeros(npairs,2);
A=false(K);
count=1;
while count<=npairs
    idx(count,1)=randsample(1:K-1,1);
    idx(count,2)=randsample(idx(count,1)+1:K,1);
    if ~A(idx(count,1),idx(count,2))
        A(idx(count,1),idx(count,2))=true;
        count=count+1;
    end
end

% Set T
T0=25;
nT=9;
T=round(T0*1.5.^(0:nT-1));


%% Computation time experiment

comptime_grid=zeros(npairs,nT);
comptime_grad_notinit=zeros(npairs,nT);
comptime_grad_init=zeros(npairs,nT);

for i=1:npairs
    
    disp(['Pair number: ' num2str(i)])
    
    for j=1:nT
        
        disp(['  T=' num2str(T(j))])
        
        t1=linspace(0,tk(idx(i,1),end),T(j));
        t2=linspace(0,tk(idx(i,2),end),T(j));
        f1=spline(tk(idx(i,1),:),fk(idx(i,1),:),t1);
        f2=spline(tk(idx(i,2),:),fk(idx(i,2),:),t2);
        q1=f_to_q(f1,t1);
        q2=f_to_q(f2,t2);
        
        % Compute alignment via grid search
        tic
        [~,q2best0,t2best0,~,~]=grid_search_align(q1,q2,t1,t2,lambda,agrid);
        comptime_grid(i,j)=toc;
        
        % Compute alignment via gradient descent
        tic
        [q2_gradnoinit,t2_gradnoinit,~,~,~,~]=gradient_descent_align(q1,t1,...
            q2,t2,lambda,stepsize,tol,maxit,plotevol);
        comptime_grad_notinit(i,j)=toc;
        
        % Update grid-search alignment via gradient descent
        tic
        [q2best,t2best,~,~,~,~]=gradient_descent_align(q1,t1,q2best0,...
            t2best0,lambda,stepsize,tol,maxit,plotevol);
        comptime_grad_init(i,j)=toc;
        
    end
    
end

        
%% Plot results

clr=lines(3);

figure(1); clf; hold on; 
plot(T,mean(comptime_grid),'.-','color',clr(1,:),'LineWidth',3,'MarkerSize',30);
plot(T,mean(comptime_grad_notinit),'.-','color',clr(2,:),'LineWidth',3,'MarkerSize',30);
plot(T,mean(comptime_grad_init),'.-','color',clr(3,:),'LineWidth',3,'MarkerSize',30);
set(gca,'Xscale','log','Yscale','log');
axis tight; decades_equal(gca);
box;
xlabel('Function Samples (T)')
ylabel('Average Computation Time (s)')
legend('Grid-Search','Gradient Descent - no init','Gradient Descent - init',...
    'Location','northoutside')
set(findall(gcf,'-property','FontSize'),'FontSize',16)
set(findall(gcf,'-property','FontName'),'FontName','times')









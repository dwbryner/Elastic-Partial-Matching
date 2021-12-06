clear
close all
clc

% Add all subfolders to path
addpath(genpath(pwd))

% Set gradient descent parameters
stepsize=1e-4;
tol=1e-3;
maxit=300;
plotevol=false;

% Set number of grid-points
num_a=50;
agrid=exp(linspace(-log(2),log(2),num_a));

%% Gradient descent initialization experiment on COVID data set

load USA_Euro_covid_data_30NOV2020

% Set lambda
lambda=0.25;

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

Ds_noinit_covid=zeros(npairs,1);
Ds_init_covid=zeros(npairs,1);

for i=1:npairs
    
    disp(['COVID pair number: ' num2str(i)])
    
    t1=tk(idx(i,1),:);
    t2=tk(idx(i,2),:);
    f1=fk(idx(i,1),:);
    f2=fk(idx(i,2),:);
    q1=qk(idx(i,1),:);
    q2=qk(idx(i,2),:);
    
    % Compute alignment via grid search
    [~,q2best0,t2best0,~,~]=grid_search_align(q1,q2,t1,t2,lambda,agrid);

    % Compute alignment via gradient descent
    [~,~,~,~,E,~]=gradient_descent_align(q1,t1,...
        q2,t2,lambda,stepsize,tol,maxit,plotevol);
    Ds_noinit_covid(i)=sqrt(E(end));

    % Update grid-search alignment via gradient descent
    [q2best,t2best,~,~,E,~]=gradient_descent_align(q1,t1,q2best0,...
        t2best0,lambda,stepsize,tol,maxit,plotevol);
    Ds_init_covid(i)=sqrt(E(end));
    
end

%% Gradient descent initialization experiment on simulated data set

load sim_data

% Set lambda
lambda=0.01;

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

Ds_noinit_sim=zeros(npairs,1);
Ds_init_sim=zeros(npairs,1);

for i=1:npairs
    
    disp(['Simulated pair number: ' num2str(i)])
    
    t1=tk(idx(i,1),:);
    t2=tk(idx(i,2),:);
    f1=fk(idx(i,1),:);
    f2=fk(idx(i,2),:);
    q1=qk(idx(i,1),:);
    q2=qk(idx(i,2),:);
    
    % Compute alignment via grid search
    [~,q2best0,t2best0,~,~]=grid_search_align(q1,q2,t1,t2,lambda,agrid);

    % Compute alignment via gradient descent
    [~,~,~,~,E,~]=gradient_descent_align(q1,t1,...
        q2,t2,lambda,stepsize,tol,maxit,plotevol);
    Ds_noinit_sim(i)=sqrt(E(end));

    % Update grid-search alignment via gradient descent
    [q2best,t2best,~,~,E,~]=gradient_descent_align(q1,t1,q2best0,...
        t2best0,lambda,stepsize,tol,maxit,plotevol);
    Ds_init_sim(i)=sqrt(E(end));
    
end

%% Plot results

figure(1); clf; hold on;
boxplot([Ds_noinit_sim, Ds_init_sim, Ds_noinit_covid, Ds_init_covid],...
    'labels',{'No Init, Simulated','Grid Init, Simulated',...
    'No Init, COVID','Grid Init, COVID'})
set(gca,'XTickLabelRotation',45)
ylabel('Average Shape Distance (d_s)')
set(findall(gcf,'-property','FontSize'),'FontSize',16)
set(findall(gcf,'-property','FontName'),'FontName','times')







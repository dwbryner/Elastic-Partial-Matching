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
J0=3;
nJ=8;
J=round(J0*2.^(0:nJ-1));

%% Grid-point experiment on COVID data set

load USA_Euro_covid_data_30NOV2020

% Set lambda
lambda=0.25;
tid=linspace(0,1,T);

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

Ds_covid=zeros(npairs,nJ);

for i=1:npairs
    
    disp(['COVID pair number: ' num2str(i)])
    
    t1=tk(idx(i,1),:);
    t2=tk(idx(i,2),:);
    f1=fk(idx(i,1),:);
    f2=fk(idx(i,2),:);
    q1=qk(idx(i,1),:);
    q2=qk(idx(i,2),:);
    
    for j=1:nJ
        
        disp(['  J=' num2str(J(j))])

        % Set grid
        agrid=exp(linspace(-log(2),log(2),J(j)));

        % Compute shape distance
        [Ds_covid(i,j),~,~,~,~]=shape_distance(q1,t1,q2,t2,f2,lambda,tid,agrid,stepsize,...
            tol,maxit,plotevol);
        
    end
end

%% Grid-point experiment on simulated data set

load sim_data

% Set lambda
lambda=0.01;
tid=linspace(0,1,T);

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

Ds_sim=zeros(npairs,nJ);

for i=1:npairs
    
    disp(['Simulated pair number: ' num2str(i)])
    
    t1=tk(idx(i,1),:);
    t2=tk(idx(i,2),:);
    f1=fk(idx(i,1),:);
    f2=fk(idx(i,2),:);
    q1=qk(idx(i,1),:);
    q2=qk(idx(i,2),:);
    
    for j=1:nJ
        
        disp(['  J=' num2str(J(j))])

        % Set grid
        agrid=exp(linspace(-log(2),log(2),J(j)));

        % Compute shape distance
        [Ds_sim(i,j),~,~,~,~]=shape_distance(q1,t1,q2,t2,f2,lambda,tid,agrid,stepsize,...
            tol,maxit,plotevol);
        
    end
end

%% Plot results

figure(1); clf; hold on;
plot(J,mean(Ds_sim),'.-','LineWidth',3,'MarkerSize',30)
plot(J,mean(Ds_covid),'r.-','LineWidth',3,'MarkerSize',30);
set(gca,'Xscale','log');
box;
xlabel('Grid Points (J)')
ylabel('Average Shape Distance (d_s)')
legend('Simulated Data','COVID Data','Location','northoutside')
set(findall(gcf,'-property','FontSize'),'FontSize',16)
set(findall(gcf,'-property','FontName'),'FontName','times')







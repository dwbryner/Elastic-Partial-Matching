clear
close all
clc

pathname=[pwd '\Covid Data\'];
filename='CONVENIENT_global_confirmed_cases.xlsx';
C=importdata([pathname filename]);
f=C.data;
[ndays,ncounties]=size(f);
statenames_rep=C.textdata(1,2:end);
statenames=unique(statenames_rep);
nstates=length(statenames);

% Create raw daily cases functions
g=zeros(ndays,nstates);
new_state=true;
k=0;
for i=1:ncounties
    if new_state
        k=k+1;
    end
    g(:,k)=g(:,k)+f(:,i);
    if i~=ncounties
        new_state=~strcmp(statenames_rep{i},statenames_rep{i+1});
    end
end
clear f;

% Convert raw data to seven-day moving avg
for k=1:nstates
    g(:,k)=smooth(g(:,k),7);
end
g(g<0)=0;
statenames=statenames';
g=g';

% % Keep only the 50 states + DC + PR
% discard=[3,10,14,15,40,53];
% statenames(discard)=[];
% g(discard,:)=[];

% Keep only the European countries, minus Kazakhstan, Liechtenstein, Vatican City, and
% Monaco 
keep=[2,4,8,10,11,16,17,22,26,44,46,47,48,58,62,63,66,67,69,78,79,84,86,...
    93,97,103,104,111,116,119,124,129,130,138,139,141,142,147,151,155,156,...
    161,165,166,176,179,181];
statenames=statenames(keep);
g=g(keep,:);

% Drop the last 6 days (Nov 30th endpoint), 67 days (Sept 30th endpoint),
% or 128 days (July 31 endpoint)
g=g(:,1:end-6); 
[K,Torig]=size(g);

% Plot unnormalized and normalized data
figure(1); clf; hold on;
figure(2); clf; hold on;
for k=1:K
    figure(1); plot(1:Torig,g(k,:),'LineWidth',2)
    figure(2); plot(1:Torig,g(k,:)/sum(g(k,:)),'LineWidth',2)
%     disp(statenames{k})
%     pause;
end

% Translate all curves so that time 0 is day of first case. Re-sample to
% have same number of sample points. Normalize to have integral 1. 
T=100; % Number of sample points
tk=zeros(K,T);
fk=zeros(K,T);
qk=zeros(K,T);
for k=1:K
    if sum(g(k,:)~=0)
        idx=find(g(k,:)>0);
        f=g(k,idx(1):Torig);
        n=length(f);
        t=0:n-1;
        tk(k,:)=linspace(0,n-1,T); % Translate
        fk(k,:)=spline(t,f,tk(k,:)); % Resample
        fk(k,:)=fk(k,:)/trapz(tk(k,:),fk(k,:)); % Normalize
        fk(k,fk(k,:)<0)=0;
        qk(k,:)=f_to_q(fk(k,:),tk(k,:)); % Compute SRVF
    end
end

% Plot preprocessed data
figure(3); clf; hold on;
for k=1:K
    plot(tk(k,:),fk(k,:),'LineWidth',2);
end
% xlim([0 max(tk(:,end))]);
% ylim([0 0.04]);
axis tight
box;
xlabel('Days Since First Case');
ylabel('Normalized Infection Rate');
set(findall(gcf,'-property','FontSize'),'FontSize',16);
set(findall(gcf,'-property','FontName'),'FontName','times');

% Save data
save('EURO_covid_data_30NOV2020.mat','tk','fk','qk','T','K','statenames');
    
%% Merge USA and Euro Data

clear;
load USA_covid_data_30NOV2020
tkusa=tk;
fkusa=fk;
qkusa=qk;
statenamesusa=statenames;
Kusa=K;
load Euro_covid_data_30NOV2020
tk=[tkusa;tk];
fk=[fkusa;fk];
qk=[qkusa;qk];
statenames=[statenamesusa;statenames];
K=K+Kusa;
statenames{11}='Georgia.';
statenames{64}='Czech Republic';
statenames{81}='Republic of Moldova';

save('USA_Euro_covid_data_30NOV2020.mat','tk','fk','qk','T','K','statenames');


    
    
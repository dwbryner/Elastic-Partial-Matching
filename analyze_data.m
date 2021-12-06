function analyze_data(In)


% Unpack input structure
datafile=In.datafile;
savefile=In.savefile;
metrictype=In.metrictype; 
if strcmp(metrictype,'partial')
    lambda=In.lambda;
    agrid=In.agrid;
    stepsize=In.stepsize;
    tol=In.tol;
    maxit=In.maxit;
    maxit_align=In.maxit_align;
end
iter=In.numIter_cluster; 
Minit=In.Minit; 
xi=In.xi_CRP;
theta_vect=In.theta_vect;

% Load data
load(datafile);

tid=linspace(0,1,T);

% Compute distance and similarity matrices
switch metrictype
    case 'L2'
        tk=repmat(tid,K,1);
        qk=zeros(K,T);
        for k=1:K
            qk(k,:)=f_to_q(fk(k,:),tid);
        end
        D=compute_distMat_L2(fk,tid);
    case 'elastic'
        tk=repmat(tid,K,1);
        qk=zeros(K,T);
        for k=1:K
            qk(k,:)=f_to_q(fk(k,:),tid);
        end
        D=compute_distMat_elastic(qk,tk);
    case 'partial'
        D=compute_distMat_partialElastic(fk,qk,tk,lambda,tid,agrid,stepsize,tol,maxit);
end
S=dist2sim(D);

% Bayesian clustering
[labels,labels_sorted,idx,Ssorted,Bsorted,clr]=BayesianClustering(S,...
    xi,theta_vect,Minit,iter);
Dsorted=D(idx,idx);

% Mutual alignment within clusters. Compute summary statistics.
switch metrictype
    case 'L2'
        fknew=fk;
        qknew=qk;
        tknew=tk;
        [fmean,qmean,fsig,qsig,fvar_avg,qvar_avg]=mean_std_clusters(fk,qk,labels);
        tmean=repmat(linspace(0,1,T),max(labels),1);
    case 'elastic'
        tknew=tk;
        [fknew,qknew]=align_within_clusters_elastic(fk,qk,labels);
        [fmean,qmean,fsig,qsig,fvar_avg,qvar_avg]=mean_std_clusters(fknew,qknew,labels);
        tmean=repmat(linspace(0,1,T),max(labels),1);
    case 'partial'
        [fknew,qknew,tknew]=align_within_clusters_partialElastic(fk,...
            qk,tk,lambda,tid,maxit_align,agrid,labels,stepsize,tol,maxit);
        [fmean,qmean,tmean,fsig,qsig,fvar_avg,qvar_avg]=mean_std_censored_clusters(fknew,qknew,...
            tknew,labels,3*T);
end

% Save data analysis results
switch metrictype
    case 'L2'
        save([savefile '_L2.mat'],'fk','qk','tk','D','S','labels',...
            'labels_sorted','idx','Ssorted','Bsorted','Dsorted','clr',...
            'fknew','qknew','tknew','fmean','qmean','tmean','fsig','qsig','fvar_avg','qvar_avg');
    case 'elastic'
        save([savefile '_elastic.mat'],'fk','qk','tk','D','S','labels',...
            'labels_sorted','idx','Ssorted','Bsorted','Dsorted','clr',...
            'fknew','qknew','tknew','fmean','qmean','tmean','fsig','qsig','fvar_avg','qvar_avg');
    case 'partial'
        save([savefile '_partialElastic.mat'],'fk','qk','tk','D','S','labels',...
            'labels_sorted','idx','Ssorted','Bsorted','Dsorted','clr',...
            'fknew','qknew','tknew','fmean','qmean','tmean','fsig','qsig','fvar_avg','qvar_avg','lambda');
end

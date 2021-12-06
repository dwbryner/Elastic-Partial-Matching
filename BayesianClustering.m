function [labels,labels_sorted,idx,Ssorted,Bsorted,clr] = BayesianClustering(S,...
    xi,theta_vect,Minit,iter)

 
K=length(S);
[~,W,~] = svd(S);
for k=1:K
    ratio = sum(diag(W(1:k,1:k)))/sum(diag(W));
    if (ratio>0.95)
        d = k;
        break;
    end;
end;
 
% Set hyperparameters
r0 = 6/d;
s0 = 8/d;

% Execute clustering algorithm
[labels,~]=WishartCluster(d,theta_vect,r0,s0,xi,iter,Minit,S);

% Reorganize S according to class labels
[labels_sorted,idx]=sort(labels);
Ssorted=S(idx,idx);

% Colormap for B
clr=hsv(max(labels));

% Compute class inclusion matrix (block diagonal)
Bsorted=zeros(K,K,3);
for i=1:K
    for j=1:K
        if labels_sorted(i)==labels_sorted(j)
            Bsorted(i,j,:)=clr(labels_sorted(i),:);
        end
    end
end
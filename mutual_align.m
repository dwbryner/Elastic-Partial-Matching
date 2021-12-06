function [qkhat,fkhat,tkhat,ckhat,gkhat] = mutual_align(qk,fk,tk,lambda,tid,maxit_align,...
    agrid,stepsize,tol,maxit)


[K,T]=size(qk);

% Sort functions according to increasing domain size
[~,idx]=sort(tk(:,end));
tk=tk(idx,:);
fk=fk(idx,:);
qk=qk(idx,:);

for i=1:maxit_align
    
    disp(['Iter: ' num2str(i)])
    
    % Initialize aligned functions
    qkhat=zeros(K,T);
    fkhat=zeros(K,T);
    tkhat=zeros(K,T);
    gkhat=zeros(K,T);
    
    % Align each q_k to q_K (the one with largest domain)
    q1=qk(K,:);
    t1=tk(K,:);
    for k=1:K-1
        
        disp(['  Aligning q_' num2str(k) ' to q_' num2str(K)])
        
        [~,fkhat(k,:),qkhat(k,:),tkhat(k,:),gkhat(k,:)]=shape_distance(q1,t1,qk(k,:),...
            tk(k,:),fk(k,:),lambda,tid,agrid,stepsize,tol,maxit,false);
        
    end
    fkhat(K,:)=fk(K,:);
    qkhat(K,:)=qk(K,:);
    tkhat(K,:)=tk(K,:);
    ckhat=tkhat(:,end);
    gkhat(K,:)=tid*ckhat(K);
%     keyboard;
     
    % Sort aligned functions according to increasing domain size
    [~,idx]=sort(ckhat);
    
    if idx(K)==K
        break
    else
        tk=tk(idx,:);
        qk=qk(idx,:);
        fk=fk(idx,:);
%         tkhat=tkhat(idx,:);
%         gkhat=gkhat(idx,:);
    end
    
end
% keyboard;
% [fkhat,qkhat,tkhat,gkhat]=center_alignment(fk,tk,tkhat,gkhat);
% ckhat=tkhat(:,end);

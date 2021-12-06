function [fk,qk,tk,gammak,labels] = simulate_censored_data(alpha,mu,sig2,...
    warping_amount,num_per_class,T)

[Nclass,~]=size(alpha);
K=Nclass*num_per_class;
t=linspace(0,1,T);
fk=zeros(K,T);
qk=zeros(K,T);
tk=zeros(K,T);
gammak=zeros(K,T);
[basis,~]=basis_tangent_id(1,t); % Create basis for generating random warpings
[Nbasis,~]=size(basis);
hid=ones(1,T);
labels=zeros(K,1);
k=0;

for i=1:Nclass
    for j=1:num_per_class
        k=k+1;
        labels(k)=i;
       
        % Censored function
        b=0.375*rand+0.625; % Hard coded censoring range
        tb=linspace(0,b,T);

    %     fb=1.5*exp(-2*tb).*(sin(8*pi*tb)+1);
    %     fb=(sin(8*pi*tb)+1);
    %     fb=exp(2*(tb-1)).*(sin(8*pi*tb)+1);
%         fb=alpha(i,1)*exp(-(tb-0.3).^2/0.015)+alpha(i,2)*exp(-(tb-0.7).^2/0.015);
%         fb=fb+0.02*sin(30*pi*tb);
        fb=alpha(i,1)*exp(-(tb-mu(1)).^2/sig2(1))+alpha(i,2)*exp(-(tb-mu(2)).^2/sig2(2))+...
            alpha(i,3)*exp(-(tb-mu(3)).^2/sig2(3));
    
        % Generate random domain scale factor a
        a=0.2*rand+0.9; % Hard coded scaling range
        tk(k,:)=linspace(0,a*b,T);
    
        % Generate random warping \gamma
        coeffs=warping_amount*randn(1,Nbasis);
        v=coeffs*basis;
        h=expmapping_sphere(hid,v,t); 
        while sum(h<=0)>0
            coeffs=warping_amount*randn(1,Nbasis);
            v=coeffs*basis;
            h=expmapping_sphere(hid,v,t); 
        end
        gammak(k,:)=cumtrapz(t,h.^2);
        gammak(k,:)=gammak(k,:)/gammak(k,end);

        % Create data
        fk(k,:)=spline(t,fb,gammak(k,:));
%         fk(k,:)=fk(k,:)/trapz(tk(k,:),fk(k,:));
        qk(k,:)=f_to_q(fk(k,:),tk(k,:));
        
    end
    
end

% % Order in increasing max t value
% [~,idx]=sort(tk(:,end));
% tk=tk(idx,:);
% qk=qk(idx,:);
% fk=fk(idx,:);
% gammak=gammak(idx,:);
% labels=labels(idx,:);

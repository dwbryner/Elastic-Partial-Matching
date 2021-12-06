function plot_sim_results(filenames)

Nfiles=length(filenames);
Nlabels=zeros(Nfiles,1);
for i=1:Nfiles
    load(filenames{i},'labels')
    nlabels=max(labels);
    Nlabels(i)=nlabels;
end
maxnlabels=max(Nlabels);

% Similarity matrices
figure(1); clf; ha1=tight_subplot(Nfiles,1,0.03,0.03,0.03);

% Clusters
figure(2*Nfiles+2); clf; ha2=tight_subplot(Nfiles,maxnlabels,0.01,0.01,0.01);

for i=1:Nfiles
    
    load(filenames{i});
    nlabels=max(labels);
    [K,~]=size(fk);
    
    % Plot similarity matrix
    figure(1); axes(ha1(i)); 
    imagesc(Ssorted); axis square; colorbar; colormap hot; 
    set(gca,'XTickLabel',[]);
    set(gca,'YTickLabel',[]);
    set(findall(gcf,'-property','FontSize'),'FontSize',16)
    set(findall(gcf,'-property','FontName'),'FontName','times')
    
    % Plot class inclusion matrix
    figure(i+1); imshow(Bsorted); axis tight;
    
    % Plot clusters
%     ymax=max(max(fknew));
    for k=1:K
        j=labels(k);
        xmax=max(tknew(labels==j,end));
        ymax=max(max(fknew(labels==j,:)));
        figure(2*Nfiles+2); axes(ha2((i-1)*maxnlabels+j)); hold on;
        plot(tknew(k,:),fknew(k,:),'color',clr(j,:));
        box on; xlim([0 xmax]); ylim([0 ymax]);
        set(gca,'YTickLabel',[]);
    end
    
    % Plot cluster means over cluster data
    for j=1:nlabels
        xmax=tmean(j,end);
        ymax=max(max(fknew(labels==j,:)));
        figure(2*Nfiles+2); axes(ha2((i-1)*maxnlabels+j)); hold on;
        plot(tmean(j,:),fmean(j,:),'k','LineWidth',2);
%         if sum(labels==j)>1
%             plot(tmean(j,:),fmean(j,:)+fsig(j,:),'color',[0.3,0.3,0.3]);
%             plot(tmean(j,:),fmean(j,:)-fsig(j,:),'color',[0.3,0.3,0.3]);
%         end
%         box on; xlim([0 xmax]); ylim([0 ymax]);
%         set(gca,'YTickLabel',[]);
    end
    
    % Display average cross-sectional variances for each cluster
    disp(['Avg Cross-Sect Var (File ' num2str(i) '):'])
    for j=1:nlabels
        disp(['  ' num2str(fvar_avg(j))]);
    end
    disp(['   Mean: ' num2str(mean(fvar_avg))])
    disp(' ')
    
end
    

    
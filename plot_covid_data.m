clear;
close all;
clc;

filenames={'USA_covid_data_31JULY2020.mat','USA_covid_data_30SEPT2020.mat','USA_covid_data_30NOV2020.mat',...
    'Euro_covid_data_31JULY2020.mat','Euro_covid_data_30SEPT2020.mat','Euro_covid_data_30NOV2020.mat',...
    'USA_Euro_covid_data_31JULY2020.mat','USA_Euro_covid_data_30SEPT2020.mat','USA_Euro_covid_data_30NOV2020.mat'};

for i=1:length(filenames)
    figure(i); clf; hold on;
    load(filenames{i});
    c=lines(K);
    for k=1:K
        if ~strcmp(statenames{k},'Kazakhstan')
            plot(tk(k,:),fk(k,:),'color',c(k,:));
        end
    end
    axis tight; box;
    xlabel('Days Since First Case')
    ylabel('Normalized Daily Cases')
    set(findall(gcf,'-property','FontSize'),'FontSize',16);
    set(findall(gcf,'-property','FontName'),'FontName','times');
    pngfile=filenames{i}(1:end-4);
    print('-dpng','-r300',pngfile)
end


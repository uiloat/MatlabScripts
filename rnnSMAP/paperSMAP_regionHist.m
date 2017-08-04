load('H:\Kuai\rnnSMAP\regionCase\distMat.mat')
stat='bias';
suffix='.jpg'
%dLst=min([d1Lst,d2Lst,d3Lst],[],2);
dLst=mean([d1Lst,d2Lst,d3Lst],2);
nCase=length(caseLst);
xLst=d1Lst;
figFolder='H:\Kuai\rnnSMAP\paper\';


caseSel=[1,3,7,8];
colorMat=[1,0,0;0,1,0;0,0,1;0,0,0];

figure('Position',[1,1,1600,1080])

%% box
labelLst1=[];
labelLst2=[];
dataLst=[];

for k=1:length(caseSel)
    indCase=caseSel(k);
    
    biasLSTM=statLSTM_test{indCase,2}.(stat);
    biasLSTM_noModel=statLSTM_test{indCase,3}.(stat);
    biasLR=statLR_test{indCase,2}.(stat);
    biasNN=statNN_test{indCase,2}.(stat);

    biasModel=statModel_train{indCase,1}.(stat);
    biasDiff=statDiff_test{indCase}.(stat);
    %biasDiff=statModel_test{indCase,1}.(stat)-statLSTM_test{indCase,2}.(stat);
    nTest=length(biasLSTM);
    nTrain=length(biasModel);
    
    dataLst=[dataLst;biasLSTM;biasLSTM_noModel;biasNN;biasModel;biasDiff;];
    labelLst1=[labelLst1;...
        repmat({'LSTM_Noah'},nTest,1);repmat({'LSTM_NoModel'},nTest,1);...
        repmat({'NN'},nTest,1);repmat({'Noah'},nTrain,1);repmat({'Diff'},nTest,1);];
    labelLst2=[labelLst2;repmat(caseLst(indCase),nTest*4+nTrain,1);];
end

subplot(2,1,1)
bh=boxplot(dataLst, {labelLst2,labelLst1},'colorgroup',labelLst2,...
    'factorgap',8,'factorseparator',1,'color','rgbk','Symbol','+',...
    'Widths',0.75);

set(bh,'LineWidth',2)
ylim([-0.15,0.15])
ylabel('Bias')
hline=refline([0,0]);
set(hline,'color',[0.2 0.2 0.2],'LineWidth',1.5,'LineStyle','-.')

%set(gca,'xtick',2.5:5.25:20)
%set(gca,'xticklabel',{'Case 1','Case 2','Case 3','Case 4'});
set(gca,'xticklabel',{' '});
text(2.5,-0.17,{'LSTM';'w/ Noah'},'fontsize',16,'HorizontalAlignment','center')
text(7.75,-0.17,{'LSTM';'w/o Noah'},'fontsize',16,'HorizontalAlignment','center')
text(13,-0.17,{'NN';'w/ Noah'},'fontsize',16,'HorizontalAlignment','center')
text(18.25,-0.17,{'Noah';'train'},'fontsize',16,'HorizontalAlignment','center')
text(23.25,-0.17,{'Self';'assessed'},'fontsize',16,'HorizontalAlignment','center')



%% hist
subplot(2,1,2)
for k=1:length(caseSel)
    indCase=caseSel(k);
    bin=[-0.25:0.05:0.2];
    biasModel_train=statModel_train{indCase,1}.(stat);
    nTrain=length(biasModel_train);
    c1 = histc(biasModel_train,bin);
    plot(bin,c1./nTrain,'-*','Color',colorMat(k,:),'LineWidth',3);hold on
    %[f,x] = ecdf(biasModel_train);
    %plot(x,f,'-*','Color',colorMat(k,:),'LineWidth',2);hold on
end
xlim([-0.25,0.15])
xlabel('Bias')
ylabel('Fraction')
legend('C1','C2','C3','C4')

fname=[figFolder,'\','regionHist'];
fixFigure([],[fname,suffix]);
saveas(gcf, [fname]);


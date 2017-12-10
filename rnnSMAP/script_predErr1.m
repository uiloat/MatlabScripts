
% post processing for Hucn1 cases. See if the difference of spatial test between withModel and
% noModel has anything to do with:
% 1.  rmse/bias of spatial test
% 2.  rmse/bias of model

%% read data
global kPath
matfileFolder='/mnt/sdb1/Kuai/rnnSMAP_outputs/MatFile/';
nHucLst=[1:6];
for kHuc=1:length(nHucLst)
    nHuc=nHucLst(kHuc);
    testName='CONUSv2f1';
    saveName=['hucv2n',num2str(nHuc)];
    saveMatFile=[matfileFolder,filesep,saveName,'_',testName,'_stat.mat'];
    matCONUS=load(saveMatFile);
    saveMatFile=[matfileFolder,filesep,saveName,'_stat.mat'];
    matHuc=load(saveMatFile);
    bModel=strcmp({matHuc.optLst.var},'varLst_Noah')';
    
    %% calculate
    indCase=find(bModel==1);
    stat1='rmse'; % for LSTM
    stat2='bias'; % for Model
    statLSTM=zeros(length(indCase),2);
    stdModelHuc=zeros(length(indCase),2);
    distModel=zeros(length(indCase),2);
    xEnds=[-0.1:0.01:0.1];
    
    for k=1:length(indCase)
        crdHuc=matHuc.crdMat{k};
        crdCONUS=matCONUS.crdMat{k};
        [indHuc,indCONUS]=intersectCrd(crdHuc,crdCONUS);
        indExt=[1:length(crdCONUS)]';indExt(indCONUS)=[];
        for iT=1:2
            statLSTM(k,iT)=nanmean(matCONUS.statMat.(stat1){k,iT}(indExt));
            
            biasModelHuc=matHuc.statModelMat.(stat2){k,iT};
            biasModelExt=matCONUS.statModelMat.(stat2){k,iT}(indExt);
            stdModelHuc(k,iT)=nanstd(biasModelHuc);
            distModel(k,iT)=KLD_arrays(biasModelHuc,biasModelExt,xEnds);
        end
    end
    
    %% plot
    subplot(2,3,kHuc)
    a=distModel(:,1)./stdModelHuc(:,1);
    b=statLSTM(:,1);
    plot(a,b,'bo');hold on
    lsline
    ylabel(stat1)
    title(['nHUC=',num2str(kHuc), '; R =',num2str(corr(a,b),'%.2f')]);
end
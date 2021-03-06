function testRnnSMAP_plot_select(outFolder,trainName,testName,iter,varargin)
% First test for trained rnn model. 
% plot nash/rmse map for given testset and click map to plot timeseries
% comparison between GLDAS, SMAP and RNN prediction. 

% example:
% outFolder='Y:\Kuai\rnnSMAP\output\PA\';
% trainName='PA';
% testName='PA';
% iter=2000;
% optSMAP: 1 -> real; 2 -> anomaly
% optGLDAS: 1 -> real; 2 -> anomaly; 0 -> no soilM

pnames={'optSMAP','optGLDAS'};
dflts={1,1};
[optSMAP,optGLDAS]=internal.stats.parseArgs(pnames, dflts, varargin{:});

%% predefine
figfolder=[outFolder,'/plot/',trainName,'_',testName,'_',num2str(iter),'/'];
if ~exist(figfolder,'dir')
    mkdir(figfolder)
end

%% read data
[outTrain,outTest,covMethod]=testRnnSMAP_readData(...
    outFolder,trainName,testName,iter);

if length(covMethod)==4
    symMethod={'b.','bo','g.','go'};    
elseif length(covMethod)==2
    symMethod={'b.','g.'};
end

for kk=1:2
    if kk==1
        out=outTrain;
    else
        out=outTest;
    end
%% calculate stat    
    statLSTM=statCal(out.yLSTM,out.ySMAP);
    statGLDAS=statCal(out.yGLDAS,out.ySMAP);
    for k=1:length(covMethod)
        mStr=covMethod{k};
        yTemp=out.(['y',mStr]);
        statCov(k)=statCal(yTemp,out.ySMAP);
    end

%% box plot
    if kk==1
        statBoxPlot(statLSTM,statGLDAS,statCov,covMethod,figfolder,'_Train')
    else
        statBoxPlot(statLSTM,statGLDAS,statCov,covMethod,figfolder,'_Test')
    end
end


end


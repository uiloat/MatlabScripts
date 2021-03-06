function data= readRnnPred2( outFolder,trainName,testName,iter)
% read prediction from testRnnSMAP.lua into a data.mat

% % example
% outFolder='Y:\Kuai\rnnSMAP\output\PA';
% trainName='PA';
% testName='PA';
% iter=2000;

testFolder=[outFolder,'\out_',trainName,'_',testName,'_',num2str(iter),'\'];

trainFile=dir([testFolder,'*_train.csv']);
testFile=dir([testFolder,'*_test.csv']);
dataMatFile=[testFolder,'\data.mat'];

dataTrain=[];
dataTest=[];
ind=0;
if exist(dataMatFile,'file')
    dataMat=load(dataMatFile);
    data=dataMat.data;
else
    for i=1:length(trainFile)
        % verify file order
        indtemp=str2num(trainFile(i).name(1:6));
        if indtemp<ind
            error('file not in order');
        end
        ind=indtemp;
        M=csvread([testFolder,trainFile(i).name]);
        dataTrain=[dataTrain,M];
        
        % verify file order
        indtemp=str2num(testFile(i).name(1:6));
        if indtemp<ind
            error('file not in order');
        end
        ind=indtemp;
        M=csvread([testFolder,testFile(i).name]);
        dataTest=[dataTest,M];
    end
    data=[dataTrain;dataTest];
    save(dataMatFile,'data');
end

end


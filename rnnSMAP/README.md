# rnnSMAP
code in this folder will do both pre-process and post-process of LSTM project
## pre-process
1. convert raw GLDAS and SMAP matfiles to csv that included all grid in CONUS
2. devide subset of CONUS database

## post-process
1. read SMAP predictions from LSTM code running in linux server
2. read forcing database and predict SMAP using LR, LRpbp, NN, NNpbp.
3. compute statatics between observation and predictions using multiple methods
4. plot boxplot and map of time series of results. 
***

# Pre-process
## 1 Raw Data
Raw data is saved in wrgroup folder (Y:\ here)
- **GLDAS**: ```Y:\GLDAS\Hourly\GLDAS_NOAH_mat\xxx.mat```
- **SMAP**: ```Y:\SMAP\SMP_L2_q.mat```
### code of raw data to csv
- function: [GLDAS2csv_CONUS.m](./GLDAS2csv_CONUS.m)
- script: [grid2csv_CONUS_script.m](./grid2csv_CONUS_script.m)

## 2 CONUS Database 
### 2.1 database location
- In workstation: ```E:\Kuai\rnnSMAP\Database\Daily\CONUS```
- In Linux Server ```/mnt/sdb1/rnnSMAP/database/CONUS```
### 2.2 database content
* **date.csv**\
dates of all time steps (520) in yyyymmdd

* **crd.csv**\
coordinate of all grids (12540). Column 1 for latitude and column2 for longitude. Each row refers a grid.

* **forcing**\
each variable is described by two files: **xxx.csv** and **xxx_stat.csv**. For example, SMAP.csv and SMAP_stat.csv
	- **xxx.csv**: of size [520*12540], each column is one grid and each row is one time step.
	- **xxx_stat.csv**: contains 4 numbers for lower bound (value of 10% in CONUS), upper bound (value of 90% in CONUS), mean and var. 
* **constant attribute**\
also two files: **const_xxx.csv** and **const_xxx_stat.csv**. For example, const_NDVI.csv and const_NDVI_stat.csv
	- **const_xxx.csv**: of size 12540, and each row is one grid.
	- **const_xxx_stat.csv**: same as forcing. 
	
## 3 subset of database
subset of databset is saved in another folder. For example **E:\Kuai\rnnSMAP\Database\Daily\CONUS_sub4**

available dividing functions
- divide subset by interval: [splitSubset_interval.m](./splitSubset_interval.m)
- divide subset by shapefile: [splitSubset_shapefile.m](./splitSubset_shapefile.m)
- divide subset by given crd: [splitSubset_crd.m](./splitSubset_crd.m)
- divide subset by NDVI, LULC: **not updated yet**

example script: [splitSubset_script.m](./splitSubset_script.m)

***

# Post-process
Example:  [script_testRnnSMAP.m](./script_testRnnSMAP.m) 

In this script two examples are included:
* [testRnnSMAP_plot.m](./testRnnSMAP_plot.m) : plot box of all methods of stat matrix.
* [testRnnSMAP_map.m](./testRnnSMAP_map.m) : plot map and clicking on which will show time series comparison.

Both of those two examples will go through following 4 steps.

1. read LSTM prediction: [readRnnPred.m](./readRnnPred.m)
2. regress using conventional methods [testRnnSMAP_readData.m](./testRnnSMAP_readData.m), which contains two steps:
	- read X and Y from database: [readDatabaseSMAP2.m](./readDatabaseSMAP2.m)
	- regress using conventional methods	
		- linear regression: [regSMAP_LR.m](./regSMAP_LR.m)
		- linear regression pbp: [regSMAP_LR_solo.m](./regSMAP_LR_solo.m)
		- NN: [regSMAP_NN.m](./regSMAP_NN.m)
		- NN pbp: [regSMAP_NN_solo.m](./regSMAP_NN_solo.m)
3. compute statatics matrix: [statCal.m](./statCal.m)
4. plot
	* box plot [statBoxPlot.m](./statBoxPlot.m)
	* map with clicking time series: see [testRnnSMAP_map.m](./testRnnSMAP_map.m) 


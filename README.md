# P300ClassifierComparator
Supporting Matlab algorithms for the "Methods for Signal Classification and their Application to the Design of Brain-Computer Interfaces" Ph.D. thesis (Lukáš Vařeka, 2018, Plzeň, Czech Republic)

## Requirements
* Matlab v2015 or higher (previous versions untested but can be working too) with the Neural Network Toolbox
* EEGLAB v13 or higher in Matlab path
* FileIO extension installed in EEGLAB to allow loading of BrainVision files
* both src and lib folders with their subfolders added into Matlab path
* P300 data are downloaded and located in the folders referenced from the analyzeAll script

## Running
The P300ClassifierComparator is a console application.
* src/metarun2.m - performs multiple trials of analyzeAll and creates statistics of the results
* src/analyzeAll.m - performs comparisons among different classifiers using training, validation and testing
* src/config.m - parameter configurations

## Used software libraries
* Aaron Garrett: Fuzzy ART and Fuzzy ARTMAP Neural Networks ( https://www.mathworks.com/matlabcentral/fileexchange/4306-fuzzy-art-and-fuzzy-artmap-neural-networks?focused=5055241&tab=function )
* BCILAB (https://sccn.ucsd.edu/wiki/BCILAB)
* Errorbar (https://www.mathworks.com/matlabcentral/fileexchange/47250-pierremegevand-errorbar-groups)
* E Akbas: Simplified Fuzzy ARTMAP Neural Network ( http://www.mathworks.com/matlabcentral/fileexchange/11721-simplified-fuzzy-artmap-neural-network?focused=5074268&tab=function )
* SOMTOOLBOX (http://www.cis.hut.fi/somtoolbox/)
* Neural Network Toolbox (https://www.mathworks.com/products/neural-network.html) - not a part of the lib folder

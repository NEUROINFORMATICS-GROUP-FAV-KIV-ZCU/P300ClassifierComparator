# P300ClassifierComparator
Supporting Matlab algorithms for the "Methods for Signal Classification and their Application to the Design of Brain-Computer Interfaces" Ph.D. thesis (Lukáš Vařeka, 2018, Plzeň, Czech Republic)

## Requirements
* Matlab v2015 or higher (previous versions untested but can be working too)
* EEGLAB v13 or higher in Matlab path
* FileIO extension installed in EEGLAB to allow loading of BrainVision files
* both src and lib folders with their subfolders added into Matlab path
* P300 data are downloaded and located in the folders referenced from the analyzeAll script

## Running
The P300ClassifierComparator is a console application.
* src/metarun2.m - performs multiple trials of analyzeAll and creates statistics of the results
* src/analyzeAll.m - performs comparisons among different classifiers using training, validation and testing
* src/config.m - parameter configurations


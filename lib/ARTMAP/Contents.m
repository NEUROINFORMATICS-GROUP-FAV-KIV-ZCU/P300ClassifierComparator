% Fuzzy ARTMAP Neural Network Implementation.
% Version 1.0  22-Dec-2003
% Author:
%     Aaron Garrett
%     Jacksonville State University
%     Jacksonville, AL  36265
%
% Functions included in this directory:
%    ARTMAP_Add_New_Category - Adds a new category to the ARTMAP network.
%    ARTMAP_Classify - Uses a trained ARTMAP network to classify a dataset.
%    ARTMAP_Create_Network - Creates the ARTMAP network.
%    ARTMAP_Learn - Trains a given ARTMAP network on a dataset.
%
% Functions required by this software:
%    ART_Activate_Categories - Required by ARTMAP_Classify and ARTMAP_Learn
%    ART_Calculate_Match - Required by ARTMAP_Classify and ARTMAP_Learn
%    ART_Complement_Code - Required if complement coding of inputs is used
%    ART_Update_Weights - Required by ARTMAP_Learn
%
% Description of the system architecture:
%    The above set of functions is used to create, train, and use an ARTMAP
%    network to classify a dataset. While all of the functions are 
%    necessary, only three of them are meant to be called by the user. 
%    Those functions are as follows:
%
%    Functions available to user:
%        ARTMAP_Classify
%        ARTMAP_Create_Network
%        ARTMAP_Learn
%
%    The remaining ARTMAP_Add_New_Category function is used to modularize 
%    the structure of the system. 
%
% For an example of the use of these functions, see ARTMAPExample.m in
% this directory.   
%
% Send comments to agarrett1@hotmail.com.

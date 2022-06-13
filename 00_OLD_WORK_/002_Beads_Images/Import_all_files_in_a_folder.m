function [filenames , OnlyFileNames] = Import_all_files_in_a_folder(file_extension , filepath , Input_Regular_Expression )
%
%   This function finds and returns the complete address of all the files
%   with a specified extension in a specified folder
%
%   INPUT:
%   FILE_EXTENSION: Type of file which you want to import. ('.txt' , '.mat' etc 
%   FILEPATH: Path of the Folder which contains the files
%
%   OUTPUT:
%   CALIB: The calibration factor in MICRONS PER PIXEL
%
%
%   EXAMPLE:
%   filenames = Import_all_files_in_a_folder(file_extension , filepath)
%
%
% WRITTEN BY
%
% Abhimanyu Dubey
% Joint Ph.D. student,
% Prof. V. Kumaran’s Lab
% Department of Chemical Engineering,
% IISc Bangalore, 
% Prof. Manaswita Bose’s Lab,
% Department of Energy Science and Engineering,
% IIT-BOMBAY

%% Default Inputs:

if nargin == 1
    import_directory    =       uigetdir ; 
    input_for_dir       =       [import_directory  , filesep , ['*' , file_extension]   ] ; 
elseif nargin == 2
    import_directory    =       filepath;
    input_for_dir       =       [import_directory  , filesep , ['*' , file_extension]   ] ; 
elseif nargin == 3
    import_directory    =       filepath;
    input_for_dir       =       string(import_directory) + string( filesep ) + string( Input_Regular_Expression ) ;
else
    fprintf(' \n\n\t\t At MAX, Three Inputs Allowed  \n\n\t\t Dumbass ||-_-|| \n\n\t\t Check your Input First Before calling me. \n\n\n' ) ; 
    return
end
    

%%  
direc           	=    dir( input_for_dir ) ; 
filenames           =    {} ; 
[filenames{1:numel(direc) , 1}] = deal( direc(~[direc.isdir]).name ) ; 
filenames           = sortrows(filenames) ; 
OnlyFileNames       =   filenames ; 
filenames = fullfile( import_directory , filenames ) ; 

end
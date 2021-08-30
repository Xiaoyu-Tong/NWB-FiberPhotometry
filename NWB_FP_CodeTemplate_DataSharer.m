%% Process MFP videos 
% First, use the interactive script "generateROIMask.m" to create your mask
% file if you have not done so yet.
% Afterwards,assign general info of your experiment
maskFile='C:/MatNWB/new_mask.mat';                                    % Change the path to your mask file
regions = {'BNSTp','AHN'};
MFPVideo = 'C:/MatNWB/Cam.seq';
MFPVideo = 'C:/Temp/Cam_1_72040.mp4';%Both seq and mp4 are supported
% If you only have an MFP video
MFPfile=processMFPVideo(maskFile, regions,MFPVideo);%A .mat file which contains MFP data will be saved beside the original MFP video with the same filename.
% If you also have a corresponding behavior video
behVideo='C:/MatNWB/Top.seq';
MFPfile=processMFPVideo(maskFile, regions,MFPVideo,'behVideo',behVideo);
% If you also have corresponding behavior annotation
MFPfile=processMFPVideo(maskFile, regions,MFPVideo,'behVideo',behVideo,'Fstart',Fstart,'Fstop',Fstop,'behaviors',behaviors);
%% Install NWB
% First, download NWB if you haven't done so 
% from https://github.com/NeurodataWithoutBorders/matnwb (Click the green
% download code button) and put it wherever you like, e.g., 'C:\MatNWB\matnwb-master'

% Then add NWB to your path:
addpath('C:\MatNWB\matnwb-master') % change the path to the folder where your NWB package locates
savepath();%Navigate to the folder you woule like to save
generateCore(); % Run the function. This is required by NWB.

%% Generate NWB file
% 1. Multi FP
%MFPFile='C:\MatNWB\MFP data\MFP-ERa-GC1_191010.mat';%path to your NWB file
NWBFile=contrib.FiberPhotometry.MFP2NWB(MFPfile);% A .nwb file will be generated beside the original MFP video & MAT file with the same name.

% 2. Single FP
region='BNSTp';%Specify the brain region of FP recording
% if you do not have corresponding behavior annotation:
NWBFile=contrib.FiberPhotometry.SFP2NWB(blockpath,region);%blockpath: path to TDT block.
% TDT block is a folder that contains individual TDT files (e.g. Tbk,Tdx,tev, tsq)
% if you have corresponding behavior annotation:
NWBFile=contrib.FiberPhotometry.SFP2NWB(blockpath,region,'behVideo',behVideo,'Fstart',Fstart,'Fstop',Fstop,'behaviors',behaviors);

%% Load NWB files
%NWBFile='C:\MatNWB\MFP data\MFP-ERa-GC1_191010.nwb';%path to your NWB file
nwb_read=nwbRead(NWBFile);%nwb_read will be a NwbFile object in workspace

%% Edit NWB files
% Edit general info (path/link to video file, animal info, lab info & FiberPhotometryArray)
nwb_read.general_notes='video_path: C:/videoname.seq';% Assign video path
nwb_read.general_subject=types.core.Subject('age','10 wk',...% Assign animal info
    'date_of_birth',datetime({'2021-01-01'},'InputFormat','yyyy-MM-dd'),...
    'description','no description',...
    'genotype','BALB/c',...
    'sex','male',...
    'species','Mus musculus',...% or just "mice"?
    'subject_id','mouse 1',...
    'weight','30g');
nwb_read.general_institution='Neuroscience Institute, NYU Langone Medical Center';
nwb_read.general_lab='Dayu Lin Lab';
%FiberPhotometryArray
nwb_read.acquisition.get('FiberPhotometryArray').num_arrays=3;% number of arrays
FParray1=types.core.FiberPhotometryArray('matrix',zeros(4,12));% edit the value of matrix to represent the implanted array
mat_array2=zeros(4,12);
mat_array2(1,5)=1;
mat_array2(2,7)=1;
FParray2=types.core.FiberPhotometryArray('matrix',mat_array2);
FParray3=types.core.FiberPhotometryArray('matrix',[1]);
nwb_read.acquisition.get('FiberPhotometryArray').arrays.set('array 1', FParray1); % the name 'array 1' can be edited to whatever name you like
nwb_read.acquisition.get('FiberPhotometryArray').arrays.set('array 2', FParray2);
nwb_read.acquisition.get('FiberPhotometryArray').arrays.set('array 3', FParray3);

% Edit FiberPhotometryInfo (coordinates, light, virus, fiber, description)
nwb_read.acquisition.get('VMHvl').info.Bregma_coordinates='some coordinates';
nwb_read.acquisition.get('AHN').info.description='none';
nwb_read.acquisition.get('AHN').info.light='473nm, 30uW, 390Hz modulated';
nwb_read.acquisition.get('AHN').info.optical_fiber='fiber info';
nwb_read.acquisition.get('AHN').info.virus='AAV2 EF1a-DIO-GCaMP6f (50nl, 1x 10e13 pfu/ml)';

%% Save Changes
nwbExport(nwb_read,NWBFile)% Edit the path and/or name of NWBFile if you do not want to overwrite the original NWB file
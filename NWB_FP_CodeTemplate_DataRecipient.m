% NWB Fiber Photometry Code Template
% Xiaoyu Tong, April 26th, 2021

%% Load NWB files
nwbFile='C:\MatNWB\MFP data\MFP-ERa-GC1_191010.nwb';%path to your NWB file
nwb_read=nwbRead(nwbFile);%nwb_read will be a NwbFile object in workspace
%% Retrieve data
% 1. FP Recording
data=nwb_read.acquisition.get('AHN').data.load;%data will be a (numFrames * 1) array
data=nwb_read.acquisition.get('VMHvl').data.load;%replace 'VMHvl' with other brain region names
% A full list of brain region names can be displayed by "nwb_read.acquisition"

% 2. Behavior Annotation
Fstart=nwb_read.intervals.get('Behavior Annotation').start_time.data.load;
Fstop=nwb_read.intervals.get('Behavior Annotation').stop_time.data.load;
behaviors=nwb_read.intervals.get('Behavior Annotation').vectordata.get('label').data.load;

% 3. General Info
nwb_read.general_notes % for video path/link
nwb_read.general_subject % animal info
nwb_read.general_institution % institution
nwb_read.general_lab % lab info
nwb_read.acquisition.get('FiberPhotometryArray').num_arrays % number of FiberPhotometryArray
nwb_read.acquisition.get('FiberPhotometryArray').arrays.get('array 1').matrix % array matrix. Edit name 'array 1' to retrieve other arrays

% 4. FiberPhotometry Info
nwb_read.acquisition.get('AHN').info % edit 'AHN' to the brain region of interest. Use further dot indexing to retrieve attributes
nwb_read.acquisition.get('AHN').info.Bregma_coordinates
nwb_read.acquisition.get('AHN').info.light
nwb_read.acquisition.get('AHN').info.optical_fiber
nwb_read.acquisition.get('AHN').info.virus
nwb_read.acquisition.get('AHN').info.description
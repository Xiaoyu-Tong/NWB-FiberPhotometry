function MFPmat=processMFPVideo(maskFile,regions,MFPVideo,varargin)

%% Assign general info
% load('mymask13-200913.mask','-mat');                                        % Change the path to your mask file
% regions = {'LSv','BNSTp','MPN','AHN','VMHvl','DMH','PMv','MeAa','MeAp',...  % Edit region names
%     'PA','CoAp','SUBv','lPAG'};
% MFPVideo = 'path to your MFP video file';
load(maskFile,'-mat');   
%% Data extraction
% Get the images from the Cam video seq file
p = inputParser;
addParameter(p,'behVideo','',@ischar);
addParameter(p,'Fstart',[],@isnumeric);
addParameter(p,'Fstop',[],@isnumeric);
addParameter(p,'behaviors',{},@iscell);
parse(p,varargin{:})

VideoFormat=MFPVideo(end-3:end);
matFile = regexprep(MFPVideo,VideoFormat,'.mat');
if strcmp(VideoFormat,'.seq')
    sr = seqIo(MFPVideo, 'reader');                                           % create interface for reading seq file
    info = sr.getinfo();                                         % create interface for reading seq file
    t = sr.getts(); t = t-t(1);                                                % get timestamps for all frames
    nFrames = info.numFrames; FL = info.fps;                                    % get total frame number & set frame rate as sampling frequency
    sr.seek(0);                                                                 % Set to the first frame and display image
    [thisFrame,~] = sr.getframe(); % imshow(thisFrame);
    for iMask=1:length(regions)
        RoiProps(iMask,1) = regionprops(logicmask.(regions{iMask}),thisFrame,'MeanIntensity');                % Calculate mean pixel intensity in each ROI in the first frame
    end
    % Apply defined ROIs to all frames and calculate mean pixel intensity
    for iFrame = 2:nFrames
        [thisFrame,~] = sr.getnext();
        for iMask=1:length(regions)
            RoiProps(iMask,iFrame) = regionprops(logicmask.(regions{iMask}),thisFrame,'MeanIntensity');                % Calculate mean pixel intensity in each ROI in the first frame
        end
    end
    sr.close();
elseif strcmp(VideoFormat,'.mp4')||strcmp(VideoFormat,'.avi')
    v = VideoReader(MFPVideo);
    t=0:1.0/v.FrameRate:(v.NumFrames-1)/v.FrameRate; 
    for iFrame=1:v.NumFrames
        thisFrame = read(v,iFrame);
        thisFrame=thisFrame(:,:,1);
        for iMask=1:length(regions)
            RoiProps(iMask,iFrame) = regionprops(logicmask.(regions{iMask}),thisFrame,'MeanIntensity');                % Calculate mean pixel intensity in each ROI in the first frame
        end
    end
else
    error('The MFP video path may not be valid or supported. Please check your input. (Supported formats are mp4, avi and seq)')    
end
%behavior video
if ~isempty(p.Results.behVideo)
    VideoFormat_beh=p.Results.behVideo(end-3:end);
    if strcmp(VideoFormat_beh,'.seq')
        sr2 = seqIo(p.Results.behVideo, 'reader');                                            % create interface for reading seq file
        t_beh = sr2.getts(); t_beh = t_beh-t_beh(1);                                                % get timestamps for all frames
        sr2.close();
    end
else
    t_beh=[];
end
LMag=zeros(length(regions));
for iMI=1:length(regions)
    for jMI=1:iFrame
        LMag(iMI,jMI) = RoiProps(iMI,jMI).MeanIntensity;
    end
end
% Reorder data to the following sequence  
timestamp_MFP=t;
timestamp_beh=t_beh;
Fstart=p.Results.Fstart;
Fstop=p.Results.Fstop;
behaviors=p.Results.behaviors;
save(matFile,'timestamp_MFP','timestamp_beh', 'LMag', 'regions','logicmask','behaviors','Fstart','Fstop');
MFPmat=matFile;
end
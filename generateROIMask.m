%% Things to be edited
seqFile='C:/MatNWB/Cam.seq';% edit the path
regions={'BNSTp','AHN'};% edit the regions
%%
% Get the images from the Cam video seq file
sr = seqIo(seqFile, 'reader');                                           % create interface for reading seq file
info = sr.getinfo();
nFrames = info.numFrames; FL = info.fps;                                    % get total frame number & set frame rate as sampling frequency
for i=1:length(regions)
    disp(['Currently labeling: ' regions{i}])
    sr.seek(0);                                                                 % Set to the first frame and display image
    [thisFrame,~] = sr.getframe(); % imshow(thisFrame);
    % Define ROI for current brain region
    RoiWindow = CROIEditor(thisFrame); imcontrast;
    % Save your mask after labeling is done 
    %[currMask, labels, nRois] = RoiWindow.getROIData;
    %logicmask.(regions{i})=currMask;
    waitfor(RoiWindow)
end
%% Save the masks. Edit the filename to whatever name you would like
filename='MyMask.mat';%(e.g. MyMask.mat)
for i=1:length(regions)
    currMask=[regions{i} '.mask'];
    load(currMask,'-mat')
    maskSet.(regions{i})=logicmask;
    delete(currMask)
end
logicmask=maskSet;
save(filename,'logicmask')
function plv_cell = get_PLV(phase_angle)
% function plv = get_PLV(phase_angle)

% GET_PLV compute pairwise channel PLV from phase angle array
% input data (phase_angle): nChannels  x  nTimepoints  x  nTrials
% output data (PLV): nChannels  x  nChannels  x  nTimepoints  x  nTrials

phase_angle_1250 = phase_angle(:,1:1250,:);
nChannels = size(phase_angle_1250, 1);
nTimewindows = 10; % 100ms time window *25
nTimepoints = 125; % 50 per window
nTrials = size(phase_angle_1250, 3);

%% identify timewindows
timewindowArr = false(1250, nTimewindows);
for tp = 1:nTimewindows
    timewindowArr((tp-1)*nTimepoints+1:(tp-1)*nTimepoints+nTimepoints, tp) = true;
end

%% compute PLV
plv = zeros(nChannels, nChannels, nTimewindows, nTrials);
for channelCount = 1:nChannels-1
    channelData = squeeze(phase_angle_1250(channelCount,:,:));
    for compareChannelCount = channelCount+1:nChannels
        compareChannelData = squeeze(phase_angle_1250(compareChannelCount,:,:));
        for windowCount = 1:nTimewindows
            e = exp(1i*(channelData(timewindowArr(:,windowCount),:) - compareChannelData(timewindowArr(:,windowCount),:)));
            plv(channelCount,compareChannelCount,windowCount,:) = abs(sum(e,1))/sum(timewindowArr(:,windowCount));
          % plv(channelCount,compareChannelCount,:,trialCount) = ...
          % ... abs(exp(1i*(channelData(:,trialCount) - compareChannelData(:,trialCount))));
          % dbstop if naninf;
        end
    end
end
plv = squeeze(plv);
%% form into cell array for checking
plv_cell = cell(nTrials, nTimewindows);
for a = 1:nTimewindows
    for b = 1:nTrials
        plv_cell{b,a} = squeeze(plv(:,:,a,b));
    end
end

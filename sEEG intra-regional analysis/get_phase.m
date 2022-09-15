function phase_angle = get_phase(filt_data)
% GET_PHASE compute phase angle from filtered sEEG signal
% Applies  Hilbert transform to the filtered signal, extracts phase angle part.
% Assumes that input data is a single epoch_data struct that contains a
% .filt_trial 1-x-nTrials cell array where each cell is nChannels-x-time

nTrials = length(filt_data.filt_trial);
nChannels = size(filt_data.filt_trial{1}, 1);
phase_angle = nan([size(filt_data.filt_trial{1}), nTrials]); % initialize analytic data cell array
for t = 1:nTrials
    % initialize a analytic data matrix for this trial
    temp = nan(size(filt_data.filt_trial{t}));
    % loop over channels - vectorized
    temp = angle(hilbert(filt_data.filt_trial{t}')'); % Hilbert transform + angle extraction
    % put result into cell array
    phase_angle(:,:,t) = temp;
end




%% Calculate analytic signal

for sub = [1,5,7,8,10:13,15,16]
%% get phase
    fprintf(['getting phase for sub: ' num2str(sub) ' <<\n']);
    merged_data{1,sub}.phase_angle = get_phase(merged_data{1,sub});


%% get PLV
    fprintf(['calculating PLV for sub: ' num2str(sub) ' <<\n']);
    merged_data{1,sub}.PLV_cell = get_PLV(merged_data{1,sub}.phase_angle);


%% generate PLV table
    fprintf(['Saving Subject: ' num2str(sub) ' <<\n']);
    if sub < 10
        writecell(merged_data{1,sub}.PLV_filtable, ['PLV_data_S0' num2str(sub) '_4-7Hz.csv']);
%         writecell(merged_data{1,sub}.PLV_filtable, ['PLV_data_S' num2str(sub) '_8-12Hz.csv']);
%         writecell(merged_data{1,sub}.PLV_filtable, ['PLV_data_S' num2str(sub) '_70-150Hz.csv']);
    else
        writecell(merged_data{1,sub}.PLV_filtable, ['PLV_data_S' num2str(sub) '_4-7Hz.csv']);
%         writecell(merged_data{1,sub}.PLV_filtable, ['PLV_data_S' num2str(sub) '_8-12Hz.csv']);
%         writecell(merged_data{1,sub}.PLV_filtable, ['PLV_data_S' num2str(sub) '_70-150Hz.csv']);
    end

end


function datable = get_filtable(data,sub)

% The get_filtable() function takes the merged data and its subject number as
% input, keeps the cortical channels within left ROIs,  high-relatedness
% trials, accurate response trials, trials with RT < 10s
% and generates a long-format PLV table together with channel pair and trial info.

% generate coloum names
datable = {'Subject','TrialNumber','RT','Condition','Item_1','Item_2',...
    'Channel_1','AFNI_1','AAL_1','Brainnetome_1','HarvardOxford_1','DesikanKilliany_1','Destrieux_1',...
    'Channel_2','AFNI_2','AAL_2','Brainnetome_2','HarvardOxford_2','DesikanKilliany_2','Destrieux_2',...
    'Artifact','TimeBin','PLV'};  

% identidy ROI labels
AFNI = {'Inferior Frontal Gyrus'};
AAL = {'Temporal_Pole_Mid_L','Temporal_Pole_Mid_R','Temporal_Pole_Sup_L','Temporal_Pole_Sup_R',...
    'SupraMarginal_L','SupraMarginal_R','Angular_L','Angular_R','Frontal_Inf_Tri_L','Frontal_Inf_Tri_R',...
    'Frontal_Inf_Orb_L','Frontal_Inf_Orb_R','Frontal_Inf_Oper_L','Frontal_Inf_Oper_R'};
Brainnetome = {'IFG'};
HarvardOxford = {'tissue 8','tissue 12','tissue 13',};
DesikanKilliany = {'ctx-lh-supramarginal','supramarginal',};
Destrieux = {'ctx_lh_Pole_temporal','ctx_rh_Pole_temporal'};

rowIndex = 2; 
nChannels = height(data.label);
nTrials = height(data.trialinfo);

for trl = [9:nTrials]  % Trial loop (the 9th row is the 1st trial)
    if strcmp(data.trialinfo{trl,8}{1,1},'Hi') == 1 && ... % if the stimuli are strongly related and
            strcmp(data.trialinfo{trl,6}{1,1},'1') == 1 && ... % the response is accurate and
                str2double(data.trialinfo{trl,7}{1,1}) < 10000 %  RT < 10s
        fprintf(['>> Trial ' num2str(trl) ' <<\n']);
        for ch1 = 1:nChannels-1  % Channel 1 loop
            if startsWith(data.electable{ch1,1}{1,1},'R') == 1 || ...
                    strcmp(data.electable{ch1,3}{1,1},'cortical') == 0 
                continue;
            end
            if ismember(data.electable{ch1,6}{1,1},AAL) == 1 || ...
                    ismember(data.electable{ch1,10}{1,1},HarvardOxford) == 1 || ...
                    ismember(data.electable{ch1,11}{1,1},DesikanKilliany) == 1 || ...
                    ismember(data.electable{ch1,12}{1,1},Destrieux) == 1 || ...
                    ismember(data.electable{ch1,5}{1,1},AFNI) == 1 ||...
                    ismember(data.electable{ch1,9}{1,1}(1:3),Brainnetome) == 1
                fprintf(['>> Channel 1 processed: ' num2str(ch1) ' <<\n']);
                for ch2 = ch1+1:nChannels  % Channel 2 loop
                    if startsWith(data.electable{ch2,1}{1,1},'R') == 1 || ...
                            strcmp(data.electable{ch2,3}{1,1},'cortical') == 0 
                       continue;
                    end
                    if ismember(data.electable{ch2,6}{1,1},AAL) == 1 || ...
                            ismember(data.electable{ch2,10}{1,1},HarvardOxford) == 1 || ...
                            ismember(data.electable{ch2,11}{1,1},DesikanKilliany) == 1 || ...
                            ismember(data.electable{ch2,12}{1,1},Destrieux) == 1 || ...
                            ismember(data.electable{ch2,5}{1,1},AFNI) == 1 ||...
                            ismember(data.electable{ch2,9}{1,1}(1:3),Brainnetome) == 1 
                        % fprintf([num2str(ch2) ' ']);

                        for win = 1:10  % Timewindow loop
                            datable{rowIndex,1} = sub;
                            datable{rowIndex,2} = data.trialinfo{trl,3}{1,1};
                            datable{rowIndex,3} = data.trialinfo{trl,7}{1,1};
                            datable{rowIndex,4} = data.trialinfo{trl,9}{1,1};
                            datable{rowIndex,5} = data.trialinfo{trl,10}{1,1};
                            datable{rowIndex,6} = data.trialinfo{trl,11}{1,1};
                            datable{rowIndex,7} = data.electable{ch1,1}{1,1};
                            datable{rowIndex,8} = data.electable{ch1,5}{1,1};
                            datable{rowIndex,9} = data.electable{ch1,6}{1,1};
                            datable{rowIndex,10} = data.electable{ch1,9}{1,1};
                            datable{rowIndex,11} = data.electable{ch1,10}{1,1};
                            datable{rowIndex,12} = data.electable{ch1,11}{1,1};
                            datable{rowIndex,13} = data.electable{ch1,12}{1,1};
                            datable{rowIndex,14} = data.electable{ch2,1}{1,1};
                            datable{rowIndex,15} = data.electable{ch2,5}{1,1};
                            datable{rowIndex,16} = data.electable{ch2,6}{1,1};
                            datable{rowIndex,17} = data.electable{ch2,9}{1,1};
                            datable{rowIndex,18} = data.electable{ch2,10}{1,1};
                            datable{rowIndex,19} = data.electable{ch2,11}{1,1};
                            datable{rowIndex,20} = data.electable{ch2,12}{1,1};
                            if ismember(trl, data.artifacttrials{1,ch1}) == 1 || ismember(trl, data.artifacttrials{1,ch2}) == 1
                                datable{rowIndex,21} = 1;
                            else
                                datable{rowIndex,21} = 0;
                            end
                            datable{rowIndex,22} = win;
                            datable{rowIndex,23} = data.PLV_cell{trl,win}(ch1,ch2);
                            rowIndex = rowIndex + 1;
                        end
                    end
                end
            end
        end
    end
end


    
%% --------------------------------------------------------------
%  extract_gamma_metrics.m
%  --------------------------------------------------------------
%  This script extracts peak high-gamma frequency (70–90 Hz) and 
%  corresponding power from time–frequency (Morlet wavelet) data 
%  exported from Brainstorm. 
%
%  Analysis focuses on source-level scouts “Precentral L” and 
%  “Precentral R” (Desikan–Killiany atlas).
%
%  Requirements:
%     • MATLAB R2023+ 
%     • Brainstorm exports containing variables: TF, Freqs
%     • Time vector is assumed to be -2 to 2 s (2001 samples)
%
%  Author: Shrisha Sathishkumar
%
% --------------------------------------------------------------

clear; clc;

%% --------------------------------------------------------------
%  Define subject file lists
%  (Placeholders: replace with your actual .mat file paths)
% --------------------------------------------------------------

num_subjects = 20;   % number of subjects per group

fullterm_subjects = { ...
    'PATH/TO/FT_subject01.mat', ...
    'PATH/TO/FT_subject02.mat', ...
     .......
};

preterm_subjects = { ...
    'PATH/TO/PT_subject01.mat', ...
    'PATH/TO/PT_subject02.mat', ...
    ...........
};

groups = {'Fullterm', 'Preterm'};
subject_files = {fullterm_subjects, preterm_subjects};

%% --------------------------------------------------------------
%  Analysis parameters
% --------------------------------------------------------------

high_gamma_range = [70, 90];        % Hz
peak_time_window = [0, 0.10];       % seconds (0–100 ms after movement onset)

num_time_points = 2001;             % Brainstorm default export
time = linspace(-2, 2, num_time_points);

results = {};

%% --------------------------------------------------------------
%  Loop over groups and subjects
% --------------------------------------------------------------

for g = 1:2
    for s = 1:num_subjects
        
        file_path = subject_files{g}{s};

        try
            % Load Brainstorm TFR data
            load(file_path);  % loads: TF, Freqs

            % Time & frequency indices
            t_idx = find(time >= peak_time_window(1) & time <= peak_time_window(2));
            f_idx = find(Freqs >= high_gamma_range(1) & Freqs <= high_gamma_range(2));

            % Source-scout order: 1 = contralateral, 2 = ipsilateral
            % Special handling for left-handed subject (example)
            if contains(file_path, 'Left_hand')
                contralateral_tfr = squeeze(TF(2, :, :));
                ipsilateral_tfr   = squeeze(TF(1, :, :));
            else
                contralateral_tfr = squeeze(TF(1, :, :));
                ipsilateral_tfr   = squeeze(TF(2, :, :));
            end

            % Extract window of interest
            contra_window = contralateral_tfr(t_idx, f_idx)';
            ipsi_window   = ipsilateral_tfr(t_idx, f_idx)';

            % Peak gamma (min = ERD)
            [pow_contra, idx_contra] = min(contra_window(:));
            [freq_idx_contra, ~] = ind2sub(size(contra_window), idx_contra);

            [pow_ipsi, idx_ipsi] = min(ipsi_window(:));
            [freq_idx_ipsi, ~] = ind2sub(size(ipsi_window), idx_ipsi);

            peak_freq_contra = Freqs(f_idx(freq_idx_contra));
            peak_freq_ipsi   = Freqs(f_idx(freq_idx_ipsi));

            % Store results
            results = [results; {
                groups{g}, s, peak_freq_contra, pow_contra, peak_freq_ipsi, pow_ipsi
            }];

            fprintf('Group %s | Subject %d\n', groups{g}, s);
            fprintf('   Contra: %0.1f Hz | Power %0.3f\n', peak_freq_contra, pow_contra);
            fprintf('   Ipsi  : %0.1f Hz | Power %0.3f\n', peak_freq_ipsi, pow_ipsi);

        catch ME
            warning(['Error processing subject ', num2str(s), ' (', groups{g}, '): ', ME.message]);
        end
    end
end

%% --------------------------------------------------------------
%  Save output table
% --------------------------------------------------------------

results_table = cell2table(results, ...
    'VariableNames', {'Group', 'Subject', 'PeakFreq_Contra', 'Power_Contra', 'PeakFreq_Ipsi', 'Power_Ipsi'});

writetable(results_table, 'gamma_results.xlsx');

fprintf('\nSaved: gamma_results.xlsx\n');

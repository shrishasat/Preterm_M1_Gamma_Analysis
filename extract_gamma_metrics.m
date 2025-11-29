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

% Load the TFR data file
clc
load("....\timefreq_morlet_251129_1520_ersd_time.mat");

high_gamma_range = [70, 90];  % High gamma frequency range
peak_time_window = [0, 0.1]; % Time window for peak detection

% Extract time vector and frequency vector from the dataset
num_time_points = 2001; % Given time resolution from -2 to 2 sec
num_freq_points = 100;   % Given frequency resolution from 1 to 99 Hz

time = linspace(-2, 2, num_time_points); % Generate correct time vector

% Find indices for the required time and frequency range
time_indices = find(time >= peak_time_window(1) & time <= peak_time_window(2));
freq_indices = find(Freqs >= high_gamma_range(1) & Freqs <= high_gamma_range(2));

% Extract the contralateral TFR data (Precentral L assumed as contralateral)
contralateral_tfr = squeeze(TF(1, :, :)); % Remove singleton dimension
ipsilateral_tfr = squeeze(TF(2, :, :));
% Extract relevant time-frequency data
contra_selected_tfr = contralateral_tfr(time_indices, freq_indices)'; % Transpose for correct indexing
ipsil_selected_tfr = ipsilateral_tfr(time_indices, freq_indices)';
% Find peak gamma frequency and its power
[contra_max_power, contra_max_idx] = max(contra_selected_tfr(:));
[contra_peak_freq_idx, contra_peak_time_idx] = ind2sub(size(contra_selected_tfr), contra_max_idx);
contra_peak_gamma_frequency = Freqs(freq_indices(contra_peak_freq_idx));

[ipsi_max_power, ipsi_max_idx] = max(ipsil_selected_tfr(:));
[ipsi_peak_freq_idx, ipsi_peak_time_idx] = ind2sub(size(ipsil_selected_tfr), ipsi_max_idx);
ipsi_peak_gamma_frequency = Freqs(freq_indices(ipsi_peak_freq_idx));



% Display results
disp(['contra Peak Gamma Frequency (0-0.1s): ', num2str(contra_peak_gamma_frequency), ' Hz']);
disp(['contra Peak Gamma Power: ', num2str(contra_max_power)]);

disp(['ipsi Peak Gamma Frequency (0-0.1s): ', num2str(ipsi_peak_gamma_frequency), ' Hz']);
disp(['ipsi Peak Gamma Power: ', num2str(ipsi_max_power)]);

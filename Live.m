%% Live Detection
%Sam Coleman
%Modified from code provided by Sam Michalka

% This script facilitates connecting to and collecting data from an
% Arduino and EMG sensors. Check out the Setup and Data Collection document
% for additional context.
%% Load Trained Algorithm
clear;  % Clear all vari ables
clc; % Clear your command window output
load("data/trainedAlgorithm.mat");
disp("Loaded algorithm");
%% Configure serial port 

port = '/dev/ttyUSB0';     % Change this to match your installation!

baudrate = 500000; % Serial bits per second, set in program
sObj = serialport(port,baudrate) 
configureTerminator(sObj,"CR");
pause(4)
sObj %This spits out the object again. 
% The second time you see sObj, it should have NumBytesAvailable > 0
% If you don't see the NumBytesAvailable growing, then wait a minute and
% type sObj into the command window. If it is still zero, something is
% wrong.
%% Get data and write it to an array
num_sensors = 3;   % Change this to match your number of sensors!
numevents = 1; % Must divide evenly by number of eventoptions
epochlength = 3; % Time in seconds to collect data per trial
waittime = 0.5; % Time in seconds between rock, paper, scissors

nbchan = num_sensors; % Number of channels to collect (starts with A0, up to A3)
srate = 500; % 500 Hz collection rate
n=ceil(epochlength .* srate); % Number of time points per event
while 1
data = zeros(nbchan, n, 1);
for ev = 1:numevents
    disp("Press any key initiate game");
    pause;
    disp("Move your hand immediately on the word shoot");
    disp("...");
    pause(waittime);    
    disp("ROCK");
    pause(waittime);
    disp("PAPER");
    pause(waittime);
    disp("SCISSORS");
    pause(waittime-.5);
    flush(sObj);
    pause(waittime); % Finish waiting
    disp("SHOOT!!");
    j = 1;
    while(j <=n)
        if sObj.NumBytesAvailable > 0
            indata = str2double(split(readline(sObj)));
            if length(indata) ==7 
                if indata(2) ~= 0
                    data(:,j,ev) = indata(3:2+nbchan);
                    j = j+1;
                end
            end
        end
    end
end 


%% pre-process data
for channel =1:size(data,1) 
    data(channel,:, :) = data(channel,:, :) - mean(data(channel,:, :),2); 
end

%% Extract Features
emg_aac = extract_features.calc_aac(data);
emg_damv_10 = extract_features.calc_DAMV(data, 10);
emg_dasdv_10 = extract_features.calc_dasdv(data, 10)';
emg_max = extract_features.max_value(data);
features = [emg_aac; emg_damv_10; emg_dasdv_10; emg_max]';

%% Predict
prediction_label = predict(trainedAlg, features);
disp("You threw:");
disp(prediction_label);
end
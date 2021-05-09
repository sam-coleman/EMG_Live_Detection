% This scrip[t facilitates connecting to and collecting data from an
% Arduino and EMG sensors. Check out the Setup and Data Collection document
% for additional context.

% You will need to set up your command window so that you can easily view
% outputs from this code.

serialportlist("available") %This outputs the available serial ports

%% Configure serial port 
clear;  % Clear all variables
clc; % Clear your command window output
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
% You change these things:  
%EMG.setname = 'red'; % Name of this data collection run
num_sensors = 3;   % Change this to match your number of sensors!
numevents = 1; % Must divide evenly by number of eventoptions
epochlength = 3; % Time in seconds to collect data per trial
%savedata = true; %True/false flag dependingon if you want to save your data
waittime = 0.5; % Time in seconds between rock, paper, scissors

%You don't need to change these things:
%eventoptions = categorical({'rock', 'paper', 'scissors'});
nbchan = num_sensors; % Number of channels to collect (starts with A0, up to A3)
srate = 500; % 500 Hz collection rate
% 
% % Generate pseudorandom ordering
% EMG.epochlabelscat = repmat(eventoptions,1,round(numevents./length(eventoptions)));
% EMG.epochlabelscat = EMG.epochlabelscat(randperm(length(EMG.epochlabelscat))); %Shuffle event order (you can comment this out)

% Create data structure for times and data.
n=ceil(epochlength .* srate); % Number of time points per event
%EMG.data = zeros(EMG.nbchan,n,numevents);
%EMG.alltimes = zeros(n,numevents);
data = zeros(nbchan, n, 1);
% Loop through and collect data for each event
for ev = 1:numevents
    disp("Press any key initiate game");
    pause;
    disp("Move your hand immediately on the word shoot");
%     disp(strcat("This time, form: ", upper(string(EMG.epochlabelscat(ev)))));
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
                    %EMG.alltimes(j,ev) = indata(2);
                    data(:,j,ev) = indata(3:2+nbchan);
                    j = j+1;
                end
            end
        end
    end
    %EMG.alltimes(:,ev) = EMG.alltimes(:,ev) - EMG.alltimes(1,ev); % set first time point to zero
end
% if savedata
%     % Create a data directory if it doesn't exist
%     if not(isfolder("data"))
%         mkdir("data")
%     end
%     % Save the data file with timestamp
%     save(strcat('data/EMGdata-',EMG.setname))
% end

%% pre-process data
for channel =1:size(data,1) 
    data(channel,:, :) = data(channel,:, :) - mean(data(channel,:, :),2); 
end
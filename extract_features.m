classdef extract_features
    %extract_features Extract features from EMG data
    
    properties
    end
    
    methods (Static)
        
        function res = calc_mean(data, i_start, i_end, dim)
            % calc_mean calculates mean across dim for data from i_start to i_end
            % data: EMG data
            % i_start: index to start mean
            % i_end: index to end mean
            % returns mean across dim
            res = squeeze(mean(data(:,i_start:i_end,:), dim));
        end
        
        function max_val = max_value(data)
            %max_value calculates the max value per channel
            %data: EMG data
            %returns max value per channel
            max_val = squeeze(max(data, [], 2));
        end
        
        function res = calc_abs_mean(data, i_start, i_end, dim)
            %calc_abs_mean calcualtes mean of absolute value across dim for data
            %from i_start to i_end
            % data: EMG data
            % i_start: index to start mean
            % i_end: index to end mean
            % returns mean across dim
            res = extract_features.calc_mean(abs(data), i_start, i_end, dim);
        end
        
        function res = calc_rms(data, i_start, i_end)
            %calc_rms calculates rms across points
            %data: EMG data
            %i_start: index to start at
            %i_end: index to end at
            res = squeeze(rms(data(:,i_start:i_end,:), 2));
        end
        
        function res = calc_variance(data)
            %calc_variance calculates variance across points
            %data: EMG data
            res = squeeze(var(data,0,2));
        end
        
        function aac = calc_aac(data)
            %calc_aac calculates average amplitude change
            %data: EMG data
            N = length(data); %number of values
            Y = zeros(3,size(data, 3)); %hold differences
            for trial = 1: size(data, 3) %iterate over every trial
                for i = 1: N -1 %iterate over all values
                    %calculate for all 3 channels
                    Y(1, trial) = Y(1, trial) + abs(data(1, i+1, trial) - data(1,i, trial));
                    Y(2, trial) = Y(2, trial) + abs(data(2, i+1, trial) - data(2,i, trial));
                    Y(3, trial) = Y(3, trial) + abs(data(3, i+1, trial) - data(3,i, trial));
                end
            end
            aac = Y ./ N; %calculate AAC
        end
        
        function wl = calc_waveform_length(data)
            %calc_waveform_length calculates waveform length for each trial per
            %channel
            %data: EMG data
            wl = zeros(3,size(data, 3));
            for trial = 1:size(data, 3)
                for i = 2:size(data, 2)
                    wl(:,trial) = wl(:,trial) + abs(data(:,i,trial) - data(:,i-1,trial));
                end
            end
        end
        
        function w_amp = calc_willison_amp(data, thresh)
            %calc_willison_amp calculates willison amplitude for each trial per
            %channel with a defined threshold
            %data: EMG data
            %thresh: threshold that must be exceeded
            w_amp = squeeze(sum(data > thresh, 2));
        end
        
        function zc = calc_zc(data, thresh)
            %calc_zc calculates zero crossing for each trial per channel (with a
            %defined threshold)
            %data: EMG data
            %thresh: threshold
            zc = zeros(3,size(data, 3));
            for trial = 1:size(data,3)
                for i = 1: size(data,2)-1
                    %channel 1
                    if ((data(1,i,trial) > 0 && data(1,i+1,trial) < 0) || (data(1,i,trial) < 0 && data(1,i+1,trial) > 0)) ...
                            && (abs(data(1,i,trial)) - data(1,i+1,trial) >= thresh)
                        zc(1,trial) = zc(1,trial) +  1;
                    end
                    
                    %channel 2
                    if ((data(2,i,trial) > 0 && data(2,i+1,trial) < 0) || (data(2,i,trial) < 0 && data(2,i+1,trial) > 0)) ...
                            && (abs(data(2,i,trial)) - data(2,i+1,trial) >= thresh)
                        zc(2,trial) = zc(2,trial) + 1;
                    end
                    
                    %channel 3
                    if ((data(3,i,trial) > 0 && data(3,i+1,trial) < 0) || (data(3,i,trial) < 0 && data(3,i+1,trial) > 0)) ...
                            && (abs(data(3,i,trial)) - data(3,i+1,trial) >= thresh)
                        zc(3,trial) = zc(3,trial)+ 1;
                    end
                end
            end
        end
        
        function iemg = integratedEMG(data)
            %integratedEMG iEMG for data for each trial across points for each
            %channel
            iemg = squeeze(sum(abs(data), 2));
        end
        
        function ssi = simplesquared(data)
            %simplesquared sums squared data for each trial across points for each
            %channel
            ssi = squeeze(sum(data.^2, 2));
        end
        
        function numpks = numpeaks(data, threshold)
            %numpks = sum(data > rms(data), threshold);
            %pks = findpeaks(data)
            %numpks = size(pks, 2)
        end
        
        function skew = calc_skew(data)
            %clac_skew calculates skewness of each trial for all channels
            skew = squeeze(skewness(data,1,2));
        end
        
        function DASDV = calc_dasdv(data, N)
            %calc_dasdv calcualtes difference absolute standard deviation value for
            %each trial across all channels
            % DASDV: [num_trials X channels] where rows are trial and column is
            % channel
            DASDV = zeros(size(data,3),3);
            DASDV(:, 1) = squeeze(sqrt((sum(((diff(data(1,:,:))).^2),2))/N-1));
            DASDV(:, 2) = squeeze(sqrt((sum(((diff(data(2,:,:))).^2),2))/N-1));
            DASDV(:, 3) = squeeze(sqrt((sum(((diff(data(3,:,:))).^2),2))/N-1));
        end
        
        function kurt = calc_kurt(data)
            %calc_kurt calculates kurtosis for each trial across all channels
            kurt = squeeze(kurtosis(data,1,2));
        end
        
        function DAMV = calc_DAMV(data, N)
            %calc_DMV calculates Difference Absolute Standard Deviation Value for
            %each trial across all channels
            DAMV = (squeeze(sum((abs(diff(data(:,:,:),2,2)).^2),2)))/(N-1);
        end
        
        function LD = logdetector(data, N)
            LD = squeeze(exp(sum(log(data),2)/N));
        end
    end
end
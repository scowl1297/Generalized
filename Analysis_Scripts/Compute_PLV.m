

function [plvbin, zscore_plv] = Compute_PLV(cfg)

%addpath(genpath('Z:\Projects\Thalamus Epilepsy\SfN 2021\scripts'))
addpath('Z:\MATLAB\timefreq');

    fs = cfg.fs;
    fq = cfg.fq;
    montage = cfg.montage;
    phase = cfg.phase;
    seizures = cfg.seizures;
    seizure_number = cfg.sizure_number;
    binwidth = cfg.binwidth;
    time = cfg.time;
    ch1 = cfg.channel_idx;

    %%
    num_samples = size(phase{1},1);
    nch = size(phase{1},3);
    num_seizures = length(phase);
    
    nfq = length(fq);
    
    nbins = floor(num_samples/binwidth);
    tbin = zeros([nbins,1]);

    
    for s=1:num_seizures
        
        fprintf('Computing PLV: seizure %d...\n', s)
        
        t = seconds(time(:,s) - seizures.onset(seizures.seizure_id == seizure_number(s)));
        
        plvbin{s} = zeros([nbins,nfq,nch],'single');
        
        for i=1:nbins
            idx = (1+(i-1)*binwidth):(i*binwidth);
            tbin(i) = mean(t(idx));
            for ch2 = 1:nch
                plvbin{s}(i,:,ch2) =  ...
                    abs(sum(exp(sqrt(-1)*(phase{s}(idx,:,ch1)-phase{s}(idx,:,ch2))),1)/binwidth);
            end
        end
        
        
        baseline_bins = 10*fs/binwidth + 1:(15*fs/binwidth);
        
        baseline_plv = repmat(mean(plvbin{s}(baseline_bins,:,:),1), [size(plvbin{s},1),1,1]);
        std_plv = repmat(std(plvbin{s}(baseline_bins,:,:),1,1), [size(plvbin{s},1),1,1]);
        zscore_plv{s}= (plvbin{s} - baseline_plv)./std_plv;
        
    end
    
   
end
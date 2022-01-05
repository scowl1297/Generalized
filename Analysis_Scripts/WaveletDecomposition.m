

function [power, phase] = WaveletDecomposition(cfg)

%addpath(genpath('Z:\Projects\Thalamus Epilepsy\SfN 2021\scripts'))
addpath('Z:\MATLAB\timefreq');

    fs = cfg.fs;
    fq = cfg.fq;
    width = cfg.width;
    montage = cfg.montage;
    data = cfg.data;

    %%
    num_samples = size(data,1);
    nch = size(data,2);
    num_seizures = size(data,3);
    nfq = length(fq);

    %powerbin = zeros(nbins,nfq,nch,'single');
    
    for s=1:num_seizures
        
        power{s} = zeros([num_samples,nfq,nch],'single');
        phase{s} = zeros([num_samples,nfq,nch],'single');
        
        for ch=1:nch
            fprintf('Seizure %d, Channel %s...\n', s, montage.label{ch})
            Y = fast_wavtransform(fq, data(:,ch,s),fs,width);
            power{s}(:,:,ch) = abs(Y).^2;
            phase{s}(:,:,ch) = angle(Y);
        end
    end
  
    %%
end
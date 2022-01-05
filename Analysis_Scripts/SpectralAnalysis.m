

fs = 2048;
fq = logspace(log10(4), log10(250), 25);
width = 7;


cfg = [];
cfg.fs = fs;
cfg.fq = fq;
cfg.width = width;
cfg.data = y_seizure_onset;
cfg.montage = Montage;


[power, phase] = WaveletDecomposition(cfg);


plot_seizure_spectra;



%%
binwidth = 1024;
channel_idx = find(strcmp('C''1',Montage.channel));

cfg = [];
cfg.fs = fs;
cfg.fq = fq;
cfg.binwidth = binwidth;
cfg.time = t_seizure_onset;
cfg.phase = phase;
cfg.seizures = seizures;
cfg.sizure_number = seizure_number;
cfg.montage = Montage;
%%Channel_idx = electrode contact used for PLV across electrodes
cfg.channel_idx = channel_idx;

[plvbin, zscore_plv] = Compute_PLV(cfg);


%% display each seizure spectrum


addpath(genpath('Z:\MATLAB\csl'));
addpath(genpath('Z:\MATLAB\export_fig'));

figdir = 'Z:\Projects\Thalamus Epilepsy\figures\seizures_plv';


MP = get(0, 'MonitorPositions');
fig_height = 1200;
figs_per_column = 1;
clear fig


for s=1:length(power)
    screen_pos = mod(s,figs_per_column);
    if screen_pos==0
       screen_pos = figs_per_column; 
    end
    
    cfg = [];
    cfg.tf_matrix = log(power{s});
    cfg.fq = fq;
    cfg.time = seconds(t_seizure_onset(:,s) - seizures.onset(seizures.seizure_id == seizure_number(s)));
    cfg.raw = [];
    cfg.overlay_raw = false;
    cfg.label = Montage.label;
    %cfg.Clim = [];
    cfg.colorbar_label = 'log( Power )';
    cfg.figure_position = [100+MP(1,1) MP(1,4)-screen_pos*(1.25*fig_height) 0.75*MP(1,3) fig_height];
    cfg.filename = [figdir, filesep, Subject_ID, '_seizure_', num2str(seizure_number(s)) , '_logpower'];
    fig(s) = csl_plot_timefreq(cfg);
    
end


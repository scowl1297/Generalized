function y = display_offset(cfg)

%% display each seizure time series

montage = cfg.Montage;
seizure_offset = cfg.seizure_offset;
seizure_onset = cfg.seizure_onset;
t_seizure_offset = cfg.tso;
y_seizure_offset = cfg.yso;
SUBJECT = cfg.Subject_ID;
edf_filenames = cfg.filename;


ylimits_table.group = {'B'''; 'C'''; 'E'''; 'I'''; 'U'''};
ylimits_table.ylimits = {[-1200 1200]; [-1200 1200]; [-1200 1200]; [-1200 1200]; [-600 600]};
ylimits = cellfun(@(x) ylimits_table.ylimits(strcmp(x, ylimits_table.group)), montage.group);
nch = length(montage.channel);
margin_bottom = 0.1;
margin_top = .05;
margin_left = 0.1;
margin_right = 0.2;
%colorbar_margin = 0.05;

MP = get(0, 'MonitorPositions');
fig_height = 1200;
figs_per_column = 1;
clear fig ax offset_marker offset_marker
for s=1:height(seizure_offset{f})
    screen_pos = mod(s,figs_per_column);
    if screen_pos==0
       screen_pos = figs_per_column; 
    end
    fig(s) = figure('Position', [100+MP(1,1) MP(1,4)-screen_pos*(1.25*fig_height) 0.75*MP(1,3) fig_height]); 
    

    for ch=1:nch
        ax(s,ch) = subplot('Position', ...
            [margin_left, ...
            margin_bottom+(ch-1)/nch-(ch-1)*(margin_bottom+margin_top)/nch, ...
            1-margin_left-margin_right, ...
            1/nch-(margin_bottom+margin_top)/nch]);
        
        
        
        plot(t_seizure_offset{f}(:,s), y_seizure_offset{f}(:,ch,s));

        
        set(gca, 'YTick', [])
        if ch == 1
            xlabel('time (s)')
        else
            %set(gca, 'XTick', [])
            set(gca,'TickLength',[0.0, 0.0])
            ax(s,ch).XTickLabel={};
        end
        
        xlimits = [t_seizure_offset{f}(1,s), t_seizure_offset{f}(end,s)];
        xlim(xlimits);
        ylim(ylimits{ch})
        
        ax(s,ch).XAxis.MinorTick = 'on';
        ax(s,ch).XAxis.MinorTickValues = xlimits(1):seconds(1):xlimits(2);
        grid(ax(s,ch), 'on')        
        grid(ax(s,ch), 'minor')
        
        text(xlimits(1)-diff(xlimits)/20, ylimits{ch}(2)-diff(ylimits{ch})/5, ...
            montage.label{ch})
        
        hold on; 
        onset_marker(s,ch) = plot([seizure_onset{f}.Onset(s) seizure_onset{f}.Onset(s)], ylim, 'g');
        
        hold on;
        offset_marker(s,ch) = plot([seizure_offset{f}.Onset(s) seizure_offset{f}.Onset(s)], ylim, 'r');
        
    end
    title([strrep(strrep(strrep(edf_filenames{f}, '_', ' '), '.edf', ''), '.EDF', ''), ' Seizure #', num2str(seizure_offset{f}.seizure_id(s))]);
   
end

figdir = 'Z:\Projects\Thalamus Epilepsy\figures\seizures_timeseries_offset';
for i=1:length(fig)
    set(fig(i),'Units','Inches');
    pos = get(fig(i),'Position');
    set(fig(i),'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
    saveas(fig(i), [figdir, filesep, SUBJECT, '_seizure_offset_', num2str(seizure_offset{f}.seizure_id(i)), '_timeseries.fig'], 'fig')
    saveas(fig(i), [figdir, filesep, SUBJECT, '_seizure_offset_', num2str(seizure_offset{f}.seizure_id(i)), '_timeseries.png'], 'png')
    saveas(fig(i), [figdir, filesep, SUBJECT, '_seizure_offset_', num2str(seizure_offset{f}.seizure_id(i)), '_timeseries.pdf'], 'pdf')
end

        current_fig = gcf;
        n_seizure_fig = find([fig(:).Number] == current_fig.Number);
        current_seizure_id = seizure_onset{f}.seizure_id(n_seizure_fig);
    
        ax = gca;
        [new_offset,temp,button] = ginput(1);
        hold on; plot([new_offset new_offset], ylim, 'r')
        new_offset = num2ruler(new_offset,ax.XAxis);
        seizure_offset{f}.Onset(n_seizure_fig) = new_offset;
        hold on; plot([seizure_onset.Onset(n_seizure_fig) seizure_onset.Onset(n_seizure_fig)], ylim, 'r')

end
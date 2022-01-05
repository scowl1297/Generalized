    current_fig = gcf;
    n_seizure_fig = find([fig(:).Number] == current_fig.Number);
    current_seizure_id = seizure_onset.seizure_id(n_seizure_fig);
    
    ax = gca;
    [new_onset,temp,button] = ginput(1);
    hold on; plot([new_onset new_onset], ylim, 'g')
    new_onset = num2ruler(new_onset,ax.XAxis);
    seizure_onset.Onset(n_seizure_fig) = new_onset;
    hold on; plot([seizure_onset.Onset(n_seizure_fig) seizure_onset.Onset(n_seizure_fig)], ylim, 'r')
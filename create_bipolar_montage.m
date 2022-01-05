function montage = create_bipolar_montage()


montage = [];
montage.name = 'bipolar';
montage.label = {};
montage.group = {};
montage.channel = {};
montage.reference = {};


%bs_channels.Channel.Name

channels = {bs_channels.Channel({bs_channels.Channel(:).Type}=="SEEG").Name}';
group = channels;
number = channels;
for ch=1:length(channels)
    idx_num = regexp(channels{ch}, '[0-9]');
    number{ch} = group{ch}(idx_num);
    group{ch}(idx_num) = [];

end

group_names = unique(group);

k=0;
for g=1:length(group_names)
   numbers = number(strcmp(group_names{g}, group));
    
   for n=1:(length(numbers)-1)
       k=k+1;
       montage.group{k} = group_names{g};
       montage.channel{k} = [group_names{g}, numbers{n}];
       montage.reference{k} = [group_names{g}, numbers{n+1}];
       montage.label{k} = [montage.channel{k}, '-', montage.reference{k}];
   end
   
end
montage.label = montage.label';
montage.group = montage.group';
montage.channel = montage.channel';
montage.reference = montage.reference';

end
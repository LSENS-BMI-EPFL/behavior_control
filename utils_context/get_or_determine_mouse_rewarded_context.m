function mouse_rewarded_context = get_or_determine_mouse_rewarded_context(root_path, mouse_name, contexts)
%GET_OR_DETERMINE_MOUSE_REWARDED_CONTEXT Summary of this function goes here
%   Detailed explanation goes here

rewarded_context_table = readtable(strcat(root_path, '\rewarded_context.csv'));
mice_names = rewarded_context_table.MouseName;

if any(strcmp(mice_names, mouse_name))
    rows = strcmp(rewarded_context_table.MouseName, mouse_name);
    mouse_rewarded_context = rewarded_context_table(rows, :).RewardedContext{1};
else
    r = randi([1, size(contexts, 2)], 1); 
    mouse_rewarded_context = contexts{r};
    T1 = table({mouse_name}, {mouse_rewarded_context}, 'VariableNames', {'MouseName','RewardedContext'});
    rewarded_context_table = [rewarded_context_table; T1];
    writetable(rewarded_context_table, strcat(root_path, '\rewarded_context.csv'))
end

end


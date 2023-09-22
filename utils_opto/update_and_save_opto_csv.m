function update_and_save_opto_csv(variables_to_save, variable_saving_names)

% UPDATE_AND_SAVE_RESULTS_CSV Summary of this function goes here

    global  trial_number folder_name

    path_results_csv = strcat(folder_name, '\results_opto.csv');

    if trial_number == 1
        results_table = table(variables_to_save{:}, 'VariableNames', variable_saving_names);
        writetable(results_table, path_results_csv);
    else
        results_table = readtable(path_results_csv);
        trial_to_add = table(variables_to_save{:}, 'VariableNames', variable_saving_names);
        results_table = [results_table; trial_to_add];
        writetable(results_table, path_results_csv);
    end


end


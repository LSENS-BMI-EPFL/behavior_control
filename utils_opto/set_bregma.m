function saved = set_bregma(root_path, mouse_name, ML, AP)
%SET_BREGMA Summary of this function goes here
%   Detailed explanation goes here
    arguments
        root_path   = 'M:\analysis\Pol_Bech\Parameters\';
        mouse_name  = 'PB000';
        ML = [];
        AP = [];
    end

    bregma_list = readtable(strcat(root_path, 'mouse_bregma.csv'));

    if any(strcmp(bregma_list.MouseName, mouse_name))
        rows = strcmp(bregma_list.MouseName, mouse_name);
        
        fig = uifigure;
        msg = ['Attention! Saving will overwrite previous values: ' newline ...
            mouse_name ': ' num2str(bregma_list(rows,:).ML) 'ML ' num2str(bregma_list(rows,:).AP)...
            'AP -> ' num2str(ML) 'ML ' num2str(AP) 'AP'];
        title = 'Confirm save';
        selection = uiconfirm(fig, msg, title,'Options',{'Overwrite', 'Cancel'});
        close(fig)
        if strcmp(selection, 'Overwrite')
            bregma_list(rows,:).ML  = ML;
            bregma_list(rows, :).AP = AP;
            writetable(bregma_list, strcat(root_path, 'mouse_bregma.csv'))
            saved = 1;
        else
            disp('Saving cancelled')
            saved = 0;
        end
    else
        fig = uifigure;
        msg = ['Saving: ' newline ...
            mouse_name ': ' num2str(ML) 'ML ' num2str(AP) 'AP'];
        title = 'Confirm save';
        selection = uiconfirm(fig, msg, title,'Options',{'Save bregma', 'Cancel'});
        close(fig)
        if strcmp(selection, 'Save bregma')
            T1 = table({mouse_name}, ML, AP, 'VariableNames', {'MouseName', 'ML', 'AP'});
            writetable([bregma_list; T1], strcat(root_path, 'mouse_bregma.csv'))
            saved = 1;
        else
            disp('Saving cancelled')
            saved = 0;
        end


    end

end


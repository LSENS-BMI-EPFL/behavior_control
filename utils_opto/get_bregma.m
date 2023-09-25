function [bregma_x, bregma_y] = get_bregma(root_path, mouse_name)
%GET_BREGMA returns x and y coordinates of bregma in voltage for a given
%mouse
%   Given a mouse name and a path towards a .csv file with the coordinates,
%   return the bregma position assigned for a given mouse to be used as
%   reference for the grid. This has to be calibrated at the beginning of
%   the experiments with the set_bregma button in Opto_GUI app.

    arguments
        root_path   = 'M:\analysis\Pol_Bech\Parameters\';
        mouse_name  = 'PB000';
    end
    
    bregma_list = readtable(strcat(root_path, 'mouse_bregma.csv'));

    if any(strcmp(bregma_list.MouseName, mouse_name))
        rows = strcmp(bregma_list.MouseName, mouse_name);
        
        bregma_x = bregma_list(rows, :).ML;
        bregma_y = bregma_list(rows, :).AP;
    
    else
        
        bregma_x = 0;
        bregma_y = 0;

    end

    disp([mouse_name ' Current bregma values: ' num2str(bregma_x) ' ML, ' num2str(bregma_y) ' AP'])
end


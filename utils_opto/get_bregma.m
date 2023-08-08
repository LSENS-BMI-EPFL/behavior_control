function [bregma_x, bregma_y] = get_bregma(root_path, mouse_name)
%GET_BREGMA Summary of this function goes here
%   Detailed explanation goes here
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


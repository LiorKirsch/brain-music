function data_folder = get_data_folder()
    mycomputer = getComputerName();
    
    switch mycomputer
        case 'ohadfel'
            data_folder = '/cortex/users/lior/data/brain_music/';
        otherwise
            data_folder = '/cortex/users/lior/data/brain_music/';
    end
end
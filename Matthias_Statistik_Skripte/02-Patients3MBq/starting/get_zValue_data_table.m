function [z_value_data_table] = get_zValue_data_table(wished_dose)
%written for 3MBq Patients summarized data - just get the right coloumn
%   Detailed explanation goes here
    switch wished_dose
        case 0.5
            z_value_data_table=1;
        case 0.75
            z_value_data_table=2;
        case 1
            z_value_data_table=3;
        case 1.25
            z_value_data_table=4;
        case 1.5
            z_value_data_table=5;
        case 1.75
            z_value_data_table=6;
        case 2
            z_value_data_table=7;
        case 2.25
            z_value_data_table=8;
        case 2.5
            z_value_data_table=9;
        case 2.75
            z_value_data_table=10;
        case 3
            z_value_data_table=11;
        otherwise
            msgbox('Wrong Dosis selected');
    end
end


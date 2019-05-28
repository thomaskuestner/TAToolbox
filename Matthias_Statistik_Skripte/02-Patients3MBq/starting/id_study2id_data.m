function [id_in_data] = id_study2id_data(id_in_study)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
 switch id_in_study
        case 01
            id_in_data=1;
        case 03
            id_in_data=2;
        case 06
            id_in_data=3;
        case 09
            id_in_data=4;
        case 10
            id_in_data=5;
        case 13
            id_in_data=6;
        case 14
            id_in_data=7;
        case 17
            id_in_data=8;
        case 18
            id_in_data=9;
        case 19
            id_in_data=10;
        case 20
            id_in_data=11;
        case 21
            id_in_data=12;
        case 22
            id_in_data=13;
        case 24
            id_in_data=14;
        case 25
            id_in_data=15;
        case 26
            id_in_data=16;
        case 27
            id_in_data=17;
        case 28
            id_in_data=18;
        case 29
            id_in_data=19;
        otherwise
            msgbox('Wrong Dosis selected');
end


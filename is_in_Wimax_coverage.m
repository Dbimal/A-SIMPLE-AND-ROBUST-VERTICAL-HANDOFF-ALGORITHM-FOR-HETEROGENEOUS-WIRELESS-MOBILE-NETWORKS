function is_Wimax=is_in_Wimax_coverage(MS_coordinate)
%decide whether the mobile station is in the Wimax network
global Wimax_BS_coordinate;
d=norm(MS_coordinate-Wimax_BS_coordinate);
if d<=300&d>=36
    is_Wimax=true;
else
    is_Wimax=false;
end
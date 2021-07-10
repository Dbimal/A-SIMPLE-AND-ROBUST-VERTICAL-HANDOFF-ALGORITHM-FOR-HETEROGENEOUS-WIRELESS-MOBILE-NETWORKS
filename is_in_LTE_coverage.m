function is_LTE=is_in_LTE_coverage(MS_coordinate)
%decide whether the mobile station is in the LTE network
global LTE_BS_coordinate;
d=norm(MS_coordinate-LTE_BS_coordinate);
if d<=1000&d>=35
    is_LTE=true;
else
    is_LTE=false;
end
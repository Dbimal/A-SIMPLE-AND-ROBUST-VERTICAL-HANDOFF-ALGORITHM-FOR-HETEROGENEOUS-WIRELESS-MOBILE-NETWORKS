function slow_fading= calculate_slow_fading(MS_coordinate,s)
%calcualte the large scale fading
global fc_LTE fc_Wimax LTE_BS_coordinate Wimax_BS_coordinate
shadow_fading=0;                  %calculate_shadow_fading(MS_coordinate,s)
switch s
    case 'LTE'
        f=fc_LTE;
        d=norm(MS_coordinate-LTE_BS_coordinate);
    otherwise
        f=fc_Wimax;
        d=norm(MS_coordinate-Wimax_BS_coordinate);
end
propagation_loss=32.44+20*log10(d/1000)+20*log10(f/10^6)+12+3+24;
slow_fading=propagation_loss+shadow_fading;
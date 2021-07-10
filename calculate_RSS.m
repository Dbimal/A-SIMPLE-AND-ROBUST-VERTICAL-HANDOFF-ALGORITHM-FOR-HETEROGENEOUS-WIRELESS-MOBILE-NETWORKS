function RSS=calculate_RSS(MS_coordinate,s)
%calculate the received signal strength
switch s
    case 'LTE'
       slow_fading=calculate_slow_fading(MS_coordinate,'LTE');
       fast_fading=0;           %calculate_fast_fading(MS_coordinate,'LTE')
       RSS=33-slow_fading-fast_fading;
    otherwise
       slow_fading=calculate_slow_fading(MS_coordinate,'Wimax');
       fast_fading=0;         %calculate_fast_fading(MS_coordinate,'Wimax')
       RSS=23-slow_fading-fast_fading; 
end      
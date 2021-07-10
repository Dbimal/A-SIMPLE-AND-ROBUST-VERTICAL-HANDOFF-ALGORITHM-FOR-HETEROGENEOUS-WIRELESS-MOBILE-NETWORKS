function performance_meet=is_network_performance_meet(service_type)
%calculate the network performance,simutaneously,calculate the weight of
%each property
value_of_property=[36.68 32.42;3.14 0.5024;2.8542 1.3376;...
    150 150;0.8 0.5];
switch service_type
    case 0
       weight_property_AHP=[0.2193 0.0426 0.5281 0.1323 0.0776];
    otherwise
       weight_property_AHP=[0.4400 0.0906 0.0576 0.2560 0.1557];    
end
number_of_positive_property=2;
nomalization_value_of_property=nomalization(value_of_property,...
    number_of_positive_property);
weight_property_entropy=calculate_weight_property_entropy(...
    nomalization_value_of_property);
alpha=0.5;
weight_property_combination=alpha*weight_property_entropy+(1-alpha)*...
    weight_property_AHP;
whole_network_performance=weight_property_combination*...
    nomalization_value_of_property;
performance_meet=find(whole_network_performance==...
    max(whole_network_performance))-1;
function nomalization_value_of_property=nomalization(value_of_property,...
    number_of_positive_property)
%nomalize the value of each property
[number_of_line,number_of_row]=size(value_of_property);
for i=1:number_of_positive_property
    sum_min_max=max(value_of_property(i,:))+min(value_of_property(i,:));
    for j=1:number_of_row
        nomalization_value_of_property(i,j)=value_of_property(i,j)/...
            sum_min_max;
    end
end
for i=number_of_positive_property:number_of_line
    sum_min_max=max(value_of_property(i,:))+min(value_of_property(i,:));
    for j=1:number_of_row
        nomalization_value_of_property(i,j)=(sum_min_max-...
            value_of_property(i,j))/sum_min_max;
    end
end
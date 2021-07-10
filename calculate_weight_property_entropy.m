function weight_property=calculate_weight_property_entropy(...
    nomalization_value_of_property)
%calculate the weight of each property according to the information's entropy
[number_of_line,number_of_row]=size(nomalization_value_of_property);
k=1/log2(number_of_row);
for i=1:number_of_line
    sum_property=sum(nomalization_value_of_property(i,:));
    evaluate_property(i)=0;
    for j=1:number_of_row
        f=nomalization_value_of_property(i,j)/sum_property;
        if f==0
           evaluate_property(i)=evaluate_property(i)+0;
        else
           evaluate_property(i)=evaluate_property(i)-k*f*log2(f);
        end
    end
end
sum_evaluate_property=sum(evaluate_property);
for i=1:number_of_line
    weight_property(i)=(1-evaluate_property(i))/...
        (number_of_line-sum_evaluate_property);
end
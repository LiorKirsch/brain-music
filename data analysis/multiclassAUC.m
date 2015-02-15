function auc = multiclassAUC(y,decision_values)

[num_samples,num_classes] = size(decision_values);
auc = nan(1,num_classes);
for i = 1:num_classes
    auc(i) = scoreAUC(y == i, decision_values(:,i) );% auc should get a logical vector
end

end

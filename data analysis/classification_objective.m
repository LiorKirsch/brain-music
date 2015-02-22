function [mean_objective, zero_one_weights] = classification_objective(samples_decisions, sigmoid_slopes,y_multiclass)
    [num_samples, num_classes] = size(samples_decisions);
    zero_one_weights = transform_decisions_into_zero_one_weights(samples_decisions, sigmoid_slopes);
    y_multiclass = full(sparse(1:num_samples, y_multiclass, ones(num_samples,1), num_samples, num_classes));
    
    objective = (zero_one_weights - y_multiclass).^2;
    objective = mean(objective,2);
    mean_objective = mean(objective);
    std_objective = std(objective);
    
    fprintf('Objective for weightening: %g (+/- %g)\n',mean_objective,std_objective);

end

function zero_one_weights = transform_decisions_into_zero_one_weights(samples_decisions, sigmoid_slopes)
% samples_decisions should be a matrix of size = [samplex X num_classes]
    [num_samples, num_classes] = size(samples_decisions);
    
    if ~exist('sigmoid_slopes','var')
        sigmoid_slopes = ones(num_classes,1);
    end
    
    zero_one_weights = nan(size(samples_decisions) );
    for i = 1:num_classes
        zero_one_weights(:,i) = sigmf(samples_decisions(:,i), [sigmoid_slopes(i) 0] );
    end
end
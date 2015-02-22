
function [decision_values, model, predicted_label,accuracy] = runSvm(current_X, current_Y, current_X_test, current_Y_test, C, conf)
    if conf.sparse
        liblinear_options = sprintf('-c %g -s 5 -q',C); % -s 5 L1-regularized L2-loss support vector classification
    else
        liblinear_options = sprintf('-c %g -s 3 -q',C); % -s 3 L2-regularized L1-loss support vector classification (dual)
    end
    
    if conf.useWeightsToEqualize
        negative_to_positive_ration = sum(current_Y ==-1) / sum(current_Y ==1);
        liblinear_options = sprintf('%s -w-1 1 -w1 %g', liblinear_options, negative_to_positive_ration);
    end
    
    if  strcmp(conf.log_level ,'debug')
        fprintf('training svm with %s\n', liblinear_options);
    end
    
    if conf.useProbabilties
        liblinear_options = sprintf('%s -b 1', liblinear_options);
    end
    
    model = train( double(current_Y), sparse(double(current_X)), liblinear_options);
    %                [predicted_label_train, accuracyTrain, decision_values_train] = predict(double(current_Y), sparse(double(current_X)), model);
    [predicted_label, accuracy, decision_values] = predict(double(current_Y_test), sparse(double(current_X_test)), model);
    accuracy = accuracy(1);
end

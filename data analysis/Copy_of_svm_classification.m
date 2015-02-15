function [single_run_weights, weights, aucs, models] = svm_classification(X, y, conf)
    [num_samples_source, num_features] = size(X);
    rng(conf.random_seed);

    % First transform the labels into number from 1 to n (where n is the
    % number of unique labels).
    uniqueLabels = unique(y);
    [~, y] = ismember(y, uniqueLabels);
    
    fprintf('solving optimization...\n');
    [single_run_weights, weights, aucs, models] = svmClassification(y, X, uniqueLabels, conf);

%     check_triplets_matrix = [labels_source(triplets_indices(:,1)) , labels_target(triplets_indices(:,2:3))];
end

function [hyper_parms, dict] = getHyperparms(conf)
    hyper_parms = conf.C;
    dict = {'C'};
end

function normalizedData = normalizeZeroMeanUnitVariance(data,conf)
    [num_samples, num_features] = size(data);
    normalizedData = data;
    if conf.zero_mean
        fprintf('normalizing the data to have zero mean\n');
        normalizedData = normalizedData - repmat(mean(normalizedData,2),1,num_features );
    end
    
    if conf.unit_var
        fprintf('normalizing the data to have unit variance\n');
        normalizedData = normalizedData ./ repmat( std(normalizedData,0,2),1,num_features );
    end
end

function [single_run_weights, weights, aucs, models] = svmClassification(y , X,  uniqueLabels, conf)

    % normalize the data to have zero mean and unit variance
    X = normalizeZeroMeanUnitVariance(X,  conf);

    num_classes = length(uniqueLabels);
%     addpath('libsvm-dense-3.18/matlab');
    addpath('liblinear-1.96/matlab');
    K = 5;
    [num_samples, num_features] = size(X);
    [hyper_parms, hyper_parms_dict] = getHyperparms(conf);
    
    % Split the data into five. 
    % Do cross validation to find the best C, and report the accuracy and AUC.
    
    partsDivision = randomDivideToParts(num_samples ,K);
    source_indices = (1:num_samples)';
    
    best_Cs = nan(K,1);
    aucs = nan(K,1, num_classes);
    weights = nan(K, num_features);
    models = cell(K, 1);
    for i=1:K
        fprintf('=========== outer fold %d ==========\n', i);
        k_fold_source_indices = source_indices(~partsDivision(:,i),:);
        k_fold_source_indices_test = source_indices(partsDivision(:,i),:);
        k_fold_num_sources = size(k_fold_source_indices,1);
  
        if conf.only_one_cross_val
            assert( size(hyper_parms,1) == 1 ,'when running without 2 fold cross val there should only be a single combination of hyperparms');
            best_C = hyper_parms(1,   ismember('C', hyper_parms_dict)  );
            fprintf('running without 2Xcross validation using C=%g\n' , best_C);
        else
            innerFoldPartsDivisionSource = randomDivideToParts(k_fold_num_sources ,K);

            validation_auc = nan(size(hyper_parms,1),K, num_classes);
            for j=1:K
                fprintf('=========== inner fold %d ==========\n', j);
                inner_k_fold_source_indices = k_fold_source_indices(~innerFoldPartsDivisionSource(:,j),:);            
                inner_k_fold_source_indices_test = k_fold_source_indices(innerFoldPartsDivisionSource(:,j),:);

                current_Y = y(inner_k_fold_source_indices);
                current_X = X(inner_k_fold_source_indices,:); 
                current_Y_test = y(inner_k_fold_source_indices_test);
                current_X_test = X(inner_k_fold_source_indices_test,:);

                for h=1:size(hyper_parms,1)
                   C =  hyper_parms(h,   ismember('C', hyper_parms_dict)  ); 
                   [decision_values, model] = runSvm(current_X, current_Y, current_X_test, current_Y_test, C, conf);

                   auc = multiclassAUC(current_Y_test,decision_values); 
%                    auc = scoreAUC(current_Y_test == 1, decision_values);% auc should get a logical vector
                   fprintf('auc = ');
                   disp(auc);
                   validation_auc(h,j,:) = auc;
    %                validation_accuracy(h,j) = accuracy;
                end

            end

            meanFoldsAUC = mean(validation_auc,2);
            stdFoldsAUC = std(validation_auc,1,2);
            [~, bestParmIndex] = max(meanFoldsAUC);
            fprintf('best hyperparms: %s\n' , print_hyper_parm(bestParmIndex, hyper_parms, hyper_parms_dict) );

            best_C =  hyper_parms(bestParmIndex,   ismember('C', hyper_parms_dict)  );
        end
        
        current_Y = y(k_fold_source_indices);
        current_X = X(k_fold_source_indices,:);
        current_Y_test = y(k_fold_source_indices_test);
        current_X_test = X(k_fold_source_indices_test,:);
                
        [decision_values, model] = runSvm(current_X, current_Y, current_X_test, current_Y_test, best_C, conf);
        
        auc = multiclassAUC(current_Y_test,decision_values); 
        fprintf('auc = ');
        disp(auc);
         
        
        best_Cs(i) = best_C;
        aucs(i,:) = auc;
        weights(i,:) = model.w;
        models{i} = model;
    end
    
    
    %========= A single run using all the data =======
    fprintf('======Using all data to generate weights===========\n');
    
    current_Y = y;
    current_X = X;
    current_X_test = X;
    current_Y_test = y;
    [decision_values, model] = runSvm(current_X, current_Y, current_X_test, current_Y_test, mean(best_Cs), conf);
    
    auc = scoreAUC(current_Y_test == 1, decision_values);
    fprintf('auc (using all data for train and test) = %g\t\t \n', auc);
    
    single_run_weights = model.w;

end

function [decision_values, model] = runSvm(current_X, current_Y, current_X_test, current_Y_test, C, conf)
    if conf.sparse
        liblinear_options = sprintf('-c %g -s 5',C); % -s 5 L1-regularized L2-loss support vector classification
    else
        liblinear_options = sprintf('-c %g -s 3',C); % -s 3 L2-regularized L1-loss support vector classification (dual)
    end
    fprintf('training svm with %s\n', liblinear_options);
    model = train( double(current_Y), sparse(double(current_X)), liblinear_options);
    %                [predicted_label_train, accuracyTrain, decision_values_train] = predict(double(current_Y), sparse(double(current_X)), model);
    [~, ~, decision_values] = predict(double(current_Y_test), sparse(double(current_X_test)), model);

end


function output = print_hyper_parm(bestParmIndex, hyper_parms, hyper_parms_dict)
    output = '';
    best_hyperparms = hyper_parms(bestParmIndex,:);
    for i =1:length(hyper_parms_dict)
       output = sprintf('%s%s: %g,    ',output, hyper_parms_dict{i},  best_hyperparms(i) );
    end
end

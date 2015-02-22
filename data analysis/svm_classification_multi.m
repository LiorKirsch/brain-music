function [weights, aucs, models, uniqueLabels] = svm_classification_multi(X, y, batch_id, conf)
    [num_samples_source, num_features] = size(X);
    rng(conf.random_seed);

    % First transform the labels into number from 1 to n (where n is the
    % number of unique labels).
    uniqueLabels = unique(y);
    [~, y] = ismember(y, uniqueLabels);
    num_labels = length(uniqueLabels);
    
    [weights, aucs, models] = svmClassification(y, X, batch_id, conf);
%     weights = cell(num_labels,1) ;
%     aucs = cell(num_labels,1) ;
%     models = cell(num_labels,1) ;
% 
%     fprintf('solving optimization...\n');
%     for i = 1:num_labels
%         fprintf('class %s vs all\n ', uniqueLabels{i});
%         this_label_y = -1*ones(size(y));
%         this_label_y( y==i) = 1;
%         [~, weights{i}, aucs{i}, models{i}] = svmClassification(this_label_y, X, batch_id, conf);
%     end

%     check_triplets_matrix = [labels_source(triplets_indices(:,1)) , labels_target(triplets_indices(:,2:3))];
end

function [hyper_parms, dict] = getHyperparms(conf)
    hyper_parms = conf.C;
    dict = {'C'};
end

function [weights, aucs, models] = svmClassification(y , X,  batch_id, conf)

    % normalize the data to have zero mean and unit variance
    X = normalizeZeroMeanUnitVariance(X,  conf);


%     addpath('libsvm-dense-3.18/matlab');
    addpath('liblinear-1.96/matlab');
    K = 5;
    [num_samples, num_features] = size(X);
    [hyper_parms, hyper_parms_dict] = getHyperparms(conf);
    
    num_classes = length(unique(y));
    % Split the data into five. 
    % Do cross validation to find the best C, and report the accuracy and AUC.
    
%     partsDivision = randomDivideToPartsEqualPositive(num_samples ,K,y==1);
    partsDivision = groupDivideToParts(K,batch_id);
    source_indices = (1:num_samples)';
    
    best_Cs = nan(K,1);
    aucs = nan(K,1);
    weights = nan(K, num_classes, num_features);
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
%             this_fold_y = y(k_fold_source_indices);
%             innerFoldPartsDivisionSource = randomDivideToPartsEqualPositive(k_fold_num_sources ,K, this_fold_y==1);
            this_fold_batch_id = batch_id(k_fold_source_indices);
            innerFoldPartsDivisionSource = groupDivideToParts(K,this_fold_batch_id);

            validation_auc = nan(size(hyper_parms,1),K);
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
                   [decision_values, model, predicted_label,accuracy] = runSvm(current_X, current_Y, current_X_test, current_Y_test, C, conf);

%                    [mean_objective, ~] = classification_objective(decision_values, ones(size(current_Y_test)),current_Y_test);
                      
%                    auc = scoreAUC(current_Y_test == 1, decision_values);% auc should get a logical vector
% %                    if  strcmp(conf.log_level ,'debug')
%                         fprintf('auc = %g\t\t \n', auc);
% %                    end
                   validation_auc(h,j) = accuracy;%auc;
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
                
        [decision_values, model, predicted_label,accuracy] = runSvm(current_X, current_Y, current_X_test, current_Y_test, best_C, conf);

%         [mean_objective, ~] = classification_objective(decision_values, ones(size(current_Y_test)),current_Y_test);

%         auc = scoreAUC(current_Y_test == 1, decision_values);
%         fprintf('auc = %g\t\t \n', auc);
        
        best_Cs(i) = best_C;
        aucs(i) = accuracy;
        weights(i,:,:) = model.w;
        models{i} = model;
    end
    
    
%     %========= A single run using all the data =======
%     fprintf('======Using all data to generate weights===========\n');
%     
%     current_Y = y;
%     current_X = X;
%     current_X_test = X;
%     current_Y_test = y;
%     [decision_values, model] = runSvm(current_X, current_Y, current_X_test, current_Y_test, mean(best_Cs), conf);
%     
%     auc = scoreAUC(current_Y_test == 1, decision_values);
%     fprintf('auc (using all data for train and test) = %g\t\t \n', auc);
%     
%     single_run_weights = model.w;

end
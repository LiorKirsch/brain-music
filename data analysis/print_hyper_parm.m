
function output = print_hyper_parm(bestParmIndex, hyper_parms, hyper_parms_dict)
    output = '';
    best_hyperparms = hyper_parms(bestParmIndex,:);
    for i =1:length(hyper_parms_dict)
       output = sprintf('%s%s: %g,    ',output, hyper_parms_dict{i},  best_hyperparms(i) );
    end
end
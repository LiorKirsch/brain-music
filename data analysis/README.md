These functions perform perprocessing of the long MEG singal.
We parse and split the MEG signal into samples.
We also provide each sample with a label and the sound that was played when the signal was recorded.

blendSounds.m - use weights to create a mix of the songs

createConf.m - creates an object that hold the hyperparms for the run

get_data_folder.m - get the data folder (used to localy load the data)

groupDivideToParts.m - create the train/test splits, insure that the sample from the same batch are all in a single fold.

handle_white_noise_samples.m - uses the white noise samples to normalize the activity in the batch.

main_analysis.m - main file to run the analysis

normalizeZeroMeanUnitVariance.m  - normalzie the data to zero mean and unit variance

print_hyper_parm.m - prints the hyperparms

runSvm.m - incapsulates the libsvm function

showAUConBrain.m - used to visualize the AUC on the brain.

split_into_n_chunks.m - splits the signal into n chunks (splits 10sec into 10 chunks of 1sec)

svm_classification.m
svm_classification_multi.m


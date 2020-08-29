

%function for testing altered or natural
function [predictedClass,accuracy,dec_values] = test_altered_natural( test_label, test_data )

    model = load('trainedModel1.mat');
    [predictedClass, accuracy, dec_values] = svmpredict(test_label, test_data, model);

end
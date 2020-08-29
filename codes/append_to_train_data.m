

%function for training altered or natural
function append_to_train_data( train_label, train_data )
    matrix_to_write = [train_label train_data];
    mat2svm( matrix_to_write, 'altered_natural_train_data_2_120.txt' );
end
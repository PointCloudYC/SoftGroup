# train
# time ./tools/dist_train.sh configs/softgroup_scannet.yaml 4


# infer val set
time ./tools/dist_test.sh configs/softgroup_scannet.yaml checkpoints/softgroup_scannet_spconv2.pth 4 exp-val2/scannetv2/result 

# infer test set
# TODO: need create dummy semantic_label and instance_label, check issue: https://github.com/thangvubk/SoftGroup/issues/39, otherwise report an error "TypeError: transform_test() missing 2 required positional arguments: 'semantic_label' and 'instance_label' "
# time ./tools/dist_test.sh configs/softgroup_scannet_test.yaml checkpoints/softgroup_scannet_spconv2.pth 4 exp-test/scannetv2/result 

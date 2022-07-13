# train
./tools/dist_train.sh configs/softgroup_scannet.yaml 4


# infer s3dis
./tools/dist_test.sh configs/softgroup_scannet.yaml softgroup_scannet_spconv2.pth 4

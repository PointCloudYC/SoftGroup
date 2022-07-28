# First, finetune the pretrained HAIS point-wise prediction network (backbone) on S3DIS.
time ./tools/dist_train.sh configs/softgroup_5gdataset_backbone_fold5.yaml 2

# Then, train model from frozen backbone.
# time ./tools/dist_train.sh configs/softgroup_5gdataset_fold5.yaml 2


# time ./tools/dist_test.sh configs/softgroup_5gdataset_fold5.yaml softgroup_s3dis_spconv2.pth 2

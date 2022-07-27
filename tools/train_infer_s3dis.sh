# First, finetune the pretrained HAIS point-wise prediction network (backbone) on S3DIS.
# ~304 mins for the inference, check working_dirs/softgroup_s3dis_backbone_fold5
# time ./tools/dist_train.sh configs/softgroup_s3dis_backbone_fold5.yaml 4

# Then, train model from frozen backbone.
# suffer GPU OOM issue
# time ./tools/dist_train.sh configs/softgroup_s3dis_fold5.yaml 4


# infer s3dis
time ./tools/dist_test.sh configs/softgroup_s3dis_fold5.yaml checkpoints/softgroup_s3dis_spconv2.pth 2 exp-test/s3dis/result 
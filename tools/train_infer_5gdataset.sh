# First, finetune the pretrained HAIS point-wise prediction network (backbone) on S3DIS.
# ~304 mins for the inference, check working_dirs/softgroup_s3dis_backbone_fold5
# time ./tools/dist_train.sh configs/softgroup_s3dis_backbone_fold5.yaml 4

# Then, train model from frozen backbone.
# suffer GPU OOM issue
# time ./tools/dist_train.sh configs/softgroup_s3dis_fold5.yaml 4


# infer 5GDataset
echo 'test 5GDataset Area 12 using pretrained model on the S3DIS'
time ./tools/dist_test.sh configs/softgroup_5gdataset_area12.yaml checkpoints/softgroup_s3dis_spconv2.pth 2 exp-test/5gdataset/result-area12 

echo 'test 5GDataset Area 11 using pretrained model on the S3DIS'
time ./tools/dist_test.sh configs/softgroup_5gdataset_area11.yaml checkpoints/softgroup_s3dis_spconv2.pth 2 exp-test/5gdataset/result-area11

# echo 'test 5GDataset Area 11'
# time ./tools/dist_test.sh configs/softgroup_5gdataset_area11.yaml checkpoints/softgroup_s3dis_spconv2.pth 1 exp-test/5GDataset/result-area11 
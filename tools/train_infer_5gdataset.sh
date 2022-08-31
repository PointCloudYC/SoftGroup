# First, finetune the pretrained HAIS point-wise prediction network (backbone) on S3DIS.
# ~600 mins for the training w. 30 epochs, check working_dirs/softgroup_s3dis_backbone_fold5
# time ./tools/dist_train.sh configs/softgroup_5gdataset_backbone.yaml 2

# Then, train model from frozen backbone, suffer GPU OOM issue
time ./tools/dist_train.sh configs/softgroup_5gdataset.yaml 2


# eval the val set
# time ./tools/dist_test.sh configs/softgroup_5gdataset.yaml work_dirs/softgroup_5gdataset/latest.pth 2 exp-test/5gdataset/result-val 
# time ./tools/dist_test.sh configs/softgroup_5gdataset_fold5.yaml softgroup_s3dis_spconv2.pth 2


# eval the test set
# time ./tools/dist_test.sh configs/softgroup_5gdataset_test.yaml work_dirs/softgroup_5gdataset/latest.pth 2 exp-test/5gdataset/result-test


# vis
# time ./tools/visualize_5gdataset.sh

# NEXT
# tune hyper-parameters
# train on train and validation set, then infer on the test set

# infer 5GDataset
# echo 'test 5GDataset Area 12 using pretrained model on the S3DIS'
# time ./tools/dist_test.sh configs/softgroup_5gdataset_area12.yaml checkpoints/softgroup_s3dis_spconv2.pth 2 exp-test/5gdataset/result-area12 
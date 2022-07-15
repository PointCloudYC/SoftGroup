## Time

- 1.5h; set up the dev env on server-HP w. softgroup env + install the scannetv2 + tutorial(yc.md and install.sh)
- 1.5h; preprocess s3dis and tackle the bugs (shown in the FAQ section)
- 3h; inference on val set of the scannetv2 w. success, still some problems for infer on the test set of scannetv2

## TODOs

- eval metrics; AP, AP_50/25, Bbox AP_50/25
- [x] cp scannetv2, and setup the dirs
- [x] make inference on the val set
- make inference on the test set
- [x] play w. visualization;
- infer for custom dataset, e.g., vincent's UGV data

## install

- check install.sh for details to install the env on `server-HP` on the `softgroup` env; 
>Note that: if your cuda>10.2, you should install corresponding versions, herein I install python=3.7, CUDA=11.3 and spconv-cu113, otherwise it reported an error like "cuda version mismatch" when compling custom pytorch ops when running the `python setup.py build_ext develop`.


## ScanNet v2
### download the ScanNet v2

- install the whole dataset, about 1.3TB

### prepare the dataset

run `prepare_data.sh`; internally, it do the following:
- only copy 4 files from the ScanNet v2 which are `*._vh_clean_2.ply and *._vh_clean_2.labels.ply`; details check `split_data.py`; this means that we no longer need download the whole scannet v2 (1.4TB, tooks 6 days) but download these 4 files. 
- run `prepare_data_inst.py`
- run `prepare_data_inst_gttxt.py` to generate instance groundtruth .txt files (for evaluation)

**After runing the script, several folders are generated train/val/test and val_gt where each scan contains a ply point cloud and corresponding labels and other meta files (mainly for the train/val folder)

### train

- ./tools/dist_train.sh configs/softgroup_scannet.yaml 4


### inferrence

- ./tools/dist_test.sh $CONFIG_FILE $CHECKPOINT $NUM_GPU
```
./tools/dist_test.sh configs/softgroup_scannet.yaml softgroup_scannet_spconv2.pth 4
```


### visualization

use `visualization.py` to check instance or semantic results, more check the visualization.md (note there are some argument naming errors in this file); below is successful verison.

```
time python tools/visualization.py \
--dataset ${dataset} \
--prediction_path ${prediction_path}\
--data_split ${data_split} \
--room_name ${room_name} \
--task ${task} \
--out ${out}
```


### run on the custom data

TODO


## S3DIS
### download and preprocess the S3DIS

- download the whole dataset, about 4GB+
- symlink dataset folder and preprocess the dataset
```
cd SoftGroup/dataset/s3dis
ln -s /media/yinchao/datasets/S3DIS_SQN/Stanford3dDataset_v1.2_Aligned_Version ./Stanford3dDataset_v1.2
bash prepare_data.sh
```

After running the script the folder structure should look like below
```
SoftGroup
├── dataset
│   ├── s3dis
│   │   ├── Stanford3dDataset_v1.2
│   │   ├── preprocess
│   │   ├── preprocess_sample
│   │   ├── val_gt
```

For more details for preprocessing the ScanNetv2 ,check the HAIS repo: https://github.com/hustvl/HAIS, where the ply and label files are mainly used for training/val/test.

### train

First, finetune the pretrained HAIS point-wise prediction network (backbone) on S3DIS.

>./tools/dist_train.sh configs/softgroup_s3dis_backbone_fold5.yaml 4


Then, train model from frozen backbone.

>./tools/dist_train.sh configs/softgroup_s3dis_fold5.yaml 4



### inferrence

- ./tools/dist_test.sh $CONFIG_FILE $CHECKPOINT $NUM_GPU
```
./tools/dist_test.sh configs/softgroup_s3dis_fold5.yaml softgroup_s3dis_spconv2.pth 4
```


### visualization

TODO


## FAQ

### can not preprocesss the S3DIS and report the key '.DS' is not existed

- reason: '.DS_Store' folder exists in the Area_1
- solution: rm the .DS_Store folder; `rm Area_*/.DS_Store`


### ValueError: invalid literal for int() with base 10: '218.000000'

- some files have literal string int the data;
- check: https://github.com/thangvubk/SoftGroup/issues/51 and revise the S3DIS data according to the patch file https://raw.githubusercontent.com/Gorilla-Lab-SCUT/gorilla-3d/dev/gorilla3d/preprocessing/s3dis/s3dis_align.patch
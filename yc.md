## Time

- 1.5h; set up the dev env on server-HP w. softgroup env + install the scannetv2 + tutorial(yc.md and install.sh)
- 1.5h; preprocess s3dis and tackle the bugs (shown in the FAQ section)
- 3h; inference on val set of the scannetv2 w. success, still some problems for infer on the test set of scannetv2

## TODOs

- eval metrics; AP, AP_50/25, Bbox AP_50/25
- [x] set up scannet v2; cp scannetv2, and setup the dirs
- [x] make inference on the val set
- [x] play w. visualization;
- make inference on the test set with newly created dummy sem/ins labels.
- train/validate a custom dataset, e.g., vincent's UGV data

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

Currently, only succeed on the validation set; For the test set, need create dummy semantic_label and instance_label for the test set to allow run the `test.py`, see [issue 39](https://github.com/thangvubk/SoftGroup/issues/39)


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

- set up the config, exp. scale, grouping_cfg.radius in each config, details see: https://github.com/thangvubk/SoftGroup/blob/main/docs/custom_dataset.md and `SoftGroup/docs/config_explanation.md`


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

- ./tools/dist_test.sh $CONFIG_FILE $CHECKPOINT $NUM_GPU; inference on S3DIS Area_5 costs about 6h(456min), while test on 5GDataset costs 6h (359min)
```
./tools/dist_test.sh configs/softgroup_s3dis_fold5.yaml softgroup_s3dis_spconv2.pth 4
```

Currently, on server-HP(4 T4 GPS) not succeed on the test set(Area_5) but **on server-superrico(2 3090 GPUs) succeed!!!**, it need a larger GPU(My experiments are performed on 48G GPU so that i don't have memory issues) based on the  [about S3DIS test · Issue #45 · thangvubk/SoftGroup](https://github.com/thangvubk/SoftGroup/issues/45) and [need lger GPU to make inference on S3DIS](https://github.com/thangvubk/SoftGroup/issues/68), maybe 3090 GPU can help. Yet, 


### visualization

TODO


## FAQ 

### can not preprocesss the S3DIS and report the key '.DS' is not existed

- reason: '.DS_Store' folder exists in the Area_1
- solution: rm the .DS_Store folder; `rm Area_*/.DS_Store`


### ValueError: invalid literal for int() with base 10: '218.000000'

- some files have literal string int the data;
- check: https://github.com/thangvubk/SoftGroup/issues/51 and revise the S3DIS data according to the patch file https://raw.githubusercontent.com/Gorilla-Lab-SCUT/gorilla-3d/dev/gorilla3d/preprocessing/s3dis/s3dis_align.patch
>another quick way to fix this is to copy the coorect to the problematic S3DIS by `unzip patch.zip -d ./` where patch.zip contain the three files (which are zipped by `zip -r patch.zip Area_2/auditorium_1/auditorium_1.txt Area_5/hallway_6/Annotations/ceiling_1.txt Area_3/hallway_2/hallway_2.txt`


### report CUDA 700 and SPCONV_DEBUG_SAVE_PATH not found

see [Spconv and Cuda error while training on my own dataset · Issue #56 · thangvubk/SoftGroup](https://github.com/thangvubk/SoftGroup/issues/56)


### train the softgroup on 5gdataset with backbone, report RuntimeError: torch.cat(): expected a non-empty list of Tensors for the softgroup.py

- solution: set the config's `semantic_only`=True and `fixed_modules`=[]; since when set the semantic_only to be true, you can not train the model if you fixed all modules

* [fixed\_modules causes training issues · Issue #66 · thangvubk/SoftGroup](https://github.com/thangvubk/SoftGroup/issues/66)
# visualize

dataset="scannetv2"
# val mode
prediction_path="./exp-val/scannetv2/result"
data_split="val"
# room_name="scene0011_00"
# room_name="scene0685_00"
room_name="scene0693_02"
tasks=("instance_gt" "instance_pred" "semantic_gt" "semantic_pred")

# test mode; NOTE: need address test issue first which need to create dummy semantic&instance labels.
# prediction_path="./exp-test/scannetv2/result"
# data_split="test"
# room_name="scene0707_00"
# no instance_gt task, semantic_gt
# tasks=("instance_pred" "semantic_pred")


for task in "${tasks[@]}"; do

    out="./exp/scannetv2/result/vis/${data_split}/${room_name}_${task}_vis.ply"
    echo "Output file is ${out}"

    time python tools/visualization.py \
    --dataset ${dataset} \
    --prediction_path ${prediction_path}\
    --data_split ${data_split} \
    --room_name ${room_name} \
    --task ${task} \
    --out ${out}

done
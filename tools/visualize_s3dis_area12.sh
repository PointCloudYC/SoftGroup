# visualize

dataset="s3dis"
prediction_path="./exp-test/5gdataset/result-area12"
vis_path="${prediction_path}/vis"
room_names=("Area_12_room_1")
# room_names=("Area_5_conferenceRoom_1" "Area_5_hallway_1" "Area_5_office_1" "Area_5_storage_1" "Area_5_WC_1")

# tasks=("instance_pred") # input or offset_semantic_pred
tasks=("instance_gt" "instance_pred" "semantic_gt" "semantic_pred") # input or offset_semantic_pred


for room_name in "${room_names[@]}"; do
    for task in "${tasks[@]}"; do
        mkdir -p ${vis_path}
        out="${prediction_path}/vis/${room_name}_${task}_vis.ply"
        echo "Output file is ${out}"

        time python tools/visualization.py \
        --prediction_path ${prediction_path}\
        --room_name ${room_name} \
        --task ${task} \
        --out ${out}
    done
done
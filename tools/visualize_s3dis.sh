# visualize

dataset="s3dis"
prediction_path="./exp-test/s3dis/result"

# room_names=("Area_5_conferenceRoom_1")
room_names=("Area_5_conferenceRoom_1" "Area_5_hallway_1" "Area_5_office_1" "Area_5_storage_1" "Area_5_WC_1")

# tasks=("instance_pred") # input or offset_semantic_pred
tasks=("instance_gt" "instance_pred" "semantic_gt" "semantic_pred") # input or offset_semantic_pred


for room_name in "${room_names[@]}"; do
    for task in "${tasks[@]}"; do
        out="${prediction_path}/vis/${room_name}_${task}_vis.ply"
        echo "Output file is ${out}"

        time python tools/visualization.py \
        --prediction_path ${prediction_path}\
        --room_name ${room_name} \
        --task ${task} \
        --out ${out}
    done
done
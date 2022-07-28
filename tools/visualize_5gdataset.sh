# visualize

dataset="5gdataset"
prediction_path="./exp-test/5gdataset/result"
vis_path="${prediction_path}/vis"

room_names=("Area_4_classroom_2" "Area_4_office" "Area_5_room_1")

# BUG: need  obtain the instance model checkpoint, then get the vis results
# tasks=("semantic_gt" "semantic_pred") # input or offset_semantic_pred
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
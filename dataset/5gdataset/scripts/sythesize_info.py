import argparse
import glob
import os
import os.path as osp

import numpy as np
import pandas as pd
import torch
from sklearn.neighbors import NearestNeighbors

INV_OBJECT_LABEL = {
    0: 'chair',
    1: 'column',
    2: 'floor',
    3: 'table',
    4: 'wall',
    5: 'clutter',
}

OBJECT_LABEL = {name: i for i, name in INV_OBJECT_LABEL.items()}


def object_name_to_label(object_class):
    r"""convert from object name in S3DIS to an int"""
    object_label = OBJECT_LABEL.get(object_class, OBJECT_LABEL['clutter'])
    return object_label

def get_parser():
    parser = argparse.ArgumentParser(description='5GDataset data prepare')
    parser.add_argument('--data-root', type=str, default='/opt/code/SoftGroup/dataset/5gdataset/5GDataset', help='root dir save data')
    parser.add_argument(
        '--save-file', type=str, default='./summary.csv', help='directory save info')
    # parser.add_argument(
        # '--patch', action='store_true', help='patch data or not (just patch at first time running)')
    # parser.add_argument('--align', action='store_true', help='processing aligned dataset or not')
    parser.add_argument('--verbose', action='store_true', help='show processing room name or not')

    args_cfg = parser.parse_args()

    return args_cfg

if __name__ == '__main__':
    args = get_parser()
    data_root = args.data_root
    # processed data output dir
    save_file = args.save_file
    # os.makedirs(save_dir, exist_ok=True)

    area_list = ['Area_1', 'Area_2','Area_3', 'Area_4', 'Area_5']
    # area_list = ['Area_11', 'Area_12']
    # area_list = ['Area_6']

    number_category_list=[]

    for area_id in area_list:
        print(f'Processing: {area_id}')
        number_category_each_area = {name: 0 for i, name in INV_OBJECT_LABEL.items()}
        area_dir = osp.join(data_root, area_id)
        # get the room name list for each area
        room_name_list = os.listdir(area_dir)
        try:
            room_name_list.remove(f'{area_id}_alignmentAngle.txt')
            room_name_list.remove('.DS_Store')
        except:  # noqa
            pass
        for room_name in room_name_list:
            scene = f'{area_id}_{room_name}'
            if args.verbose:
                print(f'processing: {scene}')

            # obtain labeled instance names
            instance_name_list = os.listdir(f'{area_dir}/{room_name}/Annotations')
            for instance_name in instance_name_list:
                print(f'processing: {instance_name}')
                if '_' in instance_name:
                    category_cur = instance_name.split('_')[0]
                else:
                    category_cur = instance_name.split('.')[0]
                num_points = sum(1 for line in open(f'{area_dir}/{room_name}/Annotations/{instance_name}'))
                number_category_each_area[category_cur]+=num_points-1 # each txt has 1 blank line

        number_category_list.append(number_category_each_area)

        df = pd.DataFrame(number_category_list)
        df.to_csv(save_file, sep='\t', encoding='utf-8')

import argparse
import glob
import os
import os.path as osp

import numpy as np
import pandas as pd
import torch
from sklearn.neighbors import NearestNeighbors

def get_parser():
    parser = argparse.ArgumentParser(description='5GDataset data prepare')
    parser.add_argument( '--data-root', type=str, default='/opt/code/SoftGroup/dataset/5gdataset/5GDataset', help='root dir save data')
    parser.add_argument('--verbose', action='store_true', help='show processing room name or not')

    args_cfg = parser.parse_args()

    return args_cfg


if __name__ == '__main__':
    args = get_parser()
    data_root = args.data_root

    area_list = ['Area_11', 'Area_12']

    for area_id in area_list:
        print(f'Processing: {area_id}')
        area_dir = osp.join(data_root, area_id)
        area_dir_new =osp.join(f'{data_root}_new', area_id)
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
                instance_file = f'{area_dir}/{room_name}/Annotations/{instance_name}'
                instance_file_new = f'{area_dir_new}/{room_name}/Annotations/{instance_name}'
                # create the dir
                os.makedirs(os.path.dirname(instance_file_new), exist_ok=True)
                with open(instance_file, "r") as lines:
                    # file_new = open(instance_file_new.split('.')[0]+'_new.txt','a')
                    file_new = open(instance_file_new,'a')
                    for line in lines:
                        # print(line)
                        x= line.split(' ')[0]
                        x= float(x)/1000
                        y= line.split(' ')[1]
                        y= float(y)/1000
                        z= line.split(' ')[2]
                        z= float(z)/1000
                        r= line.split(' ')[3]
                        g= line.split(' ')[4]
                        b= line.split(' ')[5]

                        line_new='{:.5f} {:.5f} {:.5f} {} {} {}'.format(x,y,z,r,g,b)
                        # write to a new file
                        file_new.write(line_new)
                    file_new.close()
                    print(f"{instance_file} completed.")
            print(f"{area_id}_{room_name} completed.")
        print(f"{area_id} completed.")
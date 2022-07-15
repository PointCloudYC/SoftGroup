#!/bin/bash
echo Copy data
python split_data.py
echo Preprocess data
time python prepare_data_inst.py --data_split train
time python prepare_data_inst.py --data_split val
time python prepare_data_inst.py --data_split test
time python prepare_data_inst_gttxt.py

# create the env
# conda create -n softgroup python=3.7 -y
# conda activate softgroup

# install the packages
# conda install pytorch cudatoolkit=10.2 -c pytorch -y
# pip install spconv-cu102 -y
conda install pytorch torchvision torchaudio cudatoolkit=11.3 -c pytorch -y
pip install spconv-cu113
pip install -r requirements.txt

# install build requirement
sudo apt-get install libsparsehash-dev

# setup (install custom ops)
python setup.py build_ext develop
#!/bin/bash

apt install cmake
apt install qtbase5-dev
apt install libqt5opengl5-dev
apt install libqglviewer-dev-qt5
apt install freeglut3-dev
apt install libmagick++-dev
apt install libtinyxml-dev
apt install libqwt-qt5-dev
apt install cimg-dev
apt install libassimp-dev

add-apt-repository multiverse
apt install nvidia-cuda-toolkit

apt install clang-8

apt install libgcc-8-dev
apt install libstdc++-8-dev

apt remove libgcc-10-dev
apt remove libstdc++-10-dev

# apt remove libglm-dev
# apt remove libglew-dev

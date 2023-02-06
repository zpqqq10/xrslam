# Getting Started

This page provides basic tutorials about the usage of XRSLAM.

## Data Preparation

Please refer to [data_preparation.md](./dataset_preparation.md) for data preparation.

## Installation

### Requirements

* C++17
* GCC9/Clang13
* CMake 3.15+
* [XRPrimer](https://github.com/openxrlab/xrprimer)

Clone XRPrimer to keep the same root directory as XRSLAM.

### Build and Run

Firstly, switch XRPrimer to the branch of the specified OpenCV version `git checkout xrslam-opencv3.4.7`

#### Linux/Mac

- In XRPrimer, run `cmake -S. -Bbuild -DBUILD_EXTERNAL=ON -DCMAKE_BUILD_TYPE=Release -DENABLE_PRECOMPILED_HEADERS=OFF && cmake --build build --target install -j8` to configure some common dependencies.
- In XRSLAM, run `cmake -B build && cmake --build build -j8` to generate the project using cmake.
- Start the XRSLAM pc palyer  with command  `./build/xrslam-pc/player/xrslam-pc-player -c configs/euroc.yaml --tum trajectory.tum euroc:///data/EuRoC/MH_01_easy/mav0`

> GLFW Error: NSGL: Failed to find a suitable pixel format
> 虚拟机的问题，不能跑该xrslam-pc/player
> 
> 我把数据保存到了./data/EuRoC下，使用如下命令启动：
> 
> ./build/xrslam-pc/player/xrslam-pc-player -c configs/euroc.yaml --tum trajectory.tum -p euroc://./data/EuRoC/MH_01_easy/mav0
> 
> ./build/xrslam-pc/player/xrslam-pc-player -c configs/euroc.yaml --tum trajectory.tum -p euroc://./data/EuRoC/MH_05_difficult/mav0
> 
> 即文件结构如
> 
> ```
> .
> ├── build
> ├── build-ios.conf.defaults
> ├── build-ios.sh
> ├── CITATION.cff
> ├── cmake
> ├── CMakeLists.txt
> ├── configs
> │   └── euroc.yaml
> ├── data
> │   └── EuRoC
> ├── Dockerfile
> ├── docs
> │   ├── en
> │   └── images
> ├── LICENSE
> ...
> ```
> 


#### iOS

- In XRPrimer, run `./build-ios.sh` to configure some common dependencies.
- In XRSLAM, run `./build-ios.sh` to generate the XCode project using cmake.
  - use `security find-identity -v -p codesigning` to find personal development team id
- The target `xrslam-ios-visulaizer` is what you need to download to the iPhone, and an APP named `XRSLAM` will start automatically.

> 在Mac上，进行到某一步（似乎是第二步时）会因为development team id的问题而终止，但是此时XCode工程已经生成了，用XCode打开该工程继续即可。

For more information on installation, please refer to [installation.md](./installation.md).

## Evaluation

Please refer to [euroc_evaluation.md](./tutorials/euroc_evaluation.md) for evaluation.

## More information

* [AR Demo](./tutorials/app_intro.md)
* [Benchmark](./benchmark.md)
* [Changelog](./changelog.md)
* [Configuration Parse](./config_parse.md)
* [FAQ](./faq.md)

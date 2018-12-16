# Scripts used to build seastar shared library and package for ubuntu

Supported environment: Ubuntu 18.04+

Build steps:

``` text
git clone https://github.com/cpv-project/seastar-builder
cd seastar-builder
git clone --recurse-submodules https://github.com/cpv-project/seastar
sudo sh seastar/install-dependencies.sh
sh build-release.sh
sh pack-deb.sh
```

Check steps:

``` text
cd seastar/demos
g++ $(pkg-config --cflags seastar) echo_demo.cc $(pkg-config --libs seastar)
./a.out
```

# License

LICENSE: MIT LICENSE<br/>
Copyright © 2018 303248153@github<br/>
If you have any license issue please contact 303248153@qq.com.

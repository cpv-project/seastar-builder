# Scripts used to build seastar shared library and package for ubuntu

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/7b0c2c57cca44b4682a7afb51d179f82)](https://www.codacy.com/app/compiv/seastar-builder?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=cpv-project/seastar-builder&amp;utm_campaign=Badge_Grade)
[![license](https://img.shields.io/github/license/cpv-project/seastar-builder.svg)]()

### Install from ubuntu ppa (for users)

Supported version: 18.04 (bionic)

``` text
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:compiv/cpv-project
sudo apt-get update
sudo apt-get install seastar
```

In addition, you have to install gcc-9 because the package is built with it.<br/>
(Why use gcc-9: seastar won't support old compiler for long period, and I don't want to add patches for old compiler)

``` text
sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
sudo apt-get install g++-9
```

### Compile and execute example program (for users)

``` text
cd examples
g++-9 $(pkg-config --cflags seastar) tcp_echo_server.cpp $(pkg-config --libs seastar) -O3
./a.out
```

### Compile and execute example program in debug mode with sanitizers (for users)

``` text
cd examples
g++-9 $(pkg-config --cflags seastar-debug) tcp_echo_server.cpp $(pkg-config --libs seastar-debug)
./a.out
```

### Build local package (for advance users)

To build this package, gcc-9 is required, see install steps above.

``` text
sh build.sh local
```

### Build source package and publish to ppa (for myself)

``` text
sh build.sh ppa
cd build
dput ppa:username/project seastar_version_source.changes
```

### Performance tips

Because seastar implements custom task scheduler, the performance compare to other framework maybe lower on low end machine, one solution is set higher value of `--task-quota-ms` option, like `--task-quota-ms=20`, this solution has increase throughput by 35% on my vps. Of cause there will be some penalty, see [this discussion](https://groups.google.com/forum/#!topic/seastar-dev/igjSoMRQupo) for more details.

### Links

- [PPA](https://launchpad.net/~compiv/+archive/ubuntu/cpv-project)
- [Official seastar repository](https://github.com/scylladb/seastar)

# License

LICENSE: MIT LICENSE<br/>
Copyright © 2018-2019 303248153@github<br/>
If you have any license issue please contact 303248153@qq.com.

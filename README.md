# Scripts used to build seastar shared library and package for ubuntu

### Install from ubuntu ppa (for users)

Supported version: 18.04 (bionic)

``` text
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:compiv/cpv-project
sudo apt-get update
sudo apt-get install seastar
```

### Compile and execute example program (for users)

``` text
cd examples
g++ $(pkg-config --cflags seastar) tcp_echo_server.cpp $(pkg-config --libs seastar)
# why use epoll backend:
#	because aio is not allowed inside container (EPERM)
./a.out --reactor-backend epoll
```

### Compile and execute example program in debug mode with sanitizers (for users)

``` text
cd examples
g++ $(pkg-config --cflags seastar-debug) tcp_echo_server.cpp $(pkg-config --libs seastar-debug)
# why use epoll backend:
#	because aio is not allowed inside container (EPERM)
./a.out --reactor-backend epoll
```

### Build local package (for advance users)

``` text
sh build.sh local
```

### Build source package and publish to ppa (for myself)

``` text
sh build.sh ppa
cd build
dput ppa:username/project seastar_version_source.changes
```

### Links

- [PPA](https://launchpad.net/~compiv/+archive/ubuntu/cpv-project)
- [Official seastar repository](https://github.com/scylladb/seastar)

# License

LICENSE: MIT LICENSE<br/>
Copyright © 2018 303248153@github<br/>
If you have any license issue please contact 303248153@qq.com.

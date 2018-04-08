# Scripts used to build seastar static and dynamic library

Build steps:

``` text
git clone --recurse-submodules https://github.com/scylladb/seastar
git clone https://github.com/cpv-project/seastar-builder
cd seastar
sh install-dependencies.sh
cd ../seastar-builder
sh build-debug.sh # or build-release.sh
```

# License

LICENSE: MIT LICENSE<br/>
Copyright © 2018 303248153@github<br/>
If you have any license issue please contact 303248153@qq.com.


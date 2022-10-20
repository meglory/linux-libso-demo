# linux-libso-demo
linux动态链接库demo

## 使用步骤

### 1. 编译so
```shell
# make
cc -c src/test.c -Iinclude -fPIC -shared -o obj/test.o
mkdir -p lib
cc  -shared -o lib/libprint_func.so obj/test.o -fPIC -s -Wl,-z,relro,-z,now,-z,noexecstack -fstack-protector-all
finish libprint_func.so

```
执行了make之后，会在当前目录生成两个文件夹lib和obj，lib目录存放SO文件，obj目录存在生成的obj文件
```shell
# ls -al
drwxr-xr-x   7 root root  113 10月 20 19:48 .
dr-xr-x---. 15 root root 4096 10月 20 19:48 ..
drwxr-xr-x   8 root root  163 10月 20 19:48 .git
drwxr-xr-x   2 root root   20 10月 20 19:48 include
drwxr-xr-x   2 root root   30 10月 20 19:48 lib
-rw-r--r--   1 root root   90 10月 20 19:48 main.c
-rw-r--r--   1 root root  501 10月 20 19:48 Makefile
drwxr-xr-x   2 root root   20 10月 20 19:48 obj
-rw-r--r--   1 root root   44 10月 20 19:48 README.md
drwxr-xr-x   2 root root   20 10月 20 19:48 src

```

### 2. 生成可执行文件
```shell
# lgcc -o test main.c -lprint_func -Llib -Iinclude -Wall
drwxr-xr-x   7 root root  113 10月 20 19:48 .
dr-xr-x---. 15 root root 4096 10月 20 19:48 ..
drwxr-xr-x   8 root root  163 10月 20 19:48 .git
drwxr-xr-x   2 root root   20 10月 20 19:48 include
drwxr-xr-x   2 root root   30 10月 20 19:48 lib
-rw-r--r--   1 root root   90 10月 20 19:48 main.c
-rw-r--r--   1 root root  501 10月 20 19:48 Makefile
drwxr-xr-x   2 root root   20 10月 20 19:48 obj
-rw-r--r--   1 root root   44 10月 20 19:48 README.md
drwxr-xr-x   2 root root   20 10月 20 19:48 src

```
-l：说明库文件的名字，使用-lprint_func (即libprint_func库文件)

-L：指定编译库文件所在位置

-I（大写的i）：指定头文件所在文件

-Wall：打印所有警告

注意：编译时必须包括SO中函数的头文件（test.h），否则会提示隐形声明的警告。

### 3. 执行可执行文件
直接执行可执行文件，会提示找不到libprint_func.so文件
```shell
# ./test
./test: error while loading shared libraries: libprint_func.so: cannot open shared object file: No such file or directory
```
执行ldd命令，可以查看到依赖的库：
```shell
# ldd ./test
	linux-vdso.so.1 (0x00007ffea7dda000)
	libprint_func.so => not found
	libc.so.6 => /lib64/libc.so.6 (0x00007faf4ed5f000)
```
### 4. 添加so库到系统库下

首先，通过gcc -print-search-dirs命令，查看系统依赖库目录：

```shell
# gcc -print-search-dirs
安装：/usr/lib/gcc/x86_64-redhat-linux/8/
程序：=/usr/libexec/gcc/x86_64-redhat-linux/8/:/usr/libexec/gcc/x86_64-redhat-linux/8/:/usr/libexec/gcc/x86_64-redhat-linux/:/usr/lib/gcc/x86_64-redhat-linux/8/:/usr/lib/gcc/x86_64-redhat-linux/:/usr/lib/gcc/x86_64-redhat-linux/8/../../../../x86_64-redhat-linux/bin/x86_64-redhat-linux/8/:/usr/lib/gcc/x86_64-redhat-linux/8/../../../../x86_64-redhat-linux/bin/
库：=/usr/lib/gcc/x86_64-redhat-linux/8/:/usr/lib/gcc/x86_64-redhat-linux/8/../../../../x86_64-redhat-linux/lib/x86_64-redhat-linux/8/:/usr/lib/gcc/x86_64-redhat-linux/8/../../../../x86_64-redhat-linux/lib/../lib64/:/usr/lib/gcc/x86_64-redhat-linux/8/../../../x86_64-redhat-linux/8/:/usr/lib/gcc/x86_64-redhat-linux/8/../../../../lib64/:/lib/x86_64-redhat-linux/8/:/lib/../lib64/:/usr/lib/x86_64-redhat-linux/8/:/usr/lib/../lib64/:/usr/lib/gcc/x86_64-redhat-linux/8/../../../../x86_64-redhat-linux/lib/:/usr/lib/gcc/x86_64-redhat-linux/8/../../../:/lib/:/usr/lib/
```
然后，直接将so库移到/lib64/下，然后再执行

```shell
# cp -r lib/libprint_func.so /lib64/libprint_func.so
# ./test
i = 0
i = 1
i = 2
i = 3
i = 4
i = 5
i = 6
i = 7
i = 8
i = 9
```
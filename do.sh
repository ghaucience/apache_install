APR="apr"
APRUTIL="apr-util"
PCRE="pcre"
HTTPD="httpd"
APRVER="1.6.3"
APRUTILVER="1.6.1"
HTTPDVER="2.4.29"
PCREVER="8.38"

# donwload 
mkdir -p dl
cd ./dl
#wget http://mirrors.tuna.tsinghua.edu.cn/apache/httpd/httpd-2.4.29.tar.gz
#wget http://mirrors.tuna.tsinghua.edu.cn/apache/apr/apr-1.6.3.tar.gz 
#wget http://mirrors.tuna.tsinghua.edu.cn/apache/apr/apr-util-1.6.1.tar.gz 
#wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.38.tar.bz2
cd -

# xtract
mkdir -p ./build
#cd ./build
#tar zxvf ../dl/${HTTPD}-${HTTPDVER}.tar.gz -C .
#tar jxvf ../dl/${PCRE}-${PCREVER}.tar.bz2 -C .
#mkdir -p ./${HTTPD}-${HTTPDVER}/srclib
#tar zxvf ../dl/${APR}-${APRVER}.tar.gz -C ./${HTTPD}-${HTTPDVER}/srclib
#tar zxvf ../dl/${APRUTIL}-${APRUTILVER}.tar.gz -C ./${HTTPD}-${HTTPDVER}/srclib
#mv ./${HTTPD}-${HTTPDVER}/srclib/${APR}-${APRVER} ././${HTTPD}-${HTTPDVER}/srclib/${APR}
#mv ./${HTTPD}-${HTTPDVER}/srclib/${APRUTIL}-${APRUTILVER} ././${HTTPD}-${HTTPDVER}/srclib/${APRUTIL}
cd -

cd ./build/${PCRE}-${PCREVER}
#CFLAGS="-g -O2" ./configure --prefix=`pwd`/build/
#make
#make install
cd -

cd ./build/${HTTPD}-${HTTPDVER}
#CFLAGS="-g -O2" LIBS=-L`pwd`/../${PCRE}-${PCREVER}/build/lib ./configure \
#	--with-included-apr \
#	ac_cv_file__dev_zero=yes  \
#	ac_cv_func_setpgrp_void=yes  \
#	apr_cv_tcp_nodelay_with_cork=yes ac_cv_sizeof_struct_iovec=8 \
#  ap_cv_void_ptr_lt_long=4  \
#	--with-pcre=`pwd`/../${PCRE}-${PCREVER}/build 
#make
cd -


mkdir -p ./build/pc-httpd
mkdir -p ./build/pc-apr
cp ./build/${HTTPD}-${HTTPDVER}/server/gen_test_char ./build/pc-httpd/
cp ./build/${HTTPD}-${HTTPDVER}/srclib/apr/tools/gen_test_char ./build/pc-apr/
make -C ./build/${PCRE}-${PCREVER} uninstall
make -C ./build/${PCRE}-${PCREVER} distclean
make -C ./build/${HTTPD}-${HTTPDVER} distclean


cd ./build/${PCRE}-${PCREVER}
#export ARMDIR="/opt/jerry/tool"
#export PATH="$PATH:${ARMDIR}/bin"
#CC=arm-linux-androideabi-gcc \
#CXX=arm-linux-androideabi-g++ \
#CFLAGS="-g -O2" ./configure --prefix=`pwd`/build \
#--host=arm-linux-androideabi
#make
#make install
cd -

cd ./build/${HTTPD}-${HTTPDVER}
sudo mkdir -p /mnt/arm/apache
cp `pwd`/../pc-httpd/gen_test_char ./server/
cp `pwd`/../pc-apr/gen_test_char ./srclib/apr/tools/
export ARMDIR="/opt/jerry/tool"
export PATH="$PATH:${ARMDIR}/bin"
CC=arm-linux-androideabi-gcc \
CXX=arm-linux-androideabi-g++ \
CFLAGS="-g -O2 -lpthread" LIBS=-L`pwd`/../pcre-8.38/build/lib \
./configure --prefix=/mnt/ram/apache/ --with-included-apr \
ac_cv_file__dev_zero=yes ac_cv_func_setpgrp_void=yes \
apr_cv_tcp_nodelay_with_cork=yes ac_cv_sizeof_struct_iovec=8 \
ap_cv_void_ptr_lt_long=4 apr_cv_process_shared_works=yes \
apr_cv_mutex_robust_shared=yes \
--with-pcre=`pwd`/../pcre-8.38/build \
--host=arm-linux \
cross_compiling=yes \
--with-mpm=prefork
make;
sudo make install
cd -

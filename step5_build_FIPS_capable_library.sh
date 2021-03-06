#---------------------------------------------------------
# build FIPS Capable library
#---------------------------------------------------------

# move to Source dir
cd Source

# make incore_macho available to build
export PATH="/usr/local/bin":$PATH

# delete old artifacts
rm -Rf openssl-1.0.2h/

# unpack fresh files
tar xzf openssl-1.0.2h.tar.gz 

# move to ssl' dir
cd openssl-1.0.2h/

# remove references to ERR_load_COMP_strings in err_all.c
sed  s/ERR_load_COMP_strings\(\)\;// <crypto/err/err_all.c >crypto/err/err_all.c.new
mv crypto/err/err_all.c.new crypto/err/err_all.c

# setup environment
. ../setenv-reset.sh
. ../setenv-ios-11.sh

# configure and make FIPS Capable library
./config fips -no-shared -no-comp -no-dso -no-hw -no-engines -no-sslv2 -no-sslv3 --with-fipsdir=/usr/local/ssl/Release-iphoneos
sed s/MAKEDEPPROG\=makedepend/MAKEDEPPROG\=\$\(CC\)\ -M/ <Makefile>Makefile.new
mv Makefile.new Makefile
make depend
make build_libs


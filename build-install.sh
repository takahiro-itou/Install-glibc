#!/bin/bash  -xue

current_srcfile=${BASH_SOURCE:-$0}
script_dir=$(readlink -f "$(dirname "${current_srcfile}")")

project_name='Sample'
source  "${script_dir}/config/common-config.rc"

umask  0022


##################################################################
##
##    1.  引数チェック
##

target_version=$1
install_base_dir=${2:-"${install_base_default}"}


##################################################################
##
##    2.  ファイルの確認とダウンロード
##

target_prefix=$(readlink -m "${install_base_dir}/Sample-${target_version}")
if "${target_prefix}/Bin/SampleApplication" --version ; then
    # インストール済みなので何もしない
    echo  "Already installed in ${target_prefix}"   1>&2
    sleep 5
    exit  0
fi

dlpinfo_file=$(mktemp dlpinfo.XXXXXXXX)
/bin/bash -xue "${script_dir}/download-package.sh" "${target_version}"  \
    | tee "${dlpinfo_file}"
eval $(cat "${dlpinfo_file}")
/usr/bin/rm -f "${dlpinfo_file}"


##################################################################
##
##    3.  ビルド環境の確認
##

pwd
echo "${CC:='gcc'}"
echo "${CXX:='g++'}"

which gcc
gcc --version
sleep 5


##################################################################
##
##    4.  対象ディレクトリにインストール
##

build_base_dir="${install_base_dir}/builds"

sample_configure_opts='--with-cppunit=no'

mkdir -p "${build_base_dir}"
pushd    "${build_base_dir}"

/usr/bin/rm -rf "Sample-${target_version}"
tar -xzf "${installer_file}"
cd "Sample-${target_version}"

./configure     \
    --prefix="${target_prefix}"     \
    ${sample_configure_opts}        \
    ;
make
make install

popd

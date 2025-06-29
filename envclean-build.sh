#!/bin/bash  -ue

current_srcfile=${BASH_SOURCE:-$0}
script_dir=$(readlink -f "$(dirname "${current_srcfile}")")

unset   LD_LIBRARY_PATH
unset   LIBRARY_PATH

_path=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin
_bash=${BASH}
_shell=${SHELL}
_term=${TERM}
_user=${USER}
_home=${HOME}

env  -i                 \
    PATH=${_path}       \
    BASH=${_bash}       \
    SHELL=${_shell}     \
    TERM=${_term}       \
    USER=${_user}       \
    HOME=${_home}       \
/bin/bash  -xue     \
    "${script_dir}/build-install.sh"  "$@"  \
    ||  exit  $?

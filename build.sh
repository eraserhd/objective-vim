#!/bin/bash

objvim_prefix=~/objvim

yaml_options=()
ruby_options=(
	--program-prefix=objvim_
	--enable-shared
	)
vim_options=(
	--with-features=huge
	--enable-rubyinterp=yes
	--with-ruby-command="${objvim_prefix}/bin/objvim_ruby"
	--enable-pythoninterp
	--with-python-config-dir=/usr/lib/python*/config
	--enable-tclinterp
	--with-tclsh=/usr/bin/tclsh
	--enable-perlinterp
	)

function set_up_environment() {
	export CFLAGS="-I${objvim_prefix}/include"
	export LDFLAGS="-L${objvim_prefix}/lib"
}

function unpack() {
	rm -rf "$1"*
	tar xzf src/"$1"*.tar.gz
}

function configure_and_make() {
	set_up_environment
	./configure --prefix=${objvim_prefix} "$@"
	make
	make install
}

function build() {
	local package=$1
	unpack $package
	pushd ${package}*
	eval "local options=\$${package}_options"
	configure_and_make "${options[@]}"
	popd
}

function symlink_vi() {
	( cd ${objvim_prefix}/bin && ln -sf vim vi )
}

function install_pathogen() {
	pathogen_url="https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim"
	curl -o ${objvim_prefix}/share/vim/vim73/autoload/pathogen.vim "$pathogen_url"
}

function build_all() {
	set -e

	rm -rf ${objvim_prefix}
	mkdir ${objvim_prefix}

	if command -v rvm >/dev/null 2>&1
	then
		rvm use system
	fi

	build yaml
	build ruby
	build vim
	symlink_vi
	install_pathogen
}

if [[ -z "$objvim_develop" ]]
then
	build_all
fi

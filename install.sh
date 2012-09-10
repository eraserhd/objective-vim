#!/bin/bash

objvim_prefix="/opt/objvim"
objvim_compiledby="Jason Felice <jason.m.felice@gmail.com>"

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
	shift
	unpack $package
	pushd ${package}*
	configure_and_make "$@"
	popd
}

function build_yaml() {
	build yaml
}

function build_ruby() {
	unpack ruby
	pushd ruby-*

	configure_and_make \
		--program-prefix=objvim_ \
		--enable-shared
	popd
}

function build_vim() {
	unpack vim
	pushd vim

	if command -v rvm >/dev/null 2>&1
	then
		rvm use system
	fi

	configure_and_make \
		--with-features=huge \
		--enable-rubyinterp=yes \
		--with-ruby-command="${objvim_prefix}/bin/objvim_ruby" \
		--enable-pythoninterp \
		--with-python-config-dir=/usr/lib/python*/config \
		--enable-tclinterp \
		--with-tclsh=/usr/bin/tclsh \
		--enable-perlinterp \
		--with-compiledby="${objvim_compiledby}"

	cd ${objvim_prefix}/bin
	ln -sf vim vi

	popd
}

function install_pathogen() {
	pathogen_url="https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim"
	curl -o ${objvim_prefix}/share/vim/vim73/autoload/pathogen.vim "$pathogen_url"
}

function build_all() {
	set -e

	rm -rf /opt/objvim
	mkdir /opt/objvim

	build_yaml
	build_ruby
	build_vim
	install_pathogen
}

if [[ -z "$objvim_develop" ]]
then
	build_all
fi

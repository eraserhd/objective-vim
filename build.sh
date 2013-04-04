#!/bin/bash

objective_vim_prefix=~/objective-vim
objective_vim_log=/tmp/objective-vim.log

vim_share_dir=${objective_vim_prefix}/share/vim
vimfiles_dir=${vim_share_dir}/vimfiles
autoload_dir=${vimfiles_dir}/autoload
vim_bundle_dir=${vimfiles_dir}/bundle
ruby_command="${objective_vim_prefix}/bin/objective-vim-ruby"

yaml_options=()
ruby_options=(
	--program-prefix=objective-vim-
	--enable-shared
	--disable-install-doc
	)
vim_options=(
	--with-features=huge
	--enable-rubyinterp=yes
	--with-ruby-command="${ruby_command}"
	--enable-pythoninterp
	--with-python-config-dir=/usr/lib/python*/config
	--enable-tclinterp
	--with-tclsh=/usr/bin/tclsh
	--enable-perlinterp
	)

function set_up_environment() {
	export CFLAGS="-I${objective_vim_prefix}/include"
	export LDFLAGS="-L${objective_vim_prefix}/lib"
}

function unpack() {
	rm -rf "$1"*
	if [[ -f "src/$1.tar.gz" ]]
	then
		tar xzf src/"$1".tar.gz || fail
	else
		tar xzf src/"$1"*.tar.gz || fail
	fi
}

function configure_and_make() {
	set_up_environment
	./configure --prefix=${objective_vim_prefix} "$@" >>$objective_vim_log 2>&1 || fail
	make >>$objective_vim_log 2>&1 || fail
	make install >>$objective_vim_log 2>&1 || fail
}

function build() {
	local package=$1
	printf 'Building %s... ' $package
	unpack $package
	builtin pushd ${package}* >/dev/null 2>&1 || fail
	eval "local options=( \${${package}_options[@]} )"
	echo "Using options: ${options[@]}" >>$objective_vim_log
	configure_and_make "${options[@]}"
	popd >/dev/null 2>&1
	printf 'OK\n'
}

function symlink_vi() {
	( cd ${objective_vim_prefix}/bin && ln -sf vim vi )
}

function install_pathogen() {
	printf 'Installing pathogen plugin... '
	mkdir -p "${autoload_dir}"
	cp src/pathogen.vim "${autoload_dir}" || fail
	printf 'OK\n'
}

function install_command_t() {
	install_bundle command-t
	printf 'Building CommandT native bits... '
	builtin pushd "${vim_bundle_dir}/command-t/ruby/command-t" >/dev/null 2>&1 || fail
	"$ruby_command" extconf.rb >>$objective_vim_log 2>&1 || fail
	make >>$objective_vim_log 2>&1 || fail
	popd >/dev/null 2>&1
	printf 'OK\n'
}

function install_bundle() {
	local bundle=$1
	printf 'Installing %s... ' "$bundle"
	mkdir -p "${vim_bundle_dir}"
	tar -xzf "src/${bundle}.tar.gz" -C "${vim_bundle_dir}" || fail
	printf 'OK\n'
}

function fail() {
	printf '\n\n'
	printf '  An error occurred while building stuff.  Please check %s for more details\n' "$objective_vim_log"
	printf '  and definitely create a github issue if you cannot figure it out.\n'
	printf '\n'
	trap - EXIT
	exit 1
}

function run_test() {
	${objective_vim_prefix}/bin/vim -u "${test}" -N
	return $?
}

function run_tests() {
	printf 'Running tests:\n'
	local return_code=0
	for test in test/*.vim; do
		printf '  %s... ' "$test"
		run_test "${test}" >/dev/null 2>&1
		if (( $? == 0 )); then
			printf 'OK\n'
		else
			printf 'FAILED\n'
			return_code=1
		fi
	done
	return $return_code
}

function use_system_ruby() {
	if [[ -f ~/.rvm/scripts/rvm ]]
	then
		source ~/.rvm/scripts/rvm
	fi
	if [[ "$(command -v rvm 2>&1)" = "rvm" ]]
	then
		rvm use system >>$objective_vim_log 2>&1
	fi
}

function build_tmux_MacOSX_pasteboard() {
	local package=tmux-MacOSX-pasteboard
	printf 'Building %s... ' $package
	unpack $package
	builtin pushd ${package}* >/dev/null 2>&1 || fail

	set_up_environment
	make >>$objective_vim_log 2>&1 || fail
	cp reattach-to-user-namespace "${objective_vim_prefix}/bin/" || fail

	popd >/dev/null 2>&1
	printf 'OK\n'
}

function update_helptags() {
	printf 'Generating help tags... '
	${objective_vim_prefix}/bin/vim -u update-helptags.vim -N >/dev/null 2>&1
	printf 'OK\n'
}

function build_all() {
	rm -rf ${objective_vim_prefix}
	mkdir ${objective_vim_prefix}

	use_system_ruby
	build yaml
	build ruby
	build vim
	symlink_vi
	build_tmux_MacOSX_pasteboard
	install_pathogen
	install_command_t
	install_bundle vim-ios
	install_bundle vimux
	install_bundle syntastic
	update_helptags

	run_tests
	printf '\n\n'
}

if [[ -z "$objective_vim_develop" ]]
then
	build_all
fi

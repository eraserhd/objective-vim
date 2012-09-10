
objvim_prefix="/opt/objvim"
objvim_compiledby="Jason Felice <jason.m.felice@gmail.com>"

function set_up_environment() {
	export CFLAGS="-I${objvim_prefix}/include"
	export LDFLAGS="-L${objvim_prefix}/lib"
}

function unpack() {
	rm -rf "$1"*
	tar xzf src/"$1"*.tar.gz
	cd "$1"*
}

function build_yaml() {
	unpack yaml
	./configure --prefix=${objvim_prefix}
	make
	make install
}

function build_ruby() {
	unpack ruby
	set_up_environment
	./configure \
		--program-prefix=objvim_ \
		--prefix=${objvim_prefix} \
		--enable-shared
	make
	make install
}

function build_vim() {
	unpack vim

	if command -v rvm >/dev/null 2>&1
	then
		rvm use system
	fi

	./configure \
		--prefix="${objvim_prefix}" \
		--with-features=huge \
		--enable-rubyinterp=yes \
		--with-ruby-command="${objvim_prefix}/bin/objvim_ruby" \
		--enable-pythoninterp \
		--with-python-config-dir=/usr/lib/python*/config \
		--enable-tclinterp \
		--with-tclsh=/usr/bin/tclsh \
		--enable-perlinterp \
		--with-compiledby="${objvim_compiledby}"
	make
	make install

	cd ${objvim_prefix}/bin
	ln -sf vim vi
}


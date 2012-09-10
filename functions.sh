
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



objvim_prefix="/opt/objvim"
objvim_compiledby="Jason Felice <jason.m.felice@gmail.com>"

function unpack() {
	rm -rf "$1"*
	tar xzf src/"$1"*.tar.gz
	cd "$1"*
}

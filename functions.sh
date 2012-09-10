
function unpack() {
	rm -rf "$1"*
	tar xzf src/"$1"*.tar.gz
	cd "$1"*
}

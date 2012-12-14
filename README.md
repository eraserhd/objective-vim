Objective Vim
=============

Scripts for building a nice console Vim for Mac OS X with support for iOS
development.

To install, simply copy the following line and paste into your terminal:

``` bash
curl https://raw.github.com/eraserhd/objective-vim/master/install.sh |sh
```

When done, you should have a fully configured vim.  Be sure to put the
following in your .bash_profile to use it instead of the system vim:

``` bash
export PATH=~/objective-vim/bin:"$PATH"
```

What It Has
===========

It has the following features:

 * Ruby scripting support (using 1.9.3)
 * Python scripting support (using system python)

It includes the following plugins:

 * CommandT
 * clang\_complete
 * ios.vim
 * kiwi.vim
 
It also installs [reattach-to-user-namespace] which can be used
within [tmux] to restore the functioning of pbcopy, pbpaste, and Vim's
`"+` register.

[reattach-to-user-namespace]: https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard
[tmux]: http://tmux.sourceforge.net/


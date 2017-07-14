# For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000


# Use if Zsh is preferred & chsh is not allowed
#echo "Entering zsh(tty) mode"
#tty -s && exec zsh

# CC options
export CC="ccache gcc"
export CXX="ccache g++"

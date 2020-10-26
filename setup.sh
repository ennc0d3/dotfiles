#!/bin/bash
#
# Installation of my development environment on Ubuntu Host
# Author: ennc0d3
#
# Styleguide: https://google.github.io/styleguide/shellguide.html
# Reference: https://developer.apple.com/library/archive/documentation/OpenSource/Conceptual/ShellScripting/shell_scripts/shell_scripts.htm

# Exit on error. Append "|| true" if you expect an error.
set -o errexit
# Exit on error inside any functions or subshells.
set -o errtrace
# Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
set -o nounset
# Catch the error in case mysqldump fails (but gzip succeeds) in `mysqldump |gzip`
set -o pipefail
# Turn on traces, useful while debugging but commented out by default
# set -o xtrace



# Set trap

trap handle_exit SIGINT SIGTERM SIGQUIT SIGABRT SIGHUP
trap cleanup EXIT

DEBUG=0

# Install variables
declare -r github_tmux_plugin_loc=https://github.com/tmux-plugins/tpm
declare -r tmux_plugin_root=~/.tmux/plugins

declare -r oh_my_zsh_installer=https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh


declare -r SUCCESS=0
declare -r FILE_NOT_FOUND=240
declare -r DOWNLOAD_FAILED=241

# FUNCTIONS


info() {
  echo -e "INFO: $*"
}

error() {
  echo -e "ERROR: $*" >&2
}

debug() {
 if (( DEBUG > 0 )); then
    echo -e "DEBUG: $*"
 fi
}

error_exit() {
 line=$1
 shift 1
 echo “ERROR: non zero return code from line: $line — $@”
 exit 1
}

handle_exit() {
  info "Handling exit"
  trap - SIGINT SIGTERM SIGQUIT SIGABRT SIGHUP

}
cleanup() {
  info "Handling exit"
  trap - EXIT

}


install() {
 info "Installing tools"
 
}




clean_previous_installation() {
	info "Cleaning previous installation"
	declare -r dot_dir=${HOME}
	for dotfile in $(find . -name '*.dot' ); do
		basename=${dotfile##*/}
		filename=${basename%%.dot}
		fullpath=${dot_dir}/.${filename}
		if [[ -e ${fullpath} ]]; then
		mv  -f ${fullpath} ${fullpath}.last
	fi
	done
}


clone_or_pull() {
	local remote_repo=$1
	local local_repo=$2
	if [ ! -d $local_repo/.git ]; then
		git clone ${remote_repo} ${local_repo}
	else
		cd $local_repo
		git pull $remote_repo
	fi
}

install_terminal_settings() {
    THEMES=(zenburn\
	    gruvbox \
	    gruvbox-dark \
	    google-light \
	    google-dark \
	    freya \
	    wombat \
	    solarized-light \
	    solarized-dark \
	    solarized-dark-higher-contrast
    	    papercolor-light \
    	    papercolor-dark \
	    one-light \
	    one-dark \
	    monokai-dark \
	    monokai-soda
	    )
    sudo apt-get upgrade -y dconf-cli uuid-runtime
    # clone the repo into "$HOME/src/gogh"
    local gogh_dir
    local git_dir
    git_dir=${HOME}/git
    mkdir -p $git_dir
    cd $git_dir
    gogh_dir=${git_dir}/gogh
    if [[ -e $gogh_dir ]]; then
	cd $gogh_dir
	git pull
    else
    	git clone https://github.com/Mayccoll/Gogh.git gogh
    fi
    # necessary on ubuntu
    export TERMINAL=gnome-terminal

    for theme in "${THEMES[@]}"; do
	    info "installing ${theme}"
	    if [[ -e ${gogh_dir}/themes/${theme}.sh ]]; then
	    	${gogh_dir}/themes/${theme}.sh
    fi
    done

}

# Install Parameters
install_vim_plugins() {
	info "Install plug"
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

	sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'


	info "Install the vim plugins"
	vim +PluginInstall +qall
}

install_oh_my_zsh() {
	info "Install oh-my-zsh"
	if [[ ! -e  ~/.oh-my-zsh ]]; then
		sh -c "$(curl -fsSL $oh_my_zsh_installer)" "" --unattended
	else
		info "Updating oh-my-zsh TODO"
		#omz update
	fi
	info "Install the zsh plugins"
	##git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
	##git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
	clone_or_pull https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
	clone_or_pull https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
	clone_or_pull https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
	clone_or_pull https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search

	info "Install the zsh custom spaceship themes"
	clone_or_pull https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
	ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme" 
}

install_tmux() {
	info "Install tmux plugin manager(TPM)"
	mkdir -p $tmux_plugin_root
	git clone $github_tmux_plugin_loc $tmux_plugin_root/tpm

	# Now install the tmux plugins from .tmux.conf
	$tmux_plugin_root/tpm/bin/install_plugins
}

create_symlinks() {
	info "Symlink dotfiles"
	package_root=$(readlink --canonicalize ${0%/*})
	for f in $(ls -1 $package_root/*.dot); do
		target_f=${f##*/}
		target_f=${target_f%%.dot}
		ln -s $f ~/.${target_f} > /dev/null 2>&1
	done
}


main() {
  info "main"
  #clean_previous_installation
  #create_symlinks
  #install_vim_plugins
  install_oh_my_zsh
  #install_tmux
  #install_terminal_settings
}

main "$@"



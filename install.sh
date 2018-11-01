#!/bin/sh

info() {
	echo "INFO: $@"
}


clone_or_pull() {
	remote_repo=$1
	local_repo=$2
	if [ ! -d $local_repo/.git ]; then
		git clone ${remote_repo} ${local_repo}
	else
		cd $local_repo
		git pull $remote_repo
	fi
}

get_terminal_setting() {
    wget https://raw.githubusercontent.com/denysdovhan/gnome-terminal-one/master/one-dark.sh  -o /tmp/one-dark.sh
    wget https://raw.githubusercontent.com/denysdovhan/gnome-terminal-one/master/one-light.sh  -o /tmp/one-light.sh
}

# Install Parameters
github_vundle_loc=https://github.com/VundleVim/Vundle.vim.git
vim_bundle_root=~/.vim/bundle

github_tmux_plugin_loc=https://github.com/tmux-plugins/tpm
tmux_plugin_root=~/.tmux/plugins

oh_my_zsh_installer=https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh


info "Symlink dotfiles"
package_root=$(readlink --canonicalize ${0%/*})
for f in $(ls -1 $package_root/*.dot); do
	target_f=$(basename $f)
	target_f=${target_f%%.dot}
	ln -s $f ~/.${target_f} > /dev/null 2>&1
done


info "Install vundle"
clone_or_pull $github_vundle_loc $vim_bundle_root/Vundle.vim


info "Install the vim plugins"
vim +PluginInstall +qall


info "Install oh-my-zsh"
sh -c "$(curl -fsSL $oh_my_zsh_installer)"


info "Install tmux plugin manager(TPM)"
mkdir -p $tmux_plugin_root
git clone $github_tmux_plugin_loc $tmux_plugin_root/tpm

# Now install the tmux plugins from .tmux.conf
$tmux_plugin_root/tpm/bin/install_plugins


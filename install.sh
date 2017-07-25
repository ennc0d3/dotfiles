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

# Install Parameters
github_vundle_loc=https://github.com/VundleVim/Vundle.vim.git
vim_bundle_root=~/.vim/bundle

github_tmux_plugin=https://github.com/tmux-plugins/tpm
tmux_plugin_root=~/.tmux/plugin

oh_my_zsh_installer=https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh


info "Symlink dotfiles"
package_root=$(dirname $0)
for f in $package_dotfiles; do
	ln -s $package_root/$f ~/.${f} >& /dev/null
done


info "Install vundle"
clone_or_pull $github_vundle_loc $vim_bundle_root/vundle


info "Install the vim plugins"
vim +PluginInstall +qall


info "Install oh-my-zsh"
sh -c "$(curl -fsSL $oh_my_zsh_installer)"


info "Install tmux plugin manager(TPM)"
mkdir -p $tmux_plugin_root
git clone $github_tmux_plugin_local $tmux_plugin_root/tpm
# Now install the tmux plugins from .tmux.conf
~/.tmux/plugins/tpm/bin/install_plugins


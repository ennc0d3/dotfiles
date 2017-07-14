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

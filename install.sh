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



# TODOs:
# * Is there a vim shortcut to add copyright, header text probably yes 
# * Shell lint checker according to the style guide

#
# Actions:
# * Remap Caps -> Control
# CAPs -> ESC 
# git


# time source "${filepath}" "${args}">> "${LOG_DIR}/RUN_LOG" 2>&1
#tac "${LOG_DIR}/RUN_LOG.txt" | grep -m1 "real"

# GLOBALS

DEBUG=0



declare -r SUCCESS=0
declare -r FILE_NOT_FOUND=240
declare -r DOWNLOAD_FAILED=241

declare -a INSTALL_TOOLS
INSTALL_TOOLS=(
	git 
	vim 
	neovim 
	zsh 
	tmux 
	virtualbox 
	build-essential 
	apt-transport-https 
	ca-certificates 
	docker-ce 
	docker-ce-cli 
	containerd.io 
	shellcheck
)

# For adding terminal profiles, gogh
INSTALL_TOOLS+=(
	dconf-cli
	uuid-runtime
)

# ZSH, OMZ
INSTALL_TOOLS+=(
	zsh 
	powerline 
	fonts-powerline	
)


readonly INSTALL_TOOLS

# VERSIONS
declare -r  VAGRANT_VERSION=2.2.10
declare -r HELM_VERSION=3.2.4
declare -r KUBERNETES_VERSION=1.17.3

# SCRIPT GLOVALS
declare -r DOWNLOAD_DIR=/tmp/download-debs/

declare -a BINARY_PACKAGES
BINARY_PACKAGES=(https://releases.hashicorp.com/vagrant/${VAGRANT_VERSION}/vagrant_${VAGRANT_VERSION}_x86_64.deb \
https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
)
readonly BINARY_PACKAGES


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

add_gpg_keys() {
 mkdir -p $DOWNLOAD_DIR/gpg
 curl -fsSL https://download.docker.com/linux/ubuntu/gpg  -o $DOWNLOAD_DIR/gpg/docker.gpg 
 sudo apt-key add $DOWNLOAD_DIR/gpg/docker.gpg
 sudo sh -c 'echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list '
 sudo apt-get update
}


install() {
 info "Installing tools"
 sudo apt-get update -y
 echo "Installation of following tools: ${INSTALL_TOOLS[@]}"
 sudo apt-get upgrade -y "${INSTALL_TOOLS[@]}"
 
}

download_binaries() {
 local download
 local max_per_wget=10
 download=$1
 if [[ -z $download ]]; then
   error "Download directory notset"
   exit
 fi
 mkdir -p $download
 info "Downloading tools"
 echo "Installation of following tools: ${BINARY_PACKAGES[@]}"
 for (( i = 0; i < ${#BINARY_PACKAGES[@]}; i += $max_per_wget)) ; do
   cd $download
   wget -N "${BINARY_PACKAGES[@]:$i:$max_per_wget}" -a $download/logs  
 done
}



install_binaries() {
 local download
 download=$1
 if [[ -z $download ||  ! -e $download ]]; then
   error "Download directory doesnot exist"
   exit
 fi

 info "instaling binaries in $download"
 info "Installation of following binaries:" "$(ls $download/*.deb)"
 for deb in $(ls $download/*.deb); do
	info "Installing $deb"
 	sudo apt upgrade -y "$deb"
 done
}

install_prebuilts() {
	PREBUILTS=("https://storage.googleapis.com/kubernetes-release/release/v${KUBERNETES_VERSION}/bin/linux/amd64/kubectl" 
		    )

	mkdir -p $DOWNLOAD_DIR/prebuilts
	max_per_wget=10

	info "installing prebults: ${PREBUILTS[@]}"
	info "|TODO|"
	return
	 for (( i = 0; i < ${#PREBUILTS[@]}; i += $max_per_wget)) ; do
	   cd $DOWNLOAD_DIR/prebuilts
	   info "Doqloading "
	   wget -N "${PREBUILTS[@]:i:$max_per_wget}" -a $DOWNLOAD_DIR/logs  
	 done

	 for tar in $(ls $DOWNLOAD_DIR/prebuilts/*.gz); do
            info "Untarring"
	   cd $DOWNLOAD_DIR/prebuilts/
  	    tar -zvxf $tar
	 done

	 for binary in $(ls $DOWNLOAD_DIR/prebuilts/*); do
		 if is_executable $binary ; then
 	 	 	info "Insall me $binary"
			chmod +x $binary
			sudo mv $binary /usr/local/bin/
		fi
	 done
}

install_helm() {
	set -x
       mkdir -p $DOWNLOAD_DIR/tars
       cd $DOWNLOAD_DIR/tars
       wget -N  "https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz"  -a $DOWNLOAD_DIR/logs
       tar -zxvf helm-v${HELM_VERSION}-linux-amd64.tar.gz 
       sudo mv linux-amd64/helm /usr/local/bin/helm
}

is_executable() {
	filename=$1
	pattern="LSB executable"
	file $filename | grep "$pattern" || true
	return $?
}

add_permissions() {
	info "Adding permissions"
	sudo usermod -aG docker vagrant
}


main() {
  info "main"
  install_helm
  exit
  add_gpg_keys
  install
  download_binaries $DOWNLOAD_DIR
  install_binaries $DOWNLOAD_DIR
  install_prebuilts
  add_permissions
}

main "$@"

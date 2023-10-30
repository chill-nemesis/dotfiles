# load helper functions
source term/helpers.rc


DF_ROOT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DF_INSTALL_CACHE_DIR=$DF_ROOT_DIR/.cache/install

# A list of files that need to be moved for install
DF_FILES_TO_MOVE=".bashrc .zshrc .vimrc .tmux.conf .gitconfig"


if is_windows; then
	echo "To install, you need to run the shell as an administrator!"
	while true; do
		read -p "Do you want to continue? [Y/n] " yn

		case $yn in
			[Yy]* ) break;; # everything after this loop will perform the install
			[Nn]* ) unset yn && exit;; # dont execute any further
			"" ) break;; # use default answer, that is yes!
			* ) ;; # we could not parse the input, try again
		esac
	done
	unset yn
fi

#
# -----------
# 

# Create the install backup dir if it does not exist
mkdir -p $DF_INSTALL_CACHE_DIR

# Check if we are running this from an already installed version of dotfiles
if [ -f $DF_INSTALL_CACHE_DIR/.installed ]; then
	echo ".Dotfiles is already installed! Aborting installation attempt."
	exit 0
fi

# mark as installed
touch $DF_INSTALL_CACHE_DIR/.installed

# Move old term/config files to cache
for file in $DF_FILES_TO_MOVE; do
	target=$DF_ROOT_DIR/$file
	link=~/$file

	mv ~/$file $DF_INSTALL_CACHE_DIR/$file 2>/dev/null

	if [ is_windows ]; then
		target=$(convert_path_to_windows ${target})
		link=$(convert_path_to_windows ${link})

		cmd <<< "mklink \"${link}\" \"${target}\"" > /dev/null
	else
		ln -s ${target} ${link}
	fi
done


echo "Almost done. Restarting shell to finish installation..."

exec "$SHELL"




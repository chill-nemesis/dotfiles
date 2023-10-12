DF_ROOT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DF_INSTALL_CACHE_DIR=$DF_ROOT_DIR/.cache/install

# A list of files that need to be moved for install
DF_FILES_TO_MOVE=".bashrc .zshrc .vimrc .tmux.conf .gitconfig"

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
	# echo "mv ~/$file $DF_INSTALL_CACHE_DIR/$file"
	# echo "ln -s $DF_ROOT_DIR/$file ~/$file"
	mv ~/$file $DF_INSTALL_CACHE_DIR/$file 2>/dev/null
	ln -s $DF_ROOT_DIR/$file ~/$file
done


echo "Almost done. Restarting shell to finish installation..."

exec "$SHELL"

unset DF_ROOT_DIR DF_INSTALL_CACHE_DIR DF_FILES_TO_MOVE




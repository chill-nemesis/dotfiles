function convert_to_windows ()
{
	local path=$1

	# Check if we have an absolute path
	if [[ $path == /* ]]; then
		drive_letter=$(echo "$path" | cut -d '/' -f 2)
		path_without_drive=$(echo "$path" | sed 's|/||' | cut -c2-)
		echo "${drive_letter}:${path_without_drive//\//\\}"
	else
		# relative, so no drive letter extraction
		echo "${path//\//\\}"
	fi
}



DF_ROOT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DF_INSTALL_CACHE_DIR=$DF_ROOT_DIR/.cache/install

# A list of files that need to be moved for install
DF_FILES_TO_MOVE=".bashrc .zshrc .vimrc .tmux.conf .gitconfig"

# check if we are running on a windows machine
# https://stackoverflow.com/questions/3466166/how-to-check-if-running-in-cygwin-mac-or-linux
system_name="$(uname -s)"
is_windows=false
case "${unameOut}" in
    CYGWIN*)    is_windows=true;;
    MINGW*)     is_windows=true;;
    MSYS_NT*)   is_windows=true;;
    *)          ;; # e.g. linux, darwin, or any other system -> Assume we work as linux
esac

if [ is_windows ]; then
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
		target=$(convert_to_windows ${target})
		link=$(convert_to_windows ${link})

		cmd <<< "mklink \"${link}\" \"${target}\"" > /dev/null
	else
		ln -s ${target} ${link}
	fi
done


echo "Almost done. Restarting shell to finish installation..."

exec "$SHELL"

unset DF_ROOT_DIR DF_INSTALL_CACHE_DIR DF_FILES_TO_MOVE




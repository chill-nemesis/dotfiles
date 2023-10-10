
# set the default prompt output
# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# enable programmable completion features
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# add ble.sh
# https://github.com/akinomyoga/ble.sh
TC_BLE_SOURCE_DIR=$TC_MODULES_DIR/ble
TC_BLE_SCRIPT=$TC_BLE_SOURCE_DIR/out/ble.sh
if [[ ! -f $TC_BLE_SCRIPT ]]; then
    DebugMessage "ble.sh not found!"
    # Check if the submodule is initialized
    # We can do that by checking if the status of the submodule begins with a dash --> Not initialized
    TC_BLE_SUBMODULE_STATUS=$(cd $TC_MODULES_DIR && git submodule status)
    if [[ $TC_BLE_SUBMODULE_STATUS == -* ]]; then
        DebugMessage "Could not find ble submodule. Running git submodule update --init --recursive."
        (cd $TC_MODULES_DIR && git submodule update --init --recursive)
    fi

    unset TC_BLE_SUBMODULE_STATUS

    DebugMessage "Building ble.sh"
    make -C $TC_BLE_SOURCE_DIR install
fi

DebugMessage "Sourcing ble.sh"
source $TC_BLE_SCRIPT

unset TC_BLE_SOURCE_DIR TC_BLE_SCRIPT


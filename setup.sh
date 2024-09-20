ARCH=0
DEBIAN=0

function error() {
  echo "Error: $1" >&2
  exit 1
}

function os_type {
    # check file system
    if [ -d /etc/pacman.d ]; then
        ARCH=1
        return 0
    fi

    # check package manager
    if command -v apt-get &> /dev/null; then
        DEBIAN=1
        return 0
    fi

    # check /etc/os-release
    if [ -f /etc/os-release ]; then
      OS=$(grep -i "ID=" /etc/os-release | cut -d= -f2)
      if [[ $OS == "debian" || $OS == "ubuntu" ]]; then
        DEBIAN=1
      elif [[ $OS == "arch" ]]; then
        ARCH=1
      else
        error "Unable to determine distribution."
      fi
      return 0  
    fi

    error "Unable to determine distribution."
    return 1
}

os_type # Get OS type

if [ $ARCH = 1 ]; then
    echo "Arch Linux or derivated detected"
    source ./arch.sh
    install_arch
else if [ $DEBIAN = 1 ]; then
    echo "Debian or derivated detected"
    source ./ubuntu.sh
    install_ubuntu
else
    error "Unsupported OS"
fi
fi
ARCH=0
DEBIAN=0

function os_type {
    case `uname` in
    Linux )
        LINUX=1
        which apt && { DEBIAN=1; return; }  # Debian and derivated
        which pacman && { ARCH=1; return; } # Arch and derivated
        ;;
    Darwin )
        DARWIN=1
        ;;
    * )
        ;;
    esac
}

os_type # Get OS type

if [ $ARCH = 1 ]
then
echo "Arch Linux or derivated detected"
source ./arch.sh
install_arch
else if [ $DEBIAN = 1 ]
then
echo "Debian or derivated detected"
source ./ubuntu.sh
install_ubuntu
else
echo "Unsupported OS"
fi
fi


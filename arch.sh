function error() {
  echo "Error: $1" >&2
  exit 1
}

function add_repos() {
    echo "Installing blackarch repo..."
    curl -O https://blackarch.org/strap.sh
    if [[ `echo 26849980b35a42e6e192c6d9ed8c46f0d6d06047 strap.sh | sha1sum -c` == *"OK"* ]]; then
        echo "strap.sh OK"
        bash strap.sh
    else
        error "failed strap.sh checksum"
    fi
}

function find_aur_helper() {
    helpers=("yay" "paru" "pamac" "pikaur" "aurutils" "trizen")

    for helper in "${helpers[@]}"; do
        if command -v "$helper" &> /dev/null; then
            echo "$helper"
            return 0
        fi
    done

    # if no helper
    error "No AUR helper found." >&2
}

function update_all_packages() {
    helper=$(find_aur_helper)

    if [ "$helper" != "No AUR helper found." ]; then 
        $helper -Syu
        return 0
    else
        error "Error: AUR helper not found. Please install one."
    fi
}

function install_packages() {
    helper=$(find_aur_helper)

    if [ "$helper" != "No AUR helper found." ]; then 
        $helper -S --needed - < kalitools.txt
    else
        error "AUR helper not found. Please install one."
    fi
}

function install_arch() {
    echo -n "Do you have blackarch repository ? [y/N]: "
    read ANS

    case $ANS in
      [Yy]* )
        # Yes option
        ;;
      * )
        add_repos
        update_all_packages
        # No option
        ;;
    esac

    echo -n "Do you install kali tools ? [Y/n]: "
    read ANS

    case $ANS in
      "" | [Yy]* )
        # Yes option
        install_packages
        echo "routersploit find in /(scriptlocation)/routerspoit, to run it write python3 rsf.py"
        ;;
      * )
        # No option
        ;;
    esac
}

#!/bin/sh

BASE_DIR=$(cd $(dirname "$0")/../ && pwd)

####################
#     Dotfiles     #
####################

echo "step 1/5: creating symbolic links to dotfiles ..."

dotfiles=$(ls ${BASE_DIR}/dotfiles)
for dotfile in ${dotfiles}
do
    unlink ${HOME}/.${dotfile}
    ln -s ${BASE_DIR}/dotfiles/${dotfile} ${HOME}/.${dotfile}
done

echo "symbolic links created!"


########################################
#     Command line tools for Xcode     #
########################################

echo "step 2/5: installing command line tools ..."

sudo rm -rf /Library/Developer/CommandLineTools
xcode-select --install

echo "command line tools installed!"

####################
#     Homebrew     #
####################

echo "step 3/5: installing homebrew ..."
which brew 2>/dev/null || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
sudo mkdir -p /usr/local/Frameworks
sudo chown -R $(whoami):admin /usr/local/Frameworks

echo "run brew doctor ..."
which brew 2>/dev/null && brew doctor

echo "run brew update ..."

git -C /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core fetch
git -C /usr/local/Homebrew/Library/Taps/homebrew/homebrew-cask fetch

which brew 2>/dev/null && brew update

echo "run brew upgrade..."
which brew 2>/dev/null && brew upgrade

echo "run brew install formulas ..."

sudo  mkdir -p /usr/local/sbin
sudo chown -R $(whoami):admin /usr/local/sbin

while read formula
do
    brew install ${formula} && brew upgrade ${formula} && brew link ${formula}
done < ${BASE_DIR}/apps/homebrew_formulas.txt

echo "run brew install casks ...."

while read cask
do
     brew install --cask ${cask}
done < ${BASE_DIR}/apps/homebrew_casks.txt

brew cleanup

echo "brew installed!"


######################
#    Python Pip3     #
######################

echo "step 4/5: installing pip3 ..."

echo "run pip3 install ..."

while read package
do
    pip3 install ${package}
done < ${BASE_DIR}/apps/pip3_packages.txt

echo "pip3 installed!"


#############################
#     Apps in App Store     #
#############################

echo "step 5/5: installing apps in App Store ..."

echo "run mas install app ..."

while read app
do
    mas install ${app}
done < ${BASE_DIR}/apps/appstore_apps.txt

echo "apps in App Store installed!"

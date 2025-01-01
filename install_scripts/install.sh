#!/bin/zsh -e

BASE_DIR=$(cd $(dirname "$0")/../ && pwd)

##################
#     Prezto     #
##################

echo "installing prezto ..."

git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
 
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
    ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done
cat .zshrc >> ${ZDOTDIR:-$HOME}/.zshrc

echo "prezto installed!"

####################
#     Dotfiles     #
####################

echo "creating symbolic links to dotfiles ..."

dotfiles=$(ls ${BASE_DIR}/dotfiles)
for dotfile in ${dotfiles}
do
    unlink -f ${HOME}/.${dotfile}
    ln -s ${BASE_DIR}/dotfiles/${dotfile} ${HOME}/.${dotfile}
done

echo "symbolic links created!"

####################
#     Homebrew     #
####################

echo "installing homebrew ..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "brew doctor ..."
which brew 2>/dev/null && brew doctor

echo "brew update ..."
which brew 2>/dev/null && brew update

echo "brew upgrade..."
which brew 2>/dev/null && brew upgrade

echo "install homebrew formulas ...."
cat "${BASE_DIR}/apps/homebrew_formulas.txt" | xargs brew install

echo "install homebrew casks ...."
cat "${BASE_DIR}/apps/homebrew_casks.txt" | xargs brew install --cask

echo "brew cleanup ..."
brew cleanup

echo "brew installed!"

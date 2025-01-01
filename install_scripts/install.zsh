#!/bin/zsh

##################
#     Prezto     #
##################

echo "step 1/1: installing prezto ..."

git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
 
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
    ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done
cat .zshrc >> ${ZDOTDIR:-$HOME}/.zshrc

echo "prezto installed!"

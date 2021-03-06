#!/bin/sh

# oh my zsh
if [ ! -e ~/.oh-my-zsh ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "ohmyzsh exists! skipping...."
fi
ln -s -f ~/configs/.zshrc ~/.zshrc

# p10k
if [ ! -e ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
else
  echo "p10k exists! skipping...."
fi
ln -s -f ~/configs/.p10k.zsh ~/.p10k.zsh
#zsh highlighting
if [ ! -e ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi
#zsh autosuggestion
if [ ! -e ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi
# vim plug
if [ ! -f ~/.vim/autoload/plug.vim ]; then
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
else
  echo "vim plug exists! skipping...."
fi
# install vim plugins
ln -s -f ~/configs/.vimrc ~/.vimrc
ln -s -f ~/configs/.vim/plugin ~/.vim/plugin
vim -c "PlugInstall"

curl -sL install-node.now.sh/lts | bash
# symbol link everything
if [ -e ~/.vim/plugged/coc.nvim ]; then
  ln -s -f ~/configs/.vim/coc.vim ~/.vim/autoload/coc.vim
  ln -s -f ~/configs/.vim/coc-settings.json ~/.vim/coc-settings.json
fi

# setup tmux config
if [ ! -e ~/.tmux ]; then
  cd
  git clone https://github.com/gpakosz/.tmux.git
  ln -s -f .tmux/.tmux.conf
  cp .tmux/.tmux.conf.local .
  echo "set -g default-terminal \"xterm-256color\"" >> ~/.tmux.conf
fi
# setup pyenv
if [ ! -e ~/.pyenv ]; then
  git clone https://github.com/pyenv/pyenv.git ~/.pyenv
  cd ~/.pyenv && src/configure && make -C src
  if [ ! -e ~/bin ]; then
    mkdir bin
  fi
  ln -s ~/.pyenv/bin/pyenv ~/bin/pyenv
  echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zprofile
  echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zprofile
  echo 'eval "$(pyenv init --path)"' >> ~/.zprofile
  echo 'eval "$(pyenv init -)"' >> ~/.zshrc
fi



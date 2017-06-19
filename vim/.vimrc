
source ~/.vim/config/detection.vim                " Detect OS/GUI
source ~/.vim/config/general.vim                  " Top level vim configuration
source ~/.vim/config/plugins.vim                  " Load/Configure Plugins

" INITIAL IMPORTANT SETTINGS {{{
" ==========================
  set nocompatible                                  " Turn off vi compatibility
  filetype plugin indent on                         " Turn on the filetype management
  colorscheme molokai                               " Set the colour scheme
"}}}

source ~/.vim/config/gui.vim                      " GUI specific configuration
source ~/.vim/config/statusline.vim               " Status line tweaks
source ~/.vim/config/files.vim                    " File specific mappings/behaviours
source ~/.vim/config/mappings.vim                 " Miscellaneous shortcuts
source ~/.vim/config/folds.vim                    " Configuration around managing folds
source ~/.vim/config/navigation.vim               " Mappings for switching windows

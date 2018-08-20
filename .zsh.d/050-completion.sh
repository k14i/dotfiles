setopt auto_param_keys
setopt correct
#setopt correct_all
setopt list_packed
setopt list_types
setopt numeric_glob_sort

setopt auto_cd
setopt auto_pushd
setopt auto_resume
setopt equals
setopt extended_glob
setopt long_list_jobs
setopt magic_equal_subst
setopt print_eight_bit
setopt prompt_subst
unsetopt promptcr
setopt mark_dirs

autoload smart-insert-last-word
zle -N insert-last-word smart-insert-last-word

# zsh-completions =====================
fpath=(/usr/local/share/zsh-completions $fpath)
# =====================================


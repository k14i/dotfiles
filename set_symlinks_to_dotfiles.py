#!/usr/bin/env python3

import os

files_all = os.listdir('.')
files_exclude = ['.git', 'README.md', 'set_symlinks_to_dotfiles.py']
files = list(set(files_all) - set(files_exclude))

homedir = os.getenv("HOME")
files_homedir = os.listdir(homedir)

for file in files:
  target = homedir + "/" + file

  if file in files_homedir:
    file_to_remove = os.path.abspath(target)
    print("WARNING: {} is already in {}, so remove {}".format(file, homedir, file_to_remove))
    os.remove(file_to_remove)
  else:
    print("INFO: {} is NOT in {}".format(file, homedir))

  print("INFO: create symlink: source = {}, link_name = {}".format(os.path.abspath(file), target))
  os.symlink(os.path.abspath(file), target)

os.mkdir(homedir + "/.Trash")


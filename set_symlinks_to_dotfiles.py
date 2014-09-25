#!/usr/bin/env python

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
    print "WARNING: %s is already in %s, so remove %s" % (file, homedir, file_to_remove)
    os.remove(file_to_remove)
  else:
    print "INFO: %s is NOT in %s" % (file, homedir)

  print "INFO: create symlink: source = %s, link_name = %s" % (os.path.abspath(file), target)
  os.symlink(os.path.abspath(file), target)

os.mkdir(homedir + "/.Trash")

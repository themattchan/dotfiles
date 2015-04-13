#! /bin/python
#
# setup.py
# Setup dotfiles the modern way. Why bother with bash scripts?
# Use default libraries only to ensure compatibility on new systems
#
# Author:  Matthew Chan <matt@themattchan.com>
# Date:    January 2015
# License: GNU
#
import os, sys, shutil, subprocess
from os.path import isfile, isdir, islink, join

# ------------------------------------------------------------------------------
# Constants
# ------------------------------------------------------------------------------

EDITOR   = 'emacs'

IS_MAC   = sys.platform == 'darwin'
IS_LINUX = sys.platform == 'linux' or sys.platform == 'linux2'

HOME     = os.environ['HOME']   # /Users/matt
DOTFILES = os.getcwd()          # /Users/matt/dotfiles

SHELL      = '/bin/zsh'         # Use zsh
EDITOR_EXE = 'emacs -Q -nw'     # In case I need to edit something

VERBOSE  = True

# ------------------------------------------------------------------------------
# Utilities
# ------------------------------------------------------------------------------

class Cmd:
    VERBOSE = True
    def run(self,cmd):
        if self.VERBOSE:
            out = subprocess.STDOUT
        else:
            out = open(os.devnull, 'w')
#        print "RUN COMMAND: " + cmd
        subprocess.call(cmd,
                        shell=True,
                        executable=SHELL,
                        stdout=out,
                        stderr=subprocess.STDOUT)       # intermix errors

    def git(self,repo, action='clone', dst="", flags=""):
        gitcmd = 'git '+action+' '+flags+' '+repo+' '+dst
        return gitcmd

    def run_git(self,repo, action='clone', dst="", flags=""):
        self.run(git(repo,action,dst,flags))

    def run_seq(self,*cmds):
        # might end up with separate shell instances if we instead map over the list
        self.run("; ".join(cmds))

cmd = Cmd()
run_cmd = cmd.run               # backwards compatibility for now

class InvalidPath(Exception):
    def __init__(self, value): self.value = value
    def __str__ (self):        return "Error: invalid filepath "+self.value

# Always use FHIDE, makes it easier to see which files are being dotted.
def FHIDE(fname):
    if fname[0] != '.': return '.'+fname
    else:               return     fname

def FSHOW(fname):
    if fname[0] == '.': return fname[1:]
    else:               return fname

# Wrap print in a function so we can map it.
# Don't import from future because I like 2.7 print syntax for everything else.
def show(x): print x

# def let(ident, expr1, expr2):
#     return (lambda ident: expr2)(expr1)

#   do : [ (() -> ()) ] -> ()
def do(funs): map(apply, funs)  # takes a list of nullary functions

#   join_do : [[ (() -> ()) ]] -> ()
def join_do(more_funs): map(do, more_funs) # join_do(*funs) would be yet another type...

# predicates for filtering
def ALL(x): return True

def equal(obj): return (lambda x: x == obj)

def exists_path(path): return (isfile(path) or isdir(path) or islink(path))

def is_commented_line(string): return (string[0] == '#')

# Aside from the beginning period, dotfile names do not contain dots.
# dotfiles stored in DOTFILES do not begin with dots.
def is_dotfile(fname):
  #  print "IN ISDOTFILE"
    fname = fname.lower()
    included_files = ['emacs.d']
    excluded_files = ['readme']
    #assert set(included_files).intersection(set(excluded_files)) == set([])

    excluded_chars = set(['.', '#', '~'])
    fname_chars    = set(fname)

    x= (   (fname in included_files
            or  fname not in excluded_files)
            and fname_chars == fname_chars.difference(excluded_chars))
 #   print x
    return x

def delete(path):
    try:
        if   islink(path): os.unlink(path)     # leaves actual file untouched
        elif isfile(path): os.remove(path)     # calling this on link tries to remove actual file
        elif isdir(path) : shutil.rmtree(path) # roughly equiv to rm -rf
    except:  return

# PATHS DO NOT HAVE TRAILING SLASHES
#   link_one : basename abs_path abs_path -> ()
def link_one(fname, frompath=DOTFILES, topath=HOME):
    src = join(frompath, fname)
    dst = join(topath, FHIDE(fname))
    if exists_path(src):
        delete(dst)        # always try and delete existing symlinks/files first
        os.symlink(src,dst)
        if VERBOSE:
             print ("    link: %s -> %s" % (src,dst)) # I give up on aligning this shit
    else:
        raise InvalidPath(src)

# TODO abstract this into dir_map_one_level
# link everything inside a directory
#   link_dir : abs_path abs_path (basename -> bool) -> ()
def link_dir(frompath, topath=HOME, p=is_dotfile):
    print "linking "+frompath+" to " +topath
    print os.listdir(frompath)
    ffff = [f for f in os.listdir(frompath) if p(f)]   #filter(p, os.listdir(frompath))
    print ffff
    map(lambda fname: link_one(fname,frompath,topath), ffff)
    print "DONE LINKDIR"

# Tree-fold over the directory structure.
#   dir_fold : (a abs_path -> a) a abs_path -> a

# Tree-map over the directory structure.
# f has to test for dir/file
#   dir_map : (abs_path -> ()) abs_path -> ()
def dir_map(f, root):
    f(root)
    if not isdir(root): return
    else:
        subpaths = map(lambda fn: join(root,fn), os.listdir(root))
        map(lambda sp: dir_map(f,sp), subpaths)

# ------------------------------------------------------------------------------
# Specifics
# ------------------------------------------------------------------------------


# submodule file name   is '.submodules'
# submodule file syntax is '<id> <git_repo> <dir_name>', separated by whitespace
# comment out lines with '#' (space optional)
def install_submodules(path, p=ALL):
    def git_get(entry):
#    print "DOWNLOADING SUBMODULE: "+entry
        uid = entry[0]
        url = entry[1]
        todir = ""
        if len(entry)>2: todir = entry[2]
        print uid
        print url
        print todir
        if p(uid) and not is_commented_line(uid):
            # cd into dir because we can't be sure if there is a
            # specified name for the repo
            cmd = "cd %(cwd)s; git clone %(url)s %(todir)s" % {"cwd": path, "url": url, "todir": todir }

            run_cmd(cmd)
            #cmd.run_seq(cd,git)
    # better to filter on os.listdir(path)!!
    # there's got to  be a list.exists function...
    # but then again, isfile is good because it rules out wrong types...

    modlst = join(path, FHIDE("submodules"))
    #print modlst
    if isfile(modlst):
        #print "ISFILE"
        f = open(modlst, 'r')
        #print f
        try:
            modules = map(lambda l: l.split(), f.readlines())#[l.split() for l in f.readlines()]
            #print modules
            for e in modules:
#                print "get" +e
                git_get(e)
                #map(get, modules)
        except Exception as e:
            print e
        finally:
            f.close()

def recursively_install_submodules(root, p=ALL):
    dir_map(lambda path: install_submodules(path,p), root)

# list all submodules
# def

# copy old dotfiles to a directory ~/dotfiles_old
# def backup_dotfiles():

# get rid of all old symlinks of or actual dotfiles in HOME
# def clean_dotfiles():

# initialise a ~/dotfiles directory if not already
# def init_dotfiles(use_old=False):

# update all repos in this tree
# def update(root):
#     dir_map(update_fun,root)

# ------------------------------------------------------------------------------
# Link!
# ------------------------------------------------------------------------------
# If you have to map or filter here, you're doing it _wrong_.
# This is the Duplo layer of the code.
# Best if sequence doesn't matter.

# Github hosted config packages go in $HOME

def set_zsh(clean=True):
    # use zprezto
    zp_dir           = join(HOME, FHIDE("zprezto"))
    zp_default_confs = join(zp_dir, "runcoms")
    my_zsh_confs     = join(DOTFILES, "term")

    def reinstall_zp():
        print "(Re)installing zprezto...\t",
        #delete(zp_dir)
        run_cmd("git clone --recursive https://github.com/sorin-ionescu/prezto.git "
                +zp_dir)
        print "zprezto updated!"

   # if clean: reinstall_zp()

    print "Symlinking zprezto default config files..."
    link_dir(zp_default_confs)

    print "Symlinking my config files..."
    link_dir(my_zsh_confs)

    print "Done!"

def set_peda():
    print "Installing peda...\t",
    delete(join(HOME, FHIDE("peda")))
    run_cmd("git clone https://github.com/longld/peda.git ~/.peda")

    with open(join(HOME, FHIDE("gdbinit")),'w') as f:
        f.write("source ~/.peda/peda.py")

    print "Done!"

def set_osx():
    if IS_MAC:
        print "Running OS X setup script...\t",
        run_cmd(join(DOTFILES,"osx/osx"))
        print "Done!"

def set_linux():
    if IS_LINUX:
        print "Linking Linux configs...\t",
        link_dir(join(DOTFILES,"linux"))
        print "Done!"

def set_emacs():
    print "Emacs power...\t",
    if EDITOR == 'emacs':
    #    install_submodules(DOTFILES) # only top level submodule is emacs.d
        link_one("emacs.d")
    else:
        raise ValueError('vi user')
        print "... you don't have it.\n"
        print "It's dangerous to go alone. Take this"
        run_cmd("git clone https://gist.github.com/112f4a71294aec281fa9.git "+
                join(DOTFILES,"emacs.d"))
        set_emacs()
        print "Welcome to the Church of Emacs."
        return
    #recursively_install_submodules(join(DOTFILES,"emacs.d"))
    print "Engage!"

def set_ssh():
    print "Linking your ssh keys...\t",
    try: link_one("ssh")
    except:
        print "\n\tYou don't have your keys here.\nAborting."
        return
    print "Done!"

def set_vc():
    print "Linking version control settings...\t"
    try:
        link_dir(join(DOTFILES, "vc"))
    except:
       print "\n\tSettings not found."
       return
    print "Done!"

# def set_misc():

# def set_rest():

# ------------------------------------------------------------------------------
# Tests
# ------------------------------------------------------------------------------
#TEST dir_map(show, DOTFILES)

#TEST def foo(): print "foo"
#TEST do([foo for i in range(10)])
#TEST print join(DOTFILES,"emacs.d")
#TEST print join(DOTFILES,FHIDE("emacs.d"))

# ------------------------------------------------------------------------------
# Run
# ------------------------------------------------------------------------------

noninteractive_funs = [ set_peda ]

command_to_fun = { 'shell' : set_zsh
                 , 'ssh'   : set_ssh
                 , 'osx'   : set_osx
                 , 'linux' : set_linux
                 , 'emacs' : set_emacs
                 , 'vc'    : set_vc
                 }

def prompt():
    title = "Setup ~/dotfiles"
    print  (80 * '-')
    print ((80 - len(title))/2 * ' ') + title
    print  (80 * '-')

    print "all      Everything"
    print "list     List available commands/directories to setup"
    print "(cmd)    Run command"
    print "exit     Bye!"

def main(c=None):
    if c == None:
        try:    c = raw_input("\nEnter command: ")
        except: return          # get rid of nasty stacktrace on Ctrl-D

    if   c == 'all':
        join_do([ command_to_fun.values()
                , noninteractive_funs     ])

    elif c == 'list':
        print command_to_fun.keys()
        main()
    else:
        try:  command_to_fun.get(c)()
        except: return
        main()
    return

if __name__ == "__main__":
    if len(sys.argv) == 2 and sys.argv[1] == 'all':
        main(sys.argv[1])
    else:
        prompt()
        main()

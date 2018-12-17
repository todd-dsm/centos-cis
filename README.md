# centos-cis

This is an opinionated Packer build of the CentOS conformance to the CIS benchmark.

https://www.cisecurity.org/benchmark/red_hat_linux/

The build takes approximately 13 minutes.

## Prep
Fill out `env.sh` and ensure the locations in that file actually exist. After the build, this is where the artifacts will be. See the environment below for the extended club remix.

## Execute
`build-image.sh` is included as a wrapper to drag the project quickly through some not-so-obvious steps.

`./build-image.sh centos-75-cis.json`

And the job has 2 opportunities to fail before executing the most time-consuming step.

## TESTING
A vagrant box is output as a post-process. I'm not a big fan but it's a fast/cheap way to get eyes-on a result.

1) Install Vagrant
2) Install the VirtualBox plugin `vagrant plugin install vagrant-vbguest`
3) Add the box

Actually, `build-image.sh` will add the box for you but you can do it too:

`vagrant box add centos-cis  ~/vms/vagrant/boxes/path/to/image.box`

Login to the box:

`vagrant up && vagrant ssh`

The vagrant post-processor should be removed before jamming this into the pipeline.




## Results
Some artifacts are generated and left in `/tmp/centos`; this could easily be `/tmp/debian` `;-)` , etc.

## Prereqs
Create a dir structure for Packer to put stuff:
```
mkdir -p "$HOME/vms/packer/{builds,iso-cache}"
mkdir -p "$HOME/vms/vagrant/boxes"
mkdir -p "$HOME/vms/vbox"
```

## The Environment
Adjust ENV vars to taste:
```
###                                VirtualBox                               ###
export VBOX_USER_HOME="$HOME/vms/vbox"
###                                 Vagrant                                 ###
#export VAGRANT_LOG=debug
export VAGRANT_HOME="$HOME/vms/vagrant"
export VAGRANT_BOXES="$VAGRANT_HOME/boxes"
export VAGRANT_DEFAULT_PROVIDER='virtualbox'
###                                  Packer                                 ###
export PACKER_HOME="$HOME/vms/packer"
#export PACKER_CONFIG="$PACKER_HOME"
export PACKER_CACHE_DIR="$PACKER_HOME/iso-cache"
export PACKER_BUILD_DIR="$PACKER_HOME/builds"
export PACKER_LOG='yes'
export PACKER_LOG_PATH='/tmp/packer.log'
export PACKER_NO_COLOR='yes'
```


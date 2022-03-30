## What it is

A docker script to build AnnePro2_Tools (the binary to flash firmware into the AnnePro 2 keyboard) and my keymap and shine firmware for it.

## How to use

Run `docker build -t tgdnt/ap2:v1 .` to build the container. This will build AnnePro2_Tools, my layout and my shine firmware, and copy them to /home/dev

Then run `docker run --privileged -h ap2 --rm -it -v ${PWD}:/host --user $(id -u) -w /home/dev tgdnt/ap2:v1 bash`[^1] to get a terminal in the container, and copy the 3 files to /host, which will land them in the folder we ran docker from.

Connect the keyboard in IAP mode [^2], and run `./annepro2_tools annepro2_c18_tiago.bin` to flash the keymap and then `./annepro2_tools --boot -t led annepro2-shine-C18.bin` to flash the shine.

The second command should also make it boot.

Maintain my keymap source in https://github.com/tgdnt/annepro-qmk.git and docker pulls it from there to build.

[^1]: In short, this is supposed to give the container access to devices, though I'm not sure it's necessary, then set hostname to ap2, tells it to remove itself once it finishes, sets the present working directory to map to /host in the container, and start a bash session in there.

[^2]: To put keyboard in IAP mode, connect it to computer while holding down escape, or press RSHIFT+LSHIFT+B if your keyboard already has a qmk firmware installed.


## Credit

The original script was shared by @zinosat [here](https://openannepro.github.io/install_docker.html).

## Changelog

* Removed line that makes the container fetch packages from a mirror that wasn't working.
* Made it fetch annepro_qmk from my fork that only has my keymap and made it copy that binary file instead of the default one.

## To-do

* Right now, if I update my keymap source, I have to run `docker image prune -a` and then rebuild the container again. Would be nice to create a script here that can be available in the container to just re-run it, pull my keymap source and rebuild it.

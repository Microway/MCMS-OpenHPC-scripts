# Scripts for MCMS with OpenHPC

## This is an experimental work in progress - it is not ready for production

MCMS is Microway's Cluster Management Software. This is not the production-ready
version of MCMS. This is an ongoing project to bring Microway's expertise and
software tools to the recently-announced OpenHPC collaborative framework.

### Purpose
This collection of scripts is designed to simplify the day-to-day usage of an
HPC cluster built using the OpenHPC framework. Shortcuts are provided for common
tasks (e.g., user creation/deletion, querying nodes/partitions, etc.).

### Installation
These scripts are placed into the system paths. Scripts which are typically run
by administrators are kept separate from scripts intended from regular users
(i.e., user scripts are in `bin/` and admin scripts are in `sbin/`).

An RPM can be created by running the following from the current directory:
```
fpm -t rpm -s dir -a all --prefix=/usr                                   \
    --name mcms_openhpc_scripts -v **version**                           \
    --vendor Microway --license GPLv3                                    \
    --url https://github.com/Microway/mcms_openhpc_scripts               \
    --description 'Scripts to simplify usage of an OpenHPC cluster'      \
    bin/ libexec/ sbin/
```

A DEB can be created by replacing the `-t rpm` above with `-t deb`.

### More Information
If you would like to purchase professional support/services for an OpenHPC
cluster, or to fund development of a new feature, please visit:
https://www.microway.com/contact/

To learn more about OpenHPC, visit:
http://www.openhpc.community/


### Author & Credits
The `slurm` script is written and maintained by Janne Blomqvist of Aalto University


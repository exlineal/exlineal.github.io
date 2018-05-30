#!/bin/bash
cp b64 bld
cp exigen.sh bld
cp exlineal.sh bld
cp exremove.sh bld
cp scrypt bld
cp setup.sh bld
cp xxd bld
cp stub.sh bld
cp ../templates/temp_*.mo bld
chmod +rwx bld/*
makeself-2.4.0/makeself.sh --lsm exlineal.lsm --help-header help-header --complevel 9 --license ../LICENSE --nowait --follow --sha256 --needroot --xz ./bld exlineal.run Exlineal ./stub.sh

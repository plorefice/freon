#!/bin/bash

set -e

# cd to tree root
DIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P)

SRCDIR="src"
HDLDIR="${SRCDIR}/hdl"

OUTDIR="build"
SIMDIR="${OUTDIR}/sims"
BINDIR="${OUTDIR}/bin"

TESTDIR="tests"

# Make sure the build directories exist
mkdir -p $OUTDIR $SIMDIR $BINDIR

# Usage text
USAGE="$(basename "$0") [-h] [-cC] [core|all] -- build Freon and/or its test-suite

where
	-h, --help	show this help text
	-c, --cleanobj	clean the object files
	-C, --cleanall	clean everything"


function cleanobj() {
	ghdl --clean --workdir=$OUTDIR
	rm -f `find $OUTDIR -name "*.o"`
	rm -f `find $OUTDIR -name "*.cf"`
}

function cleanvcd() {
	rm -f `find $OUTDIR -name "*.vcd"`
}

function buildcore() {
	ghdl -i --workdir=$OUTDIR `find $HDLDIR -name "*.vhdl"`
	
	ENTS=( `grep -e "entity" "${OUTDIR}"/*.cf | cut -d' ' -f4` )
	for ent in "${ENTS[@]}"; do
		ghdl -m --workdir=$OUTDIR $ent
		rm -f e~"$ent".o
		mv $ent $BINDIR
	done
	
	BUILTCORE=1
}

function buildtests() {
	[ x"$BUILTCORE" == x"1" ] || buildcore
	ghdl -i --workdir=$OUTDIR `find $TESTDIR -name "*.vhdl"`

	A_ENTS=( `grep -e "entity" "${OUTDIR}"/*.cf | cut -d' ' -f4` )
	T_ENTS=( `echo ${ENTS[@]} ${A_ENTS[@]} | tr ' ' '\n' | sort | uniq -u` )
	for ent in "${T_ENTS[@]}"; do
		ghdl -m --workdir=$OUTDIR $ent
		ghdl -r --workdir=$OUTDIR $ent --vcd="${SIMDIR}/${ent}.vcd"
		rm -f e~"$ent".o
		mv $ent $BINDIR
	done
}

while [[ "$#" > 0 ]]; do
	key="$1"

	case $key in
		-c|--cleanobj)
		cleanobj
		exit
		;;
		-C|--cleanall)
		cleanobj
		cleanvcd
		exit
		;;
		core)
		buildcore
		;;
		all)
		buildcore
		buildtests
		;;
		*)
		echo "$USAGE"
		exit
		;;
	esac

	shift
done

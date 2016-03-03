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
	echo "Cleaning up object files.."
	ghdl --clean --workdir=$OUTDIR
	rm -f `find $OUTDIR -name "*.o"`
	rm -f `find $OUTDIR -name "*.cf"`
}

function cleanvcd() {
	echo "Cleaning up simulation data.."
	rm -f `find $OUTDIR -name "*.vcd"`
}

function buildcore() {
	echo "[CORE] Analyzing files.."
	ghdl -i --workdir=$OUTDIR `find $HDLDIR -name "*.vhdl"`
	
	echo "[CORE] Starting build.."
	ENTS=( `grep -e "entity" "${OUTDIR}"/*.cf | cut -d' ' -f4` )
	for ent in "${ENTS[@]}"; do
		echo "[CORE] Building ${ent}.."
		ghdl -m --workdir=$OUTDIR $ent
		[ -f e~"$ent".o ] && mv e~"$ent".o $BINDIR
		[ -f "$ent" ] && mv $ent $BINDIR
	done
	
	BUILTCORE=1
	echo "[CORE] Build successful!"
}

function buildtests() {
	[ x"$BUILTCORE" == x"1" ] || buildcore

	echo "[TEST] Analyzing files.."
	ghdl -i --workdir=$OUTDIR `find $TESTDIR -name "*.vhdl"`

	echo "[TEST] Starting build.."
	A_ENTS=( `grep -e "entity" "${OUTDIR}"/*.cf | cut -d' ' -f4` )
	T_ENTS=( `echo ${ENTS[@]} ${A_ENTS[@]} | tr ' ' '\n' | sort | uniq -u` )
	for ent in "${T_ENTS[@]}"; do
		echo "[TEST] Building ${ent}.."
		ghdl -m --workdir=$OUTDIR $ent
		echo "[TEST] Running ${ent}.."
		ghdl -r --workdir=$OUTDIR $ent --vcd="${SIMDIR}/${ent}.vcd"
		[ -f e~"$ent".o ] && mv e~"$ent".o $BINDIR
		[ -f "$ent" ] && mv $ent $BINDIR
	done

	echo "[TEST] Build successful!"
}

[[ "$#" -eq 0 ]] && echo "$USAGE" && exit

while [[ "$#" > 0 ]]; do
	key="$1"

	case $key in
		-c|--cleanobj)
		cleanobj
		;;
		-C|--cleanall)
		cleanobj
		cleanvcd
		;;
		core)
		cleanobj
		buildcore
		;;
		all)
		cleanobj
		buildcore
		buildtests
		;;
		*)
		echo "$USAGE"
		exit 1
		;;
	esac

	shift
done

echo "All done!"
exit 0


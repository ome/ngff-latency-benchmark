#!/usr/bin/env bash

DIR=${DIR:-/uod/idr-scratch/ngff-latency-benchmark/2021-02-09-quick}
CLEAN=${CLEAN:-"--rm"}

set -e
set -u
set -x

XY=64
Z=1
C=1
T=1
XC=8
ZC=8

IMS=IMS_XY-${XY}-Z-${Z}-T-${T}-C-${C}-XYC-${XC}-ZC-${ZC}.ims
ZARR=IMS_XY-${XY}-Z-${Z}-T-${T}-C-${C}-XYC-${XC}-ZC-${ZC}.ome.zarr
TIFF=IMS_XY-${XY}-Z-${Z}-T-${T}-C-${C}-XYC-${XC}-ZC-${ZC}.ome.tiff

BF2RAW=/tmp/bioformats2raw/build/install/bioformats2raw/bin/bioformats2raw
RAW2OMETIFF=/tmp/raw2ometiff/build/install/raw2ometiff/bin/raw2ometiff

docker-compose run ${CLEAN} -v $DIR:$DIR \
	generate $DIR \
	$XY $Z $C $T $XC $ZC

docker-compose run ${CLEAN} -v $DIR:$DIR \
	convert $BF2RAW --nested \
		$DIR/$IMS \
		$DIR/out \
	-w $XC -h $XC

docker-compose run ${CLEAN} -v $DIR:$DIR \
	convert $RAW2OMETIFF \
		$DIR/out \
		$DIR/$TIFF

docker-compose run ${CLEAN} -v $DIR:$DIR \
	convert mv \
		$DIR/out/data.zarr/0 \
		$DIR/$ZARR
#!/usr/bin/env bash

ABIGEN="$2"
OUTFILE="$3"
PKG="$4"

EXTERNAL_DIR=$(pwd -P | sed  "s,\(.*\)/sandbox/.*,\1/external/,g")
GO_ETHEREUM="$EXTERNAL_DIR/com_github_ethereum_go_ethereum/"
OUTDIR=$(dirname $OUTFILE)

#Create src/github.com/ethereum/ tree needed by goimports
mkdir -p $OUTDIR/src/github.com/ethereum/
ln -s $GO_ETHEREUM  $OUTDIR/src/github.com/ethereum/go-ethereum

#Generate abi file
solc --abi -o $OUTDIR $1

#GEnerate go files
ABIFILE=$OUTDIR/$(basename $OUTFILE go)abi
/usr/bin/env -i GOPATH=$OUTDIR/ $ABIGEN --abi $ABIFILE --pkg $PKG > $3

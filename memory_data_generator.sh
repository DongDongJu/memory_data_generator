#!/bin/bash
#$ -N DongDongJob
#$ -q drg,free64,pub64
#$ -pe openmp 4


source $HOME/.bashrc
source $HOME/.bash_profile

arch="ARM"
ARCH=$(echo $arch | tr 'a-z' 'A-Z')
GEM5_BUILD=gem5.opt

BENCHMARK=fft
BINARY=bin/$arch/fft
TIMESTAMP=$(date +%Y%m%dT%H%M%S)
OUT_DIR=$TRACES_DIR/$BENCHMARK/$TIMESTAMP
echo $OUT_DIR



###################replace it to export##########
GEM5PATH=/data/users/dongjos2/gem5
RUNNINGPATH=/pub/dongjos2/majid/majid_hpc_run/fft
MEM_PARSER_DIR=/pub/dongjos2/majid/majid_hpc_run/fft
################################################


RUN_SMALL_NORMAL="Y"
RUN_SMALL_INVERSE="Y"

echo "Running $BENCHMARK: gem5"
dt=$(date '+%d/%m/%Y %H:%M:%S');
echo "$dt"

if [ $RUN_SMALL_NORMAL == "Y" ]; then
$GEM5PATH/build/ARM/gem5.opt \
 --debug-flags=MemoryAccess \
 --debug-file=debug.log \
 -re \
 -d $RUNNINGPATH/small \
 $GEM5PATH/configs/example/se.py\
 --fastmem -c $RUNNINGPATH/fft \
 -o "-o $RUNNINGPATH/small/out.txt 4 16384"& 
fi


if [ $RUN_SMALL_INVERSE == "Y" ]; then
$GEM5PATH/build/ARM/gem5.opt \
 --debug-flags=MemoryAccess \
 --debug-file=debug.log \
 -re \
 -d $RUNNINGPATH/small_inv \
 $GEM5PATH/configs/example/se.py\
 --fastmem -c $RUNNINGPATH/fft \
 -o "-o $RUNNINGPATH/small_inv/out.txt 4 16384 -i"& 
fi
wait

module load python/2.7.10

echo "Running $BENCHMARK: memory_parser"
dt=$(date '+%d/%m/%Y %H:%M:%S');
echo "$dt"

if [ $RUN_SMALL_NORMAL == "Y" ]; then
pypy $MEM_PARSER_DIR/RWParser.py $RUNNINGPATH/small/debug.log $RUNNINGPATH/small/memory_data.txt&
fi

if [ $RUN_SMALL_INVERSE == "Y" ]; then
pypy $MEM_PARSER_DIR/RWParser.py $RUNNINGPATH/small_inv/debug.log $RUNNINGPATH/small_inv/memory_data.txt&
fi
wait

echo "Done!"
dt=$(date '+%d/%m/%Y %H:%M:%S');
echo "$dt"

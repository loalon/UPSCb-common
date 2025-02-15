#!/bin/bash
#SBATCH -p core -n 8
#SBATCH -t 12:00:00
#SBATCH --mail-type ALL

# fail on ERROR
set -e

# load helpers
source $UPSCb/src/bash/functions.sh

CPU=8
OPTIONS=

# usage
USAGETXT=\
"
  $0 [options] <transcript file> <output file>
  
  Options: 
  -t number of threads (default 8)
  -p triggers --perfectHash
"

# process the arguments
## get the options
while getopts t:p option
do
  case "$option" in
	    t) CPU=$OPTARG;;
	    p) OPTIONS="--perfectHash $OPTIONS";;
		  \?) ## unknown flag
		  abort "Unknow option";;
  esac
done
shift `expr $OPTIND - 1`

# test
if [ "$#" -ne "2" ]; then
  abort "This script expects 2 arguments"
fi

if [ ! -f $1 ]; then
  abort "The first argument should be a fasta file"
fi

if [ ! -d `dirname $2` ]; then
  abort "The output directory does not exist, create it first"
fi

# exec
singularity exec --bind /mnt:/mnt /mnt/picea/projects/singularity/salmon.simg salmon index -t $1 -i $2 -p $CPU $OPTIONS

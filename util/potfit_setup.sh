#!/bin/sh
####################################################################
#
#   Copyright 2009 Daniel Schopf
#             Institute for Theoretical and Applied Physics
#             University of Stuttgart, D-70550 Stuttgart, Germany
#             http://www.itap.physik.uni-stuttgart.de/
#
####################################################################
#
#   This file is part of potfit.
#
#   potfit is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
#
#   potfit is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with potfit; if not, write to the Free Software
#   Foundation, Inc., 51 Franklin St, Fifth Floor,
#   Boston, MA  02110-1301  USA
#
#/****************************************************************
#* $Revision: 1.1 $
#* $Date: 2009/12/03 08:36:13 $
#*****************************************************************/

while getopts 'c:p:s:?h' OPTION
do
    case $OPTION in
	c) c_file="$OPTARG";
            ;;
	p) p_file="$OPTARG";
            ;;
	s) prefix="$OPTARG";
	    ;;
        ?) printf "\nUsage: %s: [-c config file] [-p potential file] [-s prefix]\n" $(basename $0) >&2
            printf "\n -c <config file>\tname of the configuration file\n" >&2
	    printf " -p <potential file>\tname of the potential file\n" >&2
	    printf "\t\t\t\tfor analytic potentials this can easily be created with\n" >&2
	    printf "\t\t\t\tthe makeapot script from the awkscripts\n" >&2
	    printf " -s <prefix>\t\tprefix for all files, overrides -c and -p\n" >&2
	    printf "\t\t\t\tthe following files will be checked:\n" >&2
	    printf "\t\t\t\t<prefix>.pot and <prefix>.config\n" >&2
	    printf "\t\t\t\tif they are not found, -c and -p will be read\n" >&2
	    exit 2
	    ;;
    esac
done

if [ "$prefix" != "" ]; then
	c_file=$prefix".config";
	p_file=$prefix".pot";
	if [ ! -e "$c_file" ]; then
		c_file="dummy.config";
	fi
	if [ ! -e "$p_file" ]; then
		p_file="dummy.pot";
	fi
	endpot=$prefix".pot_end";
	tempfile=$prefix".tmp";
	imdpot=$prefix".imd";
	plotfile=$prefix".plot";
	flagfile="STOP";
	output_prefix="$prefix";
else
	prefix="dummy";
	c_file="dummy.config";
	p_file="dummy.pot";
	endpot=$prefix".pot_end";
	tempfile=$prefix".tmp";
	imdpot=$prefix".imd";
	plotfile=$prefix".plot";
	flagfile="STOP";
	output_prefix="$prefix";
fi

if [ -e "$c_file" ]; then
	n_types=`cat $c_file | grep -v \^\# | awk 'BEGIN{x=0;} {if ($1>x) x=$1} END{print x+1}'`;
else
	n_types="0";
fi

echo "# main parameters"
echo "# number of atom types (types vary in [0..ntypes-1])"
echo "ntypes $n_types"
echo ""
echo "# file names - required"
echo "# file with atom configuration in force format"
echo "config $c_file"
echo ""
echo "# file name for starting potential"
echo "startpot $p_file"
echo ""
echo "# file name for final potential"
echo "endpot $endpot"
echo ""
echo "# file name for temporary (intermediate) potential"
echo "tempfile $tempfile"
echo ""
echo ""
echo "# file names - optional"
echo "# file name prefix for imd potential"
echo "imdpot $imdpot"
echo ""
echo "# file name for plotting potential"
echo "plotfile $plotfile"
echo ""
echo "# file whose presence terminates fit"
echo "flagfile $flagfile"
echo ""
echo ""
echo "# general options"
echo "# binary, radial pair distribution, will be written to <config>.pair"
echo "write_pair 1"
echo ""
echo ""
echo "# options only for tabulated potentials"
echo "# file name for plotting the sampling points"
echo "#plotpointfile"
echo ""
echo "# file name for distribution file (* with compile option 'dist')"
echo "#distfile "
echo ""
echo "# file with maximal permissible changes for each parameter"
echo "#maxchfile "
echo ""
echo ""
echo "# options only for analytic potentials"
echo "# starting point for plotting potentials"
echo "#plotmin 0.1"
echo ""
echo "# binary, whether or not to include chemical potentials"
echo "#disable_cp 0"
echo ""
echo ""
echo "# options for output"
echo "# number of points in each function in imd file"
echo "imdpotsteps 1000"
echo ""
echo "# prefix for various output files like force, energy and stress deviations"
echo "output_prefix $prefix"
echo ""
echo ""
echo "# Minimization options"
echo "# binary, whether or not to perform an optimization"
echo "opt 1"
echo ""
echo "# starting temperature for simulated annealing, set to zero to skip simulated annealing"
echo "anneal_temp 100"
echo ""
echo "# weight of energy in minimization"
echo "eng_weight 10"
echo ""
echo "# weight of stress in minimiziation"
echo "stress_weight 10"
echo ""
echo "# seed for random number generator"
echo "seed 123"

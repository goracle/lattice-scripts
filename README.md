# lattice-scripts 
Lattice qcd related scripts (most are probably too specific to be of much use; caveat emptor).  I tried to arrange these in decreasing usefulness order.
===================================

-----------------------------------------------------
1. conv\_omega.py:
-----------------------------------------------------

Convert omega's to b's and c's.  Input file:

<...>

omega[0]=1.0903256131299373 0

omega[1]=0.9570283702230611 0

omega[2]=0.7048886040934104 0

omega[3]=0.48979921782791747 0

omega[4]=0.328608311201356 0

omega[5]=0.21664245377015995 0

omega[6]=0.14121112711957107 0

omega[7]=0.0907785101745156 0

omega[8]=0.05608303440064219 -0.007537158177840385

omega[9]=0.05608303440064219 0.007537158177840385

omega[10]=0.0365221637144842 -0.03343945161367745

omega[11]=0.0365221637144842 0.03343945161367745

<...>

usage:

conv\_omega.py params.txt

Then, enter the scale parameters b and c. (usually 1 and 0, respectively.)

N.B. The omega's can't be out of order line-by-line, i.e. that index omega[index] is not examined.

----------------------------------------------------------------
2. geom.sh 
(balances node geometry for SIMD layout 1 2 2 2 for equal volume layout)
-----------------------------------------------------

usage:

geom.sh <..integer (multiple of 2)..>

e.g.

geom.sh 64

2 2 4 4

----------------------------------------------------------------
3. nump.py
-----------------------------------------------------

usage:

nump.py <..integer: max number of lattice momenta needed in k2pipiPBC calculation..>

----------------------------------------------------------------
4. residplot.sh
----------------------------------------------------------------

Plot the residual history for the first 400 cg iterations.  This script needs a fairly clean working directory which has in it the slurm output history (from Grid, with --log Iterative turned on).

usage:

residplot.sh <..integer: slurm job id..>

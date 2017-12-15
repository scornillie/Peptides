#!/bin/bash

set -x

source /projects/sciteam/gk4/amber-pgi/amber.sh

SANDEREXE=/projects/sciteam/gk4/amber-pgi/bin/pmemd.MPI

TOP=../peptide.tip3p.200mM.hmass.prmtop
CRD=../peptide.tip3p.rand.inpcrd

## Make the equilibration scripts ##

cat > mini.in <<EOF
Minimzing the system with 25 kcal/mol restraints on DNA, 500 steps
of steepest descent and 500 of conjugated gradient
 &cntrl
   imin=1, ntx=1, irest=0, ntpr=50, ntf=1, ntb=1,
   cut=9.0, nsnb=10, ntr=1, maxcyc=1000, ncyc=500, ntmin=1,
   restraintmask='@CA',
   restraint_wt=25.0,
 &end
 &ewald
    ew_type = 0, skinnb = 1.0,
 &end
EOF

cat > heat.in <<EOF
Heating the system with 25 kcal/mol restraints on DNA, V=const
 &cntrl
    imin=0, ntx=1, ntpr=500, ntwr=500, ntwx=500, ntwe=500,
    nscm=5000,
    ntf=2, ntc=2,
    ntb=1, ntp=0,
    nstlim=50000, t=0.0, dt=0.002,
    cut=9.0,
    tempi=100.0, ntt=1,
    ntr=1,nmropt=1,
   restraintmask='@CA',
    restraint_wt=25.0,
&end
 &wt type='TEMP0', istep1=0,    istep2=5000,  value1=100.0, value2=300.0,  &end
 &wt type='TEMP0', istep1=5001, istep2=50000, value1=300.0, value2=300.0,  &end
 &wt type='END',  &end
EOF

cat > mini5.in <<EOF
Minimzing the system with 5 kcal/mol restraints on DNA, 500 steps
of steepest descent and 500 of conjugated gradient
 &cntrl
   imin=1, ntx=1, irest=0, ntpr=50, ntf=1, ntb=1,
   cut=9.0, nsnb=10, ntr=1, maxcyc=1000, ncyc=500, ntmin=1,
   restraintmask='@CA',
   restraint_wt=5.0,
 &end
 &ewald
    ew_type = 0, skinnb = 1.0,
 &end
 &wt
    type = 'END',
 &end
EOF

cat > eq5.in <<EOF
Equilibrating the system with 5 kcal/mol restraints on DNA, during 50ps,
at constant T= 300K & P= 1Atm and coupling = 0.2
 &cntrl
    imin=0, ntx=1, ntpr=500, ntwr=500, ntwx=500, ntwe=500,
    nscm=5000,
    ntf=2, ntc=2,
    ntb=2, ntp=1, tautp=0.2, taup=0.2,
    nstlim=25000, t=0.0, dt=0.002,
    cut=9.0,
    ntt=1,
    ntr=1,
   restraintmask='@CA',
   restraint_wt=5.0,
 &end
 &ewald
    ew_type = 0, skinnb = 1.0,
 &end
EOF

cat > mini4.in <<EOF
Minimzing the system with 4 kcal/mol restraints on DNA, 500 steps
of steepest descent and 500 of conjugated gradient
 &cntrl
   imin=1, ntx=1, irest=0, ntpr=50, ntf=1, ntb=1,
   cut=9.0, nsnb=10, ntr=1, maxcyc=1000, ncyc=500, ntmin=1,
   restraintmask='@CA',
   restraint_wt=4.0,
 &end
 &ewald
    ew_type = 0, skinnb = 1.0,
 &end
EOF

cat > eq4.in <<EOF
Equilibrating the system with 4 kcal/mol restraints on DNA, during 50ps,
at constant T= 300K & P= 1Atm and coupling = 0.2
 &cntrl
    imin=0, ntx=1, ntpr=500, ntwr=500, ntwx=500, ntwe=500,
    nscm=5000,
    ntf=2, ntc=2,
    ntb=2, ntp=1, tautp=0.2, taup=0.2,
    nstlim=25000, t=0.0, dt=0.002,
    cut=9.0,
    ntt=1,
    ntr=1,
   restraintmask='@CA',
   restraint_wt=4.0,
 &end
 &ewald
    ew_type = 0, skinnb = 1.0,
 &end
EOF

cat > mini3.in <<EOF
Minimzing the system with 3 kcal/mol restraints on DNA, 500 steps of
steepest descent and 500 of conjugated gradient
 &cntrl
   imin=1, ntx=1, irest=0, ntpr=50, ntf=1, ntb=1,
   cut=9.0, nsnb=10, ntr=1, maxcyc=1000, ncyc=500, ntmin=1,
   restraintmask='@CA',
   restraint_wt=3.0,
 &end
 &ewald
    ew_type = 0, skinnb = 1.0,
 &end
EOF

cat > eq3.in <<EOF
Equilibrating the system with 3 kcal/mol restraints on DNA, during 50ps,
at constant T= 300K & P= 1Atm and coupling = 0.2
 &cntrl
    imin=0, ntx=1, ntpr=500, ntwr=500, ntwx=500, ntwe=500,
    nscm=5000,
    ntf=2, ntc=2,
    ntb=2, ntp=1, tautp=0.2, taup=0.2,
    nstlim=25000, t=0.0, dt=0.002,
    cut=9.0,
    ntt=1,
    ntr=1,
   restraintmask='@CA',
   restraint_wt=3.0,
 &end
 &ewald
    ew_type = 0, skinnb = 1.0,
 &end
EOF

cat > mini2.in <<EOF
Minimzing the system with 2 kcal/mol restraints on DNA, 500 steps of
steepest descent and 500 of conjugated gradient
 &cntrl
   imin=1, ntx=1, irest=0, ntpr=50, ntf=1, ntb=1,
   cut=9.0, nsnb=10, ntr=1, maxcyc=1000, ncyc=500, ntmin=1,
   restraintmask='@CA',
   restraint_wt=2.0,
 &end
 &ewald
    ew_type = 0, skinnb = 1.0,
 &end
EOF

cat > eq2.in <<EOF
Equilibrating the system with 2 kcal/mol restraints on DNA, during 50ps,
at constant T= 300K & P= 1Atm and coupling = 0.2
 &cntrl
    imin=0, ntx=1, ntpr=500, ntwr=500, ntwx=500, ntwe=500,
    nscm=5000,
    ntf=2, ntc=2,
    ntb=2, ntp=1, tautp=0.2, taup=0.2,
    nstlim=25000, t=0.0, dt=0.002,
    cut=9.0,
    ntt=1,
    ntr=1,
   restraintmask='@CA',
   restraint_wt=2.0,
 &end
 &ewald
    ew_type = 0, skinnb = 1.0,
 &end
EOF

cat > mini1.in <<EOF
Minimzing the system with 1 kcal/mol restraints on DNA, 500 steps of
steepest descent and 500 of conjugated gradient
 &cntrl
   imin=1, ntx=1, irest=0, ntpr=50, ntf=1, ntb=1,
   cut=9.0, nsnb=10, ntr=1, maxcyc=1000, ncyc=500, ntmin=1,
   restraintmask='@CA',
   restraint_wt=1.0,
 &end
 &ewald
    ew_type = 0, skinnb = 1.0,
 &end
EOF

cat > eq1.in <<EOF
Equilibrating the system with 1 kcal/mol restraints on DNA, during 50ps,
at constant T= 300K & P= 1Atm and coupling = 0.2
 &cntrl
    imin=0, ntx=1, ntpr=500, ntwr=500, ntwx=500, ntwe=500,
    nscm=5000,
    ntf=2, ntc=2,
    ntb=2, ntp=1, tautp=0.2, taup=0.2,
    nstlim=25000, t=0.0, dt=0.002,
    cut=9.0,
    ntt=1,
    ntr=1,
   restraintmask='@CA',
   restraint_wt=1.0,
 &end
 &ewald
    ew_type = 0, skinnb = 1.0,
 &end
EOF

cat > eq05.in <<EOF
Equilibrating the system with 0.5 kcal/mol restraints on DNA, during 500ps,
at constant T= 300K & P= 1Atm and coupling = 0.2
 &cntrl
    imin=0, ntx=7, ntpr=500, ntwr=500, ntwx=500, ntwe=500,
    nscm=5000,
    ntf=2, ntc=2,
    ntb=2, ntp=1, tautp=0.2, taup=0.2,
    nstlim=250000, t=0.0, dt=0.002,
    cut=9.0,
    ntt=1,
    ntr=1,
    irest=1,
   restraintmask='@CA',
   restraint_wt=0.5,
 &end
 &ewald
    ew_type = 0, skinnb = 1.0,
 &end
EOF

wait
sleep 20

## Run the equilibrations ##
aprun -n 32 $SANDEREXE -O -i mini.in -o mini.out -p $TOP -c $CRD -ref $CRD -r mini.rst -x mini.trj -e mini.ene
sleep 10
aprun -n 32 $SANDEREXE -O -i heat.in -o heat.out -p $TOP -c mini.rst -ref mini.rst -r heat.rst -x heat.trj -e heat.ene
sleep 10
aprun -n 32 $SANDEREXE -O -i mini5.in -o mini5.out -p $TOP -c heat.rst -ref heat.rst -r mini5.rst -x mini5.trj -e mini5.ene
sleep 10
aprun -n 32 $SANDEREXE -O -i eq5.in -o eq5.out -p $TOP -c mini5.rst -ref mini5.rst -r eq5.rst -x eq5.trj -e eq5.ene
sleep 10
aprun -n 32 $SANDEREXE -O -i mini4.in -o mini4.out -p $TOP -c eq5.rst -ref eq5.rst -r mini4.rst -x mini4.trj -e mini4.ene
sleep 10
aprun -n 32 $SANDEREXE -O -i eq4.in -o eq4.out -p $TOP -c mini4.rst -ref mini4.rst -r eq4.rst -x eq4.trj -e eq4.ene
sleep 10
aprun -n 32 $SANDEREXE -O -i mini3.in -o mini3.out -p $TOP -c eq4.rst -ref eq4.rst -r mini3.rst -x mini3.trj -e mini3.ene
sleep 10
aprun -n 32 $SANDEREXE -O -i eq3.in -o eq3.out -p $TOP -c mini3.rst -ref mini3.rst -r eq3.rst -x eq3.trj -e eq3.ene
sleep 10
aprun -n 32 $SANDEREXE -O -i mini2.in -o mini2.out -p $TOP -c eq3.rst -ref eq3.rst -r mini2.rst -x mini2.trj -e mini2.ene
sleep 10
aprun -n 32 $SANDEREXE -O -i eq2.in -o eq2.out -p $TOP -c mini2.rst -ref mini2.rst -r eq2.rst -x eq2.trj -e eq2.ene
sleep 10
aprun -n 32 $SANDEREXE -O -i mini1.in -o mini1.out -p $TOP -c eq2.rst -ref eq2.rst -r mini1.rst -x mini1.trj -e mini1.ene
sleep 10
aprun -n 32 $SANDEREXE -O -i eq1.in -o eq1.out -p $TOP -c mini1.rst -ref mini1.rst -r eq1.rst -x eq1.trj -e eq1.ene
sleep 10
aprun -n 32 $SANDEREXE -O -i eq05.in -o eq05.out -p $TOP -c eq1.rst -ref eq1.rst -r  peptide.tip3p.rand.rst.000 -x eq05.trj -e q05.ene
sleep 10

cp peptide.tip3p.rand.rst.000 ../

sleep 10
exit 0


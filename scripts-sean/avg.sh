#!/bin/bash

if [[ $1 = "" ]] ; then
  echo "Usage: avg.sh <FILE> [colnum] [skip <X>] [dihedral]"
  echo "              [ line | linemed | lineall ]"
  echo "              GB-only options: [ bb | all | h | o | n | c | ca | cb | ha ]"
  exit 0
fi

if [[ ! -e $1 ]] ; then
  echo $1 not found.
  exit 1
fi
INFILE=$1

COL=2
MODE=0
SKIP=0
ONLY=-1
DIHEDRAL=0
while [[ ! -z $2 ]] ; do
  case "$2" in
    "line") MODE=-1 ;;
    "linemed") MODE=-2 ;;
    "lineall") MODE=-3 ;;
    "dihedral") DIHEDRAL=1 ;;
    "bb")
      COL=3
      MODE=1
    ;;
    "all")
      COL=3
      MODE=2
    ;;
    "h")
      COL=3
      MODE=3
    ;;
    "o")
      COL=3
      MODE=4
    ;;
    "n")
      COL=3
      MODE=5
    ;;
    "c")
      COL=3
      MODE=6
    ;;
    "ca")
      COL=3
      MODE=7
    ;;
    "cb")
      COL=3
      MODE=8
    ;;
    "ha")
      COL=3
      MODE=9
    ;;
    "skip")
      shift
      SKIP=$2
    ;;
    "only")
      shift
      ONLY=$2
    ;; 
    *) COL=$2 ;;
  esac
  shift
done

awk -v skip=$SKIP -v only=$ONLY -v col=$COL -v mode=$MODE -v dihedral=$DIHEDRAL 'BEGIN{
  x=0; y=0; max=999999; hasHeaders=0; offsettype=0;
  if (col<1) {
    printf("Column < 1 (%i)\n",col);
    exit 1;
  }
  if (mode>=0) {
    if (skip>0) print "Skipping first " skip " values.";
    if (only>0) print "Keeping only first " only " values.";
    print "Averaging column " col ".";
    #print "Length of trajectories is " max " frames.";
  }
  if (mode==1) print "Backbone atoms only.";
  if (mode==2) print "All atoms.";
  if (mode==3) print "H atoms only.";
  if (mode==4) print "O atoms only.";
  if (mode==5) print "N atoms only.";
  if (mode==6) print "C atoms only.";
  if (mode==7) print "CA atoms only.";
  if (mode==8) print "CB atoms only.";
  if (mode==9) print "HA atoms only.";
}{
  # Check for out of bounds column
  if (col>NF) {
#    printf("Column out of bounds (%i>%i)\n",col,NF);
    exit 1;
  }
  # Advance past title/comments if necessary
  while (index($1,"#")!=0) {
    if (hasHeaders==0) {
      # Get headers
      for (i=1; i<=NF; i++) Headers[i]=$i;
      hasHeaders=1;
    }
    if (getline != 1) exit 0;
  }
  #if (x==max) {
  #  x=0;
  #  if (mode>=0) {
  #    printf "Reset y= %i , col1= %i, Val= %10.4f\n",y,$1,$col;
  #    printf "Running avg= %10.4f\n",total/y;
  #  }
  #}
  if (only>0 && x>=only) exit 0;
  if (x>=skip) {
    if ($col!="") {
      avgit=0;
      if (mode==1) {
        if (($1=="C")||($1=="O")||($1=="N")||($1=="H")||($1=="CA"))
          avgit=1;
      }
      else if (mode==3) {
        if ($1=="H") avgit=1;
      }
      else if (mode==4) {
        if ($1=="O") avgit=1;
      }
      else if (mode==5) {
        if ($1=="N") avgit=1;
      }
      else if (mode==6) {
        if ($1=="C") avgit=1;
      }
      else if (mode==7) {
        if ($1=="CA") avgit=1;
      }
      else if (mode==8) {
        if ($1=="CB") avgit=1;
      }
      else if (mode==9) {
        if ($1=="HA") avgit=1;
      }
      else
        avgit=1;
      if (avgit==1) {
        Value=$col;
        # If this is a dihedral try to guess if the coord will wrap based
        # on the first coordinate.
        if (dihedral==1) {
          if (y==0) {
            if ($col>=90) offsettype=1;
            else if ($col<=-90) offsettype=-1;
            #printf ("Avg.sh: dihedral=1, offsettype=%i\n",offsettype) > "/dev/stderr";
          }
          if (offsettype==1 && $col<0) Value+=360.0;
          if (offsettype==-1 && $col>0) Value-=360.0;
        }

        E[y]=Value;
        total+=Value;
        y++;
      }
    }
    else
      printf "Warning: Column %i has no value at line %i (%s).\n",col,x,$0;
  }
  x++;
}END{
  if (y<=0) {
    print "No values read.";
    exit 1;
  }

  # Average
  avg=total/y;
  outputavg=avg;
  # If coords were wrapped, wrap back
  if (dihedral==1) {
    if (outputavg<-180.0) outputavg+=360.0;
    else if (outputavg>180.0) outputavg-=360.0;
  }
  if (mode>=0) {
    printf "%i values.\n",y;
    if (hasHeaders==1) printf("%s ",Headers[col]);
    printf "  Avg= %10.4f\n", outputavg;
  }

  # Stdev
  diff2sum=0;
  for (x=0;x<y; x++) {
    diff=E[x]-avg;
    diff2=diff*diff;
    diff2sum+=diff2;
  }
  diff2sum/=y;
  stdev=sqrt(diff2sum);
  if (mode>=0) {
    if (hasHeaders==1) printf("%s ",Headers[col]);
    printf "Stdev= %10.4f\n",stdev;
  }

  # Median
  #   Sort temp array
  #   tempArray will have y elements indexed 1 to y, so shift tempArray indices +1
  n = asort(E, tempArray); 
  # Report median
  if ( (y % 2) != 0 ) {
    # Odd number of values, median is the middle
    n = ((y-1)/2) + 1;
    median = tempArray[ n ];
  } else {
    # Even number of values, median is avg of middle 2.
    idx = (y / 2) + 1;
    median = ( tempArray[idx] + tempArray[idx - 1] ) / 2;
  }
  if (mode>=0) {
    if (hasHeaders==1) printf("%s ",Headers[col]);
    printf("  Med= %10.4f\n",median);
  }

  # Min/Max
  minval=E[0];
  maxval=E[0];
  for (x=1;x<y; x++) {
    if (E[x]<minval) minval = E[x];
    if (E[x]>maxval) maxval = E[x];
  }
  if (mode>=0) {
    if (hasHeaders==1) printf("%s ",Headers[col]);
    printf("  Min= %10.4f  Max= %10.4f\n",minval,maxval);
  }

  # Line output
  if (mode<0) {
    printf("%10.4f %10.4f",outputavg,stdev);
    if (mode<-1) printf(" %10.4f",median);
    if (mode<-2) printf(" %10.4f %10.4f",minval,maxval);
    printf("\n");
  }
}' $INFILE 

exit 0

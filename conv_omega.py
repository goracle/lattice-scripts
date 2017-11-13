#!/usr/bin/python3
import sys
from decimal import Decimal
import numpy as np


def main():
    """Convert omega's from file to b's and c's for cps.
    Assumes the omegas are in order, e.g.:
    omega[0]=2.394872 1.2
    omega[1]=9.4872 -3.4
    omega[2]=9.4872 2.3
    """
    try:
        fn=open(sys.argv[1],'r')
    except:
        print("Input file of omega's to get b's and c's")
        sys.exit(1)
    b=float(input("b="))
    c=float(input("c="))
    bpc=b+c
    bmc=b-c
    omega=[]
    for line in fn:
        if not '=' in line:
            continue
        line=line.split('=')
        if line[0][:5] != 'omega':
            continue
        line=line[1]
        real=np.float128(line.split()[0])
        imag=np.float128(line.split()[1])
        omega.append(complex(real,imag))
    omega=np.array(omega)
    bees = np.array(omega)
    sees = np.array(omega)
    print("b=", b, "c=", c)
    for i,num in enumerate(omega):
        print("omega[", i, "]=", omega[i])
        bees[i] = 1/2*(bpc/num+bmc)
        sees[i] = 1/2*(bpc/num-bmc)
    print("Array zmobius_b_coeff["+str(2*len(bees))+"] = {")
    for i, num in enumerate(bees):
        print("double zmobius_b_coeff["+str(
            2*i)+"] = " + getstr(num.real))
        print("double zmobius_b_coeff["+str(
            2*i+1)+"] = " + getstr(num.imag))
    print("}")
    print("Array zmobius_c_coeff["+str(2*len(sees))+"] = {")
    for i, num in enumerate(sees):
        print("double zmobius_c_coeff["+str(
            2*i)+"] = " + getstr(num.real))
        print("double zmobius_c_coeff["+str(
            2*i+1)+"] = " + getstr(num.imag))
    print("}")

def getstr(num):
    if num == 0:
        return '0.0000000000000000e+00'
    else:
        pre='{0:.16e}'.format(Decimal(num))
        spl=pre.split('e')
        if len(spl[1]) == 2:
            spl[1]=spl[1][0]+'0'+spl[1][1]
            ret=spl[0]+'e'+spl[1]
        else:
            ret=pre
        return ret
        


if __name__ == '__main__':
    main()

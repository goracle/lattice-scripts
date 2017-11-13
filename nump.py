#!/usr/bin/python3

import sys
import numpy as np

#relative momentum cut on == True,
#set to False reproduces the number of momentum combinations we saw for pmax=2:
#27959
relmomcut=True
debug=False

def main():
    count=0
    plist = []
    nmom=int(sys.argv[1])
    for i in range(-nmom,nmom+1):
        for j in range(-nmom,nmom+1):
            for k in range(-nmom,nmom+1):
                if i*i+j*j+k*k > nmom*nmom:
                    continue
                else:
                    count+=1
                    plist.append([i,j,k])
    print("Number of single particle momenta combinations=",count)
    #3 rho polarizations + 1 sigma + 1 pion = num of species
    print("Number of meson fields needed=",count*5)
    plist = np.array(plist)
    #now count the number of pipi momentum combinations
    count = 0
    for i in plist:
        for num1, j in enumerate(plist):
            #apply center of mass cut
            if norm2(i+j)>nmom**2:
                continue
            #first relative momenta cut
            if norm2(i-j)>nmom**2 and relmomcut:
                continue
            #V
            if debug:
                print('V', i, j)
            count+=1
            for num2, k in enumerate(plist):
                #aux diagram cut
                if num2 < num1:
                    continue
                #cons of momentum
                l = i+j-k
                #check to see if result is in list
                if norm2(l) > nmom**2:
                    continue
                #2nd relative momentum cut
                if norm2(l-k) > nmom**2 and relmomcut:
                    continue
                if debug:
                    print('CDR=', i, j, k)
                count+=5 #D,R,Dvec,Rvec,C
    print("Number of pipi momentum combinations=", count)
    count+=3*len(plist) #pionChk, pion, sigma correlator
    count+=6*len(plist) #rho correlator (aux cut, so not 9)
    count+=len(plist) #sigma bubbles
    for pcom in plist:
        for num1, j in enumerate(plist):
            l = pcom-j
            #check to see if result is in list
            if norm2(l) > nmom**2:
                continue
            #relative momentum cut
            if norm2(j-l) > nmom**2 and relmomcut:
                continue
            count+=1 #T sigma sink
            count+=2*3 #rho sink
    print("Number of momentum combinations=", count)

def norm2(mom):
    """Norm^2"""
    return mom[0]**2+mom[1]**2+mom[2]**2

if __name__ == '__main__':
    main()

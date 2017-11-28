#!/usr/bin/python3

import sys
from collections import defaultdict
import numpy as np
from math import pi, sqrt
from warnings import warn
from tabulate import tabulate

#relative momentum cut on == True,
#set to False reproduces the number of momentum combinations we saw for pmax=2:
#27959
relmomcut=True
debug=False

def pipiEnergy(nump1, nump2):
    """Return pipi energy in GEV"""
    warn("Neglecting pipi interaction energy")
    energy = reten(nump1)+reten(nump2)
    rete = str(round(energy, 3))
    if len(rete) < 5:
        rete = rete + '0'
    return rete

def reten(nump):
    """Do the numerics for the energy"""
    warn("Assuming volume is 24c.")
    onedv = 24
    return sqrt((.139570)**2+(2*pi/onedv)**2*np.inner(nump,nump))

def main(maxpc, maxpr):
    print("Assuming max pipi relative momentum is", maxpr)
    count=0
    plist = []
    eset = set()
    nmom=int(sys.argv[1])
    print("Assuming max pipi center of mass momentum is "+str(maxpc))
    maxpn = nmom
    energydict = defaultdict(lambda: 0)
    for i in range(-maxpn,maxpn+1):
        for j in range(-maxpn,maxpn+1):
            for k in range(-maxpn,maxpn+1):
                if i*i+j*j+k*k > maxpn*maxpn:
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
            if norm2(i+j)>maxpc**2:
                continue
            #first relative momenta cut
            if norm2(i-j)>maxpr**2 and relmomcut:
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
                if norm2(l) > maxpn**2:
                    continue
                #2nd relative momentum cut
                if norm2(l-k) > maxpr**2 and relmomcut:
                    continue
                if debug:
                    print('CDR=', i, j, k)
                count+=5 #D,R,Dvec,Rvec,C
                esrc = pipiEnergy(i,j)
                esnk = pipiEnergy(l,k)
                #ekey = str(esrc)+', '+str(esnk)
                ekey = str(esrc)+' '+str(esnk)
                eset.add(float(esrc))
                eset.add(float(esnk))
                energydict[ekey] += 5
    print("Number of pipi momentum combinations=", count)
    count+=3*len(plist) #pionChk, pion, sigma correlator
    count+=6*len(plist) #rho correlator (aux cut, so not 9)
    count+=len(plist) #sigma bubbles
    for pcom in plist:
        if np.inner(pcom, pcom) > maxpc**2:
            continue
        for num1, j in enumerate(plist):
            l = pcom-j
            #check to see if result is in list
            if norm2(l) > maxpn**2:
                continue
            #relative momentum cut
            if norm2(j-l) > maxpr**2 and relmomcut:
                continue
            count+=1 #T sigma sink
            count+=2*3 #rho sink
    print("Number of momentum combinations=", count)
    elist = convSet(eset)
    emat = makemat(elist, energydict)
    #energyPrint(energydict)
    goodEprint(emat, elist)

def goodEprint(emat, elist):
    """Pretty print of energy data""" 
    relist = np.array([elist]).T
    #len1 = len(emat)
    #pmat = np.zeros((len1, len1+1), dtype=object)
    pmat = np.concatenate((relist,emat), axis=1)
    table = tabulate(pmat, elist, tablefmt="fancy_grid")
    print(table)


def makemat(elist, energydict):
    """Make a matrix from dict"""
    len1 = len(elist)
    ret = np.zeros((len1,len1))
    for i, numi in enumerate(elist):
        for j, numj in enumerate(elist):
            key = numi+' '+numj
            ret[i,j] = energydict[key]
    return ret

def convSet(eset):
    """convert energy set to list for cols/rows"""
    preret = sorted(list(eset))
    ret = [str(i) for i in preret]
    return ret

def energyPrint(elist):
    """Print energy"""
    print("E(GeV)->src, snk|Combinations")
    for k, v in elist.items():
        print(f'{k:<4} | {v}')


def norm2(mom):
    """Norm^2"""
    return mom[0]**2+mom[1]**2+mom[2]**2

if __name__ == '__main__':
    maxmaxpr=2*int(sys.argv[1])
    maxmaxpc=2*int(sys.argv[1])
    for maxpc in range(maxmaxpc+1):
        for maxpr in range(maxmaxpr+1):
            main(maxpc, maxpr)


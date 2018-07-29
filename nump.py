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
html=True
if html:
    extra="<br />"
else:
    extra=''

def printn(*args,  **kwargs):
    """print for html output in tabulate"""
    print(*args, **kwargs)
    if html:
        print(extra)

def pipiEnergy(nump1, nump2):
    """Return pipi energy in GEV"""
    warn("Neglecting pipi interaction energy"+extra)
    energy = reten(nump1)+reten(nump2)
    ecm = sqrt(energy**2-(2*pi/24)**2*norm2(nump1+nump2))
    rete = str(round(ecm, 3))
    if len(rete) < 5:
        rete = rete + '0'*(5-len(rete))
    return rete

def reten(nump):
    """Do the numerics for the energy"""
    warn("Assuming volume is 24c."+extra)
    onedv = 24
    return sqrt((.139570)**2+(2*pi/onedv)**2*norm2(nump))

def main(maxpc, maxpr):
    if html:
        print("<p>")
    printn("Assuming max pipi relative momentum is", maxpr)
    count=0
    plist = []
    eset = set()
    nmom=int(sys.argv[1])
    printn("Assuming max pipi center of mass momentum is "+str(maxpc))
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
    printn("Number of single particle momenta combinations=",count)
    #3 rho polarizations + 1 sigma + 1 pion = num of species
    printn("Number of meson fields needed=",count*5)
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
                printn('V', i, j)
            count+=1
            for num2, k in enumerate(plist):
                #aux diagram cut (to do)
                #if num2 < num1:
                #    continue
                #cons of momentum
                l = i+j-k
                #check to see if result is in list
                if norm2(l) > maxpn**2:
                    continue
                #2nd relative momentum cut
                if norm2(l-k) > maxpr**2 and relmomcut:
                    continue
                if debug:
                    printn('CDR=', i, j, k)
                count+=5 #D,R,Dvec,Rvec,C
                esrc = pipiEnergy(i,j)
                esnk = pipiEnergy(l,k)
                #ekey = str(esrc)+', '+str(esnk)
                ekey = str(esrc)+' '+str(esnk)
                eset.add(float(esrc))
                eset.add(float(esnk))
                energydict[ekey] += 5
    printn("Number of pipi momentum combinations=", count)
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
    printn("Number of momentum combinations=", count)
    elist = convSet(eset)
    emat = makemat(elist, energydict)
    #energyPrint(energydict)
    goodEprint(emat, elist)
    if html:
        print("</p>")

def goodEprint(emat, elist):
    """Pretty print of energy data""" 
    relist = np.array([elist],dtype=object).T
    emat = np.array(emat, dtype=object)
    #printn(relist)
    #len1 = len(emat)
    #pmat = np.zeros((len1, len1+1), dtype=object)
    pmat = np.concatenate((relist,emat), axis=1)
    #if len(pmat)>3:
    #printn(pmat[3])
    if html:
        table = tabulate(pmat, elist, tablefmt="html", floatfmt=".3f")
    else:
        table = tabulate(pmat, elist, tablefmt="fancy_grid")
    printn("Printing statistical energy (GeV) coverage")
    printn("entries are number of momentum combinations with that COM energy")
    printn("")
    print(table)


def makemat(elist, energydict):
    """Make a matrix from dict"""
    len1 = len(elist)
    ret = np.zeros((len1,len1), dtype=int)
    for i, numi in enumerate(elist):
        for j, numj in enumerate(elist):
            key = numi+' '+numj
            ret[i,j] = energydict[key]
    return ret

def convSet(eset):
    """convert energy set to list for cols/rows"""
    preret = sorted(list(eset))
    preret = [str(i) for i in preret]
    ret = []
    for i in preret:
        if len(i) < 5:
            i = i + '0'*(5-len(i))
        ret.append(i)
    return ret

def energyPrint(elist):
    """Print energy"""
    printn("E(GeV)->src, snk|Combinations")
    for k, v in elist.items():
        printn(f'{k:<4} | {v}')


def norm2(mom):
    """Norm^2"""
    return mom[0]**2+mom[1]**2+mom[2]**2

if __name__ == '__main__':
    maxmaxpr=2*int(sys.argv[1])
    maxmaxpc=2*int(sys.argv[1])
    for maxpc in range(maxmaxpc+1):
        for maxpr in range(maxmaxpr+1):
            main(maxpc, maxpr)


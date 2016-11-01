import sys
import matplotlib
matplotlib.use("TkAgg")
matplotlib.rcParams['agg.path.chunksize'] = 10000
import matplotlib.pyplot as plt
from pylab import savefig
import argparse
import sys


def HELP():
    h="""
                make Graph!

    -f --filepath [filaPath] input your file path

    """
    return h
def argumentSetUp():
    parser = argparse.ArgumentParser(description="graph maker")
    parser.add_argument("-f","--filepath",dest="filePath",
            help="input your data file path")
    return parser
# main #
def memoryParse(mem):
    if mem == "000":
        return 0
    else:
        return int(mem[0]+mem[1]+"000",16)

def fileInput(filePath):
    x=[]
    y=[]
    f=open(filePath,"r")
    while True:
        line=f.readline()
        if not line:break;
        tmp=line.split()
        x.append(int(tmp[0]))
        y.append(memoryParse(tmp[2]))
    f.close()
    return x,y

def finalDraw(filePath):
    x=[]
    y=[]
    x,y=fileInput(filePath)
    fig=plt.figure()
    filename=filePath.split(".txt")
    plt.plot(x,y,linewidth=2.5)
    plt.title("memory access graph")
    plt.xlabel("tick time")
    plt.ylabel("access address")
    plt.grid(True)
    plt.savefig(filename[0],dpi=200)
    plt.close(fig)


if __name__ == '__main__':
    parser=argumentSetUp()
    args=parser.parse_args()

    if len(sys.argv) < 2:
        hel=HELP()
        print hel
        exit(1)

    finalDraw(args.filePath)

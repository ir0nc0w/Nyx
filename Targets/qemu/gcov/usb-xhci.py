#!/usr/bin/env python3

import sys
import os
import subprocess
import time
import daemon
from daemon import pidfile

gcov_file = ''
qemuN = ''

cmd1 = "gcov -n -c -b /mnt/hdb2/cwmyung/NYX/nyx0/QEMU/"
cmd2 = "/build/libcommon.fa.p/hw_usb_hcd-xhci.c. | grep -n4 hcd-xhci.c | gawk \'{ print strftime(\"%m-%d %H:%M:%S\"), $0 }\'"

def do_something(arg):

    gcov_file = '/mnt/hdb2/cwmyung/NYX/nyx0/Targets/qemu/gcov/gcov/gcov-'
    qemuN = arg
    # load the shared object file
    # gcov = CDLL('/home/user/gcov.so') ## Read DLL


    gfile  = gcov_file 
    gfile += qemuN
    f = open(gfile, 'a')
    cmd = cmd1 + cmd2
    #cmd = cmd1 + qemuN + cmd2
    process = subprocess.Popen(cmd,shell=True,stdout=f)
    process.communicate()[0]
    f.close()

def main():
    qemuN = sys.argv[1]

    do_something(qemuN)


if __name__ == "__main__":
    main()

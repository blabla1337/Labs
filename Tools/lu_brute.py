
import tn3270lib,time,sys
# This requires the tn3270lib library available here: https://github.com/zedsec390/tn3270lib
host = sys.argv[1]
port = int(sys.argv[2])
print "Simple Python Script to find LUs"
# Copyright Philip Young
tn3270 = tn3270lib.TN3270()
#tn3270.set_debuglevel(1)
for i in range(0,99):
    # Change 'ISSALU' to whatever your LU is
    lu = 'ISSALU' + "{0:0>2}".format(i)
    tn3270.set_LU(lu)
    if tn3270.initiate(host,port):
        print lu,": True"
    else:
        print lu,": False"

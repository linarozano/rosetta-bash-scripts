import numpy as np
inputfile='50k_test'
binwidth=10
cage = np.loadtxt(inputfile, dtype=np.str, skiprows=1)
r=cage[:,0]
x=cage[:,1]
x=x.astype(np.float)
y=cage[:,2]
y=y.astype(np.float)
max=np.amax(y)
min=np.amin(y)
R=np.arange(min,(max+binwidth),binwidth)
#print(r)
#print(x)
#print(y)

for i in range(0, len(R)):
    see=np.where((y >=(min+(i*binwidth))) & (y <=(min+((i+1)*binwidth))))
    outputfile="inputfile"+str(i)
    print(see)
    print(cage[see])
    np.savetxt(outputfile, cage[see], delimiter=' ', fmt="%s")

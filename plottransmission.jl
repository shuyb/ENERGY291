using DataFrames
using Junet, CSV

standard = readtable("t1.txt",header=false)
standard = convert(Array,standard)
standard2 = reshape(standard,(30,30))
standard2 = convert(DataFrame,standard2)
CSV.write("t1.csv",standard2)

 sum(getvalue(transmission), dims = 3)

A = zeros(2,2,2)
A[:,:,1] = [1 2; 3 4]
A[:,:,2] = [10 20; 30 40]
# AA = zeros(2,2)
AA = sum(A,dims = 3)[:,:,1]
writedlm("A.txt", AA)

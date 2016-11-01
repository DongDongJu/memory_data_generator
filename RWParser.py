import sys

def fileWriter(data):
    file_name=sys.argv[2]
    f=open(file_name,'a')
    f.write(data)
    f.close()

def makeData(line_data):
    result=""
    result+=line_data[0][:-1]
    if line_data[2][0] == 'R':
        result+=" R "
    else:
        result+=" W "
    result+=line_data[-4][2:]
    result+=" "
    result+=line_data[7]
    result+="\n"
    return result

def checkReadWrite(line):
    line_data=line.split()
    if "Read" in line_data and "cpu.data" in line_data:
       fileWriter(makeData(line_data))
    elif "Write" in line_data and "cpu.data" in line_data:
       fileWriter(makeData(line_data))
if __name__=="__main__":
    f=open(sys.argv[1],'r')
    while True:
        line=f.readline()
        if not line: break
        checkReadWrite(line)
    f.close()

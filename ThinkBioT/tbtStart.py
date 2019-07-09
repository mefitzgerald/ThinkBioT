#! /usr/local/bin/python3

def main():
    f= open("tbtServicetest.txt","w+")
    for i in range(10):
         f.write("This is line %d\r\n" % (i+1))
    f.close()
if __name__== "__main__":
  main()
import csv
from pandas import read_csv
import glob
path = "/var/www/html/hcdashboard/bin/prediction/*.csv"
for fname in glob.glob(path):
    with open(fname,newline='') as f:
        r = csv.reader(f)
        data = [line for line in r]
    with open(fname,'w',newline='') as f:
        w = csv.writer(f)
        w.writerow(['count','month','year'])
        w.writerows(data)

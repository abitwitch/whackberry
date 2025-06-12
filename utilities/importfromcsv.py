#!/usr/bin/env python3
import sys
import csv
import subprocess


def addtopass(path,password):
  with subprocess.Popen(['pass','add','-m',path],stdin=subprocess.PIPE) as proc:
    proc.communicate(password.encode('utf8'))
    if proc.returncode:
      print('failure with {}, returned {}'.format(path, proc.returncode))


print(f"Importing from {sys.argv[1]}...")
with open(sys.argv[1],'r') as csvfile:
  reader=csv.reader(csvfile)
  next(reader) #skip header
  for row in reader:
    #MODIFY these lines below to match the format of the CSV you want to import
    url = row[0]
    name = row[1]
    username = row[2]
    password = row[3]
    notes = row[4]
    category = row[5]
    #MODIFY these lines below to match the format you wish for your new password manager
    addtopass(f"{category}/{name}",password)
    addtopass(f"{category}/{name}.username",username)
    if url.strip()!="":
      addtopass(f"{category}/{name}.url",url)
    if notes.strip()!="":
      addtopass(f"W{category}/{name}.notes",notes)
print("Completed.")


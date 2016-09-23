#!/usr/bin/env python

print "\nProcessing..."

import os 
import glob

try:
    import numpy as np # Numeric calculation
    import pandas as pd # General purpose data analysis library
    import squeak # For mouse data
except:
    raise Exception("\
Whoops, you're missing some of the dependencies you need to run this script.\n\
You need to have numpy, pandas, and squeak installed.")

this_dir = os.path.abspath('.')
print "Running in %s\n\
Checking for .csv files in %s" % (this_dir, os.path.join(this_dir, 'data'))

datafiles = glob.glob('data/*.csv')
print "%i files found:" % len(datafiles)
print '\n'.join(datafiles)



data = pd.concat(
    [pd.DataFrame(pd.read_csv(datafile)) 
     for datafile in datafiles])

data['t'] = data.tTrajectory.map(squeak.list_from_string)
data['x'] = data.xTrajectory.map(squeak.list_from_string)
data['y'] = data.yTrajectory.map(squeak.list_from_string)
data['y'] = data.y * -1 # reverse vertical orientation to match experiment display

# uniformly expand trajectories to 5 seconds
 
max_time = 20000 # Alternatively, max_time = data.rt.max()
sample_rate=20 # time slices in msec

data['rx'] = [squeak.uniform_time(x, t, desired_interval=sample_rate, max_duration=max_time) for x, t in zip(data.x, data.t)]
data['ry'] = [squeak.uniform_time(y, t, desired_interval=sample_rate, max_duration=max_time) for y, t in zip(data.y, data.t)] 

rx = pd.concat(list(data.rx), axis=1).T
ry = pd.concat(list(data.ry), axis=1).T

redundant = ['xTrajectory', 'yTrajectory', 'tTrajectory',
             'x', 'y', 't', 'rx', 'ry']
data = data.drop(redundant, axis=1)

print "Done!\n"

# Save data
data.to_csv('processed.csv', index=False)
print "Summary statistics saved to %s" % os.path.join(this_dir, 'processed.csv')
rx.to_csv('rx.csv', index=False)
ry.to_csv('ry.csv', index=False)

for n in ['rx', 'ry']:
    print "Mouse trajectories saved to %s.csv" % os.path.join(this_dir, n)

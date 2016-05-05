import sys
import math

def initial_function(monitored, controlled, auxiliary):
    return

def control_function(monitored, controlled, auxiliary):
    # pump head control
    if (monitored.time < 0):
      controlled.head_pump = 40
    if (monitored.time >= 0):
      controlled.head_pump = 40 * math.exp(-monitored.time / 2.0)

    # stopping condition
    if (monitored.PCT > 1200):
      raise NameError ('exit condition reached: PCT reaches 1200 K')

    return

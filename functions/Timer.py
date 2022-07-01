import time
import numpy as np

class Timer():
    def __init__(self):
        self.time_lst = []
        
    def lap(self, name=""):
        self.time_lst.append([name, time.time()])
        
    def start(self):
        self.lap("Start")
    
    def stop(self):
        self.lap("Stop")

    def summary(self):
        string = ""
        
        total_time = np.round(self.time_lst[-1][1] - self.time_lst[0][1],10)
        string += f"Total Time: {total_time}\n"
        string += "Name: Elapsed Time\n"
        
        for i in range(1, len(self.time_lst)-1):
            name = self.time_lst[i][0]
            elapsed_time = np.round(self.time_lst[i+1][1] - self.time_lst[i][1],10)
            string += f"{name}: {elapsed_time}\n"
        return string
    
    def last_lap(self):
        name = self.time_lst[-1][0]
        elapsed_time = np.round(self.time_lst[-1][1] - self.time_lst[-2][1],10)
        return f"{name}: {elapsed_time}\n"
        
    def __str__(self):
        return str(self.time_lst)
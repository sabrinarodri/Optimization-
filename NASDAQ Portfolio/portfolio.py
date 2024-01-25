#!/usr/bin/env python
# coding: utf-8

# ### Efficient Frontier Portfolio -- Optimization Team 15
# 
# ### Housekeeping -- Reset Environment if Necessary

# In[24]:


#Reset Gurobi Model
m.remove(m.getVars()) #Delete all decision variables
m.remove(m.getConstrs()) #Delete all constraints
m.update()
print('>> Model is clean.')


# In[25]:


# Close SQL connection
cur.close()
db.close()
print('>> Connection closed.')


# ----------------

# ### Import Lines

# In[1]:


import numpy as np
import pandas as pd
import mysql.connector

from gurobipy import * 
message = '>> Cell ran successfully; do not rerun.'


# ### Connect SQL Database

# In[2]:


### connect SQL Database
db = mysql.connector.connect(user ='root', password = 'root', host= 'localhost', database='nasdaq')
cur = db.cursor()
print('>> Connection successful')


# # PART 1: Data from SQL 

# In[3]:


cur.execute('SELECT * FROM r;')

StockNames = []
MeanReturn = []
StdDevReturn = []
for result in cur:
    StockNames.append(result[0])
    MeanReturn.append(result[1])
    StdDevReturn.append(result[2])

N = len(StockNames)


# In[4]:


# connect and extract correlation data from sql database
cur.execute('SELECT * FROM corr')

corr = []
for result in cur: 
    corr.append(list(result))

AllCorrelations = []

high = N
low = high - N

for i in range(N):
    if i != 0:
        high = N + N * i
        low = high - N
        AllCorrelations.append([corr[j][2] for j in range (low,high)])
    else:
        high = N
        low = high - N
        AllCorrelations.append([corr[j][2] for j in range (low,high)])
        
StackedCors = np.column_stack(AllCorrelations)

AllCovariances = []

for i in range(N):
    covariances = []
    for j in range(N):
        covar = StdDevReturn[i]*StackedCors[i][j]*StdDevReturn[j]
        covariances.append(covar)
    AllCovariances.append(covariances)

StackedCovar = np.column_stack(AllCovariances)


# # Part 2: For Loop Through Optimization

# In[5]:


def createList(r1,r2,step):
    newList = [r1]
    while r1 < r2:
        r1 = r1+step
        newList.append(r1)
    return newList
ExpPortList = createList(0.04,0.09,0.001)
ExpPortList


# In[6]:


newObsList = []
for k in ExpPortList:
    m = Model("Portfolio")
    m.Params.LogToConsole = 0 #to not show optimization summary
    InvWeights = []
    #Decision Variables -- Investment Weights 
    for stock in StockNames:
        InvWeights.append(m.addVar(vtype=GRB.CONTINUOUS,lb=0.0,name=stock))

    # givens 
    TotalWeight = 1 
    ExpPortReturn = k 
    N = len(StockNames)

    # Add Constraint 1: Total weights = required value 
    m.addConstr(quicksum(InvWeights[i] for i in range(N)),
               GRB.EQUAL, TotalWeight)

    # ERROR ISSUE AND RESOLUTION: We must cap the overall objective model via 
    # different maximum constraints because the model is unbounded without these 
    # max constraints regards to expected risk or expected mean return. 
    # TEST: Instead of Mean Port Return >= Required Mean Return ==> set to == 

    # Add Constraint 2: Mean Port Return >= Required Mean Return 
    m.addConstr(quicksum(InvWeights[i]*MeanReturn[i] for i in range(N)),
               GRB.GREATER_EQUAL, ExpPortReturn)

    m.update()

    # givens 
    TotalWeight = 1 
    ExpPortReturn = 0.05
    N = len(StockNames)

    # Add Constraint 1: Total weights = required value 
    m.addConstr(quicksum(InvWeights[i] for i in range(N)),
               GRB.EQUAL, TotalWeight)

    # ERROR ISSUE AND RESOLUTION: We must cap the overall objective model via 
    # different maximum constraints because the model is unbounded without these 
    # max constraints regards to expected risk or expected mean return. 
    # TEST: Instead of Mean Port Return >= Required Mean Return ==> set to == 

    # Add Constraint 2: Mean Port Return >= Required Mean Return 
    m.addConstr(quicksum(InvWeights[i]*MeanReturn[i] for i in range(N)),
               GRB.GREATER_EQUAL, ExpPortReturn)

    m.update()

    # first convert the list of Investment Weights into an Array
    InvWeights = np.asarray(InvWeights)

    m.setObjective(np.matmul(InvWeights,np.matmul(StackedCovar,np.transpose(InvWeights))),GRB.MINIMIZE)

    m.update()

    m.optimize()
    
    newObs = [k,round(np.sqrt(m.objVal),4)]
    newObsList.append(newObs)
    
    #Reset Gurobi Model
    m.remove(m.getVars()) #Delete all decision variables
    m.remove(m.getConstrs()) #Delete all constraints
    m.update()
    print('>> Model is clean.')


# In[7]:


df = pd.DataFrame(newObsList,columns = ['expReturn','expRisk'])
df


# In[8]:


for obs in newObsList:
    sql = "INSERT INTO portfolio (expReturn, expRisk) VALUES (%s, %s)"
    val = (obs[0]*100,obs[1]) #multiply 100 so that it is in percentage
    cur.execute(sql,val)
    
    db.commit()
    
print(cur.rowcount,"record inserted")


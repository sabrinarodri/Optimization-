# -*- coding: utf-8 -*-
"""
Created on Fri Mar 24 6:37:17 2023

@author: sabri
"""

import mysql.connector as mySQL
import re

""" global MySQL settings """
mysql_user_name = 'root'
mysql_password = 'tina'
mysql_ip = '127.0.0.1'
mysql_db = 'cell_tower'

def checkBudget(towers,budget):
    """ contents is as a dictionary of the form {tower_id:(cost,calls), ...} """
    """ This function returns True if the cell tower construction plan is within budget; False otherwise """
    load = 0
    if isinstance(towers,dict):
        for this_key in towers.keys():
            load = load + towers[this_key][0]
        if load <= budget:
            return True
        else:
            return False
    else:
        print("function checkBudget() requires a dictionary")

def compute_added_calls(towers):
    value = 0.0
    if isinstance(towers,dict):
        for this_key in towers.keys():
            value = value + towers[this_key][1]
        return(value)
    else:
        print("function compute_added_calls() requires a dictionary")
        

    ''' CODE 1'''
def cell_algo(towers,budget):
    """ heuristic cell tower algorithm using the argument values that are passed
             towers: a dictionary of the possible cell towers
             budget: budget for adding cell towers, whcih total cost cannot exceed
    
         algorithm returns:
            towers_to_pick: list containing keys (integers) of the towers you want to construct
                            The integers refer to keys in the towers dictionary. 
   """
         
    towers_to_picks = {}        # list for the indices of the towers you select
    investment = 0.0           # variable, if you wish, to keep track of how much of the budget is already used
    tot_calls_added = 0.0      # variable, if you wish, to accumulate total calls added given towers that are selected
    
    marginal_benefits = {tower_id: (increased_calls*10)/(cost*1) for tower_id, (cost, increased_calls) in towers.items()}
    dicts = [towers, marginal_benefits]
    sto = {k: [d[k] for d in dicts] for k in dicts[0]}
    sort = {k: v for k, v in sorted(sto.items(), key=lambda item: item[1])}
    sorted_towers= list(sort.items())
    
    for tower_id, [(cost, calls), margin] in sorted_towers:
        if investment + cost <= budget:
            towers_to_picks[tower_id] = (cost, calls)
            investment += cost
            tot_calls_added += calls
            towers_to_pick = list(towers_to_picks.keys())
    return towers_to_pick   


    ''' CODE 2 '''
def cell_algo2(towers,budget):
    """ heuristic cell tower algorithm using the argument values that are passed
             towers: a dictionary of the possible cell towers
             budget: budget for adding cell towers, whcih total cost cannot exceed
    
         algorithm returns:
            towers_to_pick: list containing keys (integers) of the towers you want to construct
                            The integers refer to keys in the towers dictionary. 
   """
          
    towers_to_pick = {}        # list for the indices of the towers you select
    investment = 0.0           # variable, if you wish, to keep track of how much of the budget is already used
    
    towers = [(k, *v) for k,v in towers.item()]
    towers.sort(key = lambda t:t[2]/t[1], reverse = True)
    
    i= 0
    while investment <= budget and i < len(towers):
        if investment +towers[i][1] <= budget:
            towers_to_pick.append(towers[i][0])
            investment += towers[i][1]
        i += 1
    return towers_to_pick    


    ''' CODE 3 '''
def getDBDataList():
    cnx = db_connect()
    cursor = cnx.cursor()
    #cursor.execute(commandString)
    cursor.callproc('spGetProblemIds')
    items = []
    for result in cursor.stored_results(): #list(cursor):
        for item in result.fetchall():
            items.append(item[0])
        break
    cursor.close()
    cnx.close()
    return items
   
""" db_get_data connects with the database and returns a dictionary with the problem data """
def db_get_data(problem_id):
    cnx = db_connect()
                        
    cursor = cnx.cursor()
    cursor.callproc("spGetBudget", args=[problem_id])
    for result in cursor.stored_results():
        knap_cap = result.fetchall()[0][0]
        break
    cursor.close()
    cnx.close()
    cnx = db_connect()
    cursor = cnx.cursor()
    cursor.callproc('spGetData',args=[problem_id])
    items = {}
    for result in cursor.stored_results():
        blank = result.fetchall()
        break
    for row in blank:
        items[row[0]] = (row[1],row[2])
    cursor.close()
    cnx.close()
    return knap_cap, items
    
def db_connect():
    cnx = mySQL.connect(user=mysql_user_name, passwd=mysql_password,
                        host=mysql_ip, db=mysql_db)
    return cnx

def print_find(f_name):
    #print(__file__)
    f_name = f_name[:]
    f_name = f_name.replace('()','')
    
    with open(__file__, 'r') as f:
        code = f.readlines()
        
    i = 0
    while not re.search('def\s'+f_name,code[i]) and i < len(code) - 1:
        i += 1
    if i == len(code) - 1:
        msg = 'Function %s() is missing from this code' % f_name
    else:
        i += 1
        msg = None
        while re.search('^\s+', code[i]):
            if not re.search('\s+#', code[i]) and re.search('print\(', code[i]):
                #print('Please remove or comment out the print statement in your function code before submission:', code[i])
                msg += 'Please remove or comment out the print statement in your %s() function code before submission: %s\n' % (f_name, code[i].strip(),)
            i += 1
    
    return msg
    
""" Error Messages """
error_bad_list_key = """ 
The towers_to_pick list received from cell_algo() either contained an element that was not a valid tower key or a valid tower key was included multiple times. Please check the towers_to_pick list that your cell_algo() function is returning for these errors. Other errors may also exist.
"""
error_response_not_list = """
cell_algo() returned a response for towers to be built that was not of the list data type.  Scoring will be terminated.  Other errors may also exist.   """

error_over_budget = '''Cell towers in towers_to_pick exceed the budget. '''
silent_mode = False    # use this variable to turn on/off appropriate messaging depending on student or instructor use

''' Get problem IDs to solve '''
problems = getDBDataList() 

''' First, check to ensure that function cell_algo() exists '''
''' Print message if no function; otherwise: solve problems in database '''
msg = print_find('cell_algo')
if msg:
    print('\n\n' + msg)
else:
    print('Cell Tower Problems to Solve:', problems)
    for problem_id in problems:
        print("Cell Tower Problem ", str(problem_id)," ....")
        towers_selected = {}
        budget, towers = db_get_data(problem_id)
        #finished = False
        errors = False
        response = None
        
        #print('function')
        team_num, response, nicname = cell_algo(towers.copy(),budget)
        if isinstance(response,list):
            for this_key in response:
                if this_key in towers.keys():
                    towers_selected[this_key] = towers[this_key]
                    del towers[this_key]
                else:
                    errors = True
                    if silent_mode:
                        status = error_bad_list_key #"Cell tower ID not valid (other errors may exist)"
                    else:
                        print("Problem " + str(problem_id) + ': ' + error_bad_list_key)
                    #finished = True
        else:
            errors = True
            if silent_mode:
                status = "Problem "+str(problem_id) + ': ' + error_response_not_list
            else:
                print(error_response_not_list)
                    
        if errors == False:
            budget_ok = checkBudget(towers_selected,budget)
            if budget_ok:
                towers_result = compute_added_calls(towers_selected)
                print("Problem " + str(problem_id) + ': Selected tower locations are within budget, Total Calls Added : ' + str(towers_result))
            else:
                print("Problem " + str(problem_id) + ': ' + error_over_budget)


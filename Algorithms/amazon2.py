# -*- coding: utf-8 -*-
"""
Created on Fri Mar 24 10:47:56 2023

@author: sabri
"""

def amazon_algo(items,cart_cap):
    """ Yheuristic bin packing algorithm  using the argument values that are passed
             items: a dictionary of the items to be loaded into the bins: the key is the article id and the value is the article volume
             cart_cap: the capacity of each (identical) bin (volume)
    
        algorithm returns:
             cart_contents: list containing keys (integers) of the items you want to include in the knapsack
                           The integers refer to keys in the items dictionary. 
   """
         
    cart_contents = []    # list document the article ids for the contents of 
                         # the contents of each is to be listed in a sub-list
        
    sorted_items = [(k, v) for k,v in items.items()]
    for item in sorted_items:
        add_item = False
        for current_cart in cart_contents:
            if sum([items[i] for i in current_cart]) + item[1] <= cart_cap:
                current_cart.append(item[0])
                add_item = True
                break
            elif sum([items[i] for i in current_cart]) + item[1] == cart_cap:
                current_cart.append(item[0])
                add_item = True
                break
            else:
                continue
        if not add_item:
            cart_contents.append([item[0]])
    
            
    return cart_contents
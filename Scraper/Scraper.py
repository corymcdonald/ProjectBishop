#!/usr/bin/python
# -*- coding: utf-8 -*-

import requests
import os.path
import logging
import copy
import json
import re
import json
import itertools
import datetime
from bs4 import BeautifulSoup

def isReal(txt):
    try:
        float(txt)
        return True
    except ValueError:
        return False

def parsePreReq(prereq):
    returnValue = ''
    prereq = prereq.replace('\n', '').replace(',', '').replace('"', ''
            ).replace('(', '').replace(')', ''
            ).replace('/', ' ').replace(';','')
            
    prereq = re.sub('May be repeated for up to \d* hours of degree credit','',prereq)
    prereq = re.sub('This course is equivalent to \w* \d*.','',prereq)
    
    if 'grade of' in prereq:
        my_list = prereq.replace('with a grade of', ''
                                 ).replace('or better', '').split(' ')
    else:
        resultCount = 0
        JSONresult = '{ "Course' + str(resultCount) + '": ['
        # my_list = list(filter(None, my_list))
        my_list = prereq.split(' ')

        # print(my_list)

        result = ''
        lastParseNeedsAND = False
        crossListed = False

        for x in range(0, len(my_list)):
            
            # determine if class is lab
            lab = False
            if x + 1 < len(my_list) and len(my_list[x + 1].replace(':','')) == 5 \
                and (my_list[x + 1])[:4].isdigit():
                if ':' not in my_list[x + 1]: #todo take this out only because test data is invalid
                  # print('lab')
                  lab = True
        
            # We are currently have a class
            if x + 1 < len(my_list) and ((len(my_list[x].replace('.','')) == 4 and my_list[x + 1].isdigit()) or lab):
                if crossListed == False:
                    if lastParseNeedsAND == True:
                      result = result.strip() + ' and '
                      resultCount += 1
                      JSONresult += '],"Course' + str(resultCount) + '": ['
                      
                    result = result.strip() + ' ' + my_list[x].replace('.','') + ' ' + my_list[x + 1].replace('.','')
                    JSONresult += '{ "name":"' + my_list[x].replace('.','') + ' ' + my_list[x + 1].replace('.','') + '"'\
                            ',"grade":"D" }'
                    lastParseNeedsAND = True
                    
            #for the XXXX major required type of thing
            elif x + 1 < len(my_list) and len(my_list[x]) == 4 and "major" in my_list[x + 1]:
              if lastParseNeedsAND == True:
                      result = result.strip() + ' and '
                      resultCount += 1
                      JSONresult += '],"Course' + str(resultCount) + '": ['
                      
              JSONresult += '{ "major":"' + my_list[x].replace('.','') + ' ' + my_list[x + 1].replace('.','') + '"}'
              result = result.strip() + ' ' + my_list[x].replace('.','') + ' ' + my_list[x + 1].replace('.','') + ' '
              lastParseNeedsAND = True
              
            currentItemUpper = my_list[x].upper()
            
            # For some reason the university likes to say that this class is cross-listed with another one. This is useless to us
            if currentItemUpper.upper() == 'CROSS-LISTED':
                crossListed = True
            
            # Here we need to check to make sure they meet the GPA or hour requirements.
            if ((isReal(currentItemUpper) or currentItemUpper.isdigit()) and len(currentItemUpper.replace('.','')) < 4):
                if x + 1 < len(my_list) and ('hour' in my_list[x + 1]
                        or 'hr' in my_list[x + 1]):
                    result = result.strip() + ' ' + currentItemUpper + ' HOURS '
                    if JSONresult[len(JSONresult)] == '}':
                      JSONresult += '],"Course' + str(resultCount) + '": ['
                    JSONresult += '{ "hours":"' + currentItemUpper + '"}'
                    lastParseNeedsAND = True
                elif 'GPA' in my_list or 'GPA.' in my_list or 'grade point' in my_list:
                    result = result.strip() + ' and ' + currentItemUpper + ' GPA'
                    
                    resultCount += 1
                    JSONresult += '],"Course' + str(resultCount) + '": ['
                    
                    JSONresult += '{ "GPA": ' + currentItemUpper + '}'
                    lastParseNeedsAND = True

            # Instead of providing an hour requirement sometimes they like to include what grade level you should be.
            if currentItemUpper == 'SENIOR' or currentItemUpper \
                == 'JUNIOR' or currentItemUpper == 'SOPHOMORE' \
                or currentItemUpper == 'FRESHMAN' or 'CANDIDACY' in currentItemUpper \
                or 'CONSENT' in currentItemUpper or 'GRADUATE' in currentItemUpper or 'PHD' in currentItemUpper \
                or 'HIGHER' in currentItemUpper or 'EQUIVALENT' in currentItemUpper :
                lastParseNeedsAND = True
                if currentItemUpper not in result:
                  tempArray = (result.strip()).split(' ')
                  if result != '' and (tempArray[len(tempArray)-1] != 'or' and result.strip() != 'or') and (tempArray[len(tempArray)-1] != 'and' and result.strip() != 'and'):
                    result = result.strip() + ' or '
                    JSONresult += ','
                    
                  JSONresult += '{ "name":"' + currentItemUpper.replace('.','') + '"}'
                  result = result.strip() + ' ' +  currentItemUpper.replace('.','')

            #The university likes to put this inbetween classes. Sometimes they like to put it in sentences too
            if currentItemUpper == 'OR':
                lastParseNeedsAND = False
                tempArray = (result.strip()).split(' ')
                if tempArray[len(tempArray)-1] != 'or' and result.strip() != 'or':
                  result = result.strip() + ' or '
                  JSONresult += ','
            elif currentItemUpper == 'AND':
                lastParseNeedsAND = False
                tempArray = (result.strip()).split(' ')
                if tempArray[len(tempArray)-1] != 'and' and result.strip() != 'and':
                  result = result.strip() + ' and '
                  resultCount += 1
                  JSONresult += '],"Course' + str(resultCount) + '": ['
                  
              

        result = result.replace('and and', 'and') # it's gotten to the point it's this is just the best I can do
        result = result.replace('or or', '')
        result = result.replace('or and', 'and')
        result = result.replace('and or', 'and')
        
      
        # Now we should check if the first word or the last word is "AND/OR"
        result = result.strip().split(' ')
        if len(result) > 0 and ("and" in result[0] or "or" in result[0]):
          result.pop(0)
        elif len(result) > 0 and ("and" in result[len(result)-1] or "or" in result[len(result)-1]):
          result.pop(len(result)-1)
        result = ' '.join(result)
        
        JSONresult += "]}"
        JSONresult = JSONresult.replace(',]',']')
        
        print(JSONresult)
        print(result.strip() )
        r = (json.loads(JSONresult))
        print(json.dumps(r,sort_keys=True,indent=4))
        
        returnValue = result.strip()
    # my_list = [x for x in my_list if len(x) == 4 or x.upper() == "OR" or x.upper() == "AND"]

    # for entry in my_list:
    #   if len(entry) == 4:
  # todo figure parse out the information related to if it does not have a "grade of" in the string
    #     print(entry)

  # splitAnds = prereq.replace('"', '').replace(',','').replace('.','').split('and')
  # splitAnds = [x.strip() for x in splitAnds]
  # returnValue = splitAnds

    return returnValue

def parsePre(cleaned):
  print("YEAH")


f = open('prereq.txt', 'r')
i = 0

# parsePreReq('(AGEC 2142/AGEC 2141L or AGEC 2143) or equivalent, AGEC 2303 or equivalent, and senior standing is recommended.')

variable = ''
temp = 0;
while True:
  prereq = f.readline()
  if not prereq:
      break

  # if i == 2:
  # print()
  if i > temp:
    print(str(round((i/2951)*100,2)) + '%')
    parsePreReq(prereq) +'\n'
  i = i + 1

  # if i == temp + 50 +1 : break


# d=open('json.txt','w')
# d.write(variable)


# print("Start: " + str(datetime.datetime.now()))

# url = 'http://catalog.uark.edu/undergraduatecatalog/coursesofinstruction/'
# catalogData = requests.get(url)
# catalogContent = catalogData.content

# soup = BeautifulSoup(catalogContent)

# soup.select(".sitemaplink")

# for link in soup.select(".sitemaplink"):
#   majorURL = 'http://catalog.uark.edu/' + link['href']
#   majorData = requests.get(majorURL)
#   majorContent = majorData.content
#   majorSoup = BeautifulSoup(majorContent)
#   courses = majorSoup.select(".courseblock")

#   for course in courses:
#     courseBlockTitle = course.select(".courseblocktitle")[0].get_text().strip();
#     courseBlockDescription = course.select(".courseblockdesc")[0].get_text().strip();

#     courseDescriptionAndPreCoReq = courseBlockDescription.split("Prerequisite:")
#     courseDescription = courseDescriptionAndPreCoReq[0].strip()
#     preAndCoReq = ""

#     if len(courseDescriptionAndPreCoReq) >1:
#       preAndCoReq = courseDescriptionAndPreCoReq[1].strip()

#     with open("test.txt", "a") as myfile:
#       myfile.write(courseBlockTitle + "\n" + courseDescription + "\n" + preAndCoReq + "\n\n")

#     if preAndCoReq != "":
#       with open("prereq.txt", "a") as mahfile:
#         mahfile.write(courseBlockTitle.split('.')[0] + ": " + preAndCoReq.replace('\n',' ') + "\n")

# print("End: " + str(datetime.datetime.now()))


			
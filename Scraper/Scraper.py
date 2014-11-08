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


def parseClassRequirements(prereq):
    returnValue = ''
    prereq = prereq.replace('\n','').replace(',','').replace('"','').replace('(','').replace(')','').replace('/',
                        ' ').replace(';','').replace('with a','').replace('grade of','').replace('or better','')

    prereq = re.sub(
        'May be repeated for up to \d* hours of degree credit',
        '',
        prereq)
    prereq = re.sub('This course is equivalent to \w* \d*.', '', prereq)

    resultCount = 0
    JSONresult = '{ "Course' + str(resultCount) + '": ['
    my_list = prereq.split(' ')
    my_list = list(filter(None, my_list))

    result = ''
    lastParseNeedsAND = False
    crossListed = False

    for x in range(0, len(my_list)):

        # determine if class is lab
        lab = False
        
       
        
        if x + 1 < len(my_list) and len(my_list[x + 1].replace('.','').replace(':', '')) == 5 \
                and (my_list[x + 1])[:4].isdigit():
            # todo take this out only because test data is invalid
            if ':' not in my_list[x + 1]:
                # print('lab')
                lab = True

        
        # We are currently have a class
        if x + 1 < len(my_list) and (
            (len(my_list[x].replace('.','')) == 4 and my_list[x + 1].replace('.','').isdigit()) or lab):
            if not crossListed:
                if lastParseNeedsAND:
                    result = result.replace('.','').strip() + ' and '
                    resultCount += 1
                    JSONresult += '],"Course' + str(resultCount) + '": ['

                if JSONresult[len(JSONresult)-1] == '}':
                  JSONresult += ','
                  
                grade = 'D'
                # Trying to figure out if there is a grade required

                if x + 2 < len(my_list):
                    couldBeGrade = my_list[x + 2].replace('"', '')
                    if couldBeGrade == 'A' or couldBeGrade == 'B' or couldBeGrade == 'C':
                        grade = couldBeGrade
                  
                result = result.strip() + ' ' + \
                    my_list[x].replace(
                        '.', '') + ' ' + my_list[x + 1].replace('.', '')
                JSONresult += '{ "name":"' + my_list[x].replace('.', '') + ' ' + my_list[x + 1].replace('.', '') + '"'\
                    ',"grade":"' + grade + '" }'
                lastParseNeedsAND = True

        # for the XXXX major required type of thing
        elif x + 1 < len(my_list) and len(my_list[x]) == 4 and "major" in my_list[x + 1]:
            if lastParseNeedsAND:
                result = result.strip() + ' and '
                resultCount += 1
                JSONresult += '],"Course' + str(resultCount) + '": ['
            
            if JSONresult[len(JSONresult)-1] == '}':
                  JSONresult += ','
                  
            JSONresult += '{ "major":"' + my_list[x].replace(
                '.', '') + ' ' + my_list[x + 1].replace('.', '') + '"}'
            result = result.strip() + ' ' + \
                my_list[x].replace('.',
                                   '') + ' ' + my_list[x + 1].replace('.',
                                                                      '') + ' '
            lastParseNeedsAND = True

        currentItemUpper = my_list[x].upper()

        # For some reason the university likes to say that this class is
        # cross-listed with another one. This is useless to us
        if currentItemUpper.upper() == 'CROSS-LISTED':
            crossListed = True

        # Here we need to check to make sure they meet the GPA or hour
        # requirements.
        if ((isReal(currentItemUpper) or currentItemUpper.isdigit())
                and len(currentItemUpper.replace('.', '')) < 4):
            if x + 1 < len(my_list) and ('hour' in my_list[x + 1]
                                         or 'hr' in my_list[x + 1]):
                result = result.strip() + ' ' + currentItemUpper + ' HOURS '
                if JSONresult[len(JSONresult) - 1] == '}':
                    JSONresult += '],"Course' + str(resultCount) + '": ['
                JSONresult += '{ "hours":"' + currentItemUpper + '"}'
                lastParseNeedsAND = True
            elif 'GPA' in my_list or 'GPA.' in my_list or 'grade point' in my_list:
                result = result.strip() + ' and ' + currentItemUpper + ' GPA'

                resultCount += 1
                JSONresult += '],"Course' + str(resultCount) + '": ['

                JSONresult += '{ "GPA": ' + currentItemUpper + '}'
                lastParseNeedsAND = True

        # Instead of providing an hour requirement sometimes they like to
        # include what grade level you should be.
        if currentItemUpper == 'SENIOR' or currentItemUpper \
                == 'JUNIOR' or currentItemUpper == 'SOPHOMORE' \
                or currentItemUpper == 'FRESHMAN' or 'CANDIDACY' in currentItemUpper \
                or 'CONSENT' in currentItemUpper or 'GRADUATE' in currentItemUpper or 'PHD' in currentItemUpper \
                or 'HIGHER' in currentItemUpper or 'EQUIVALENT' in currentItemUpper:
            lastParseNeedsAND = True
            if currentItemUpper not in result:
                tempArray = (result.strip()).split(' ')
                if result.strip() != '' and (tempArray[len(tempArray) -1] != 'or' and result.strip() != 'or') and (
                    tempArray[len(tempArray) -1] != 'and' and result.strip() != 'and'):
                      result = result.strip() + ' or '
                      JSONresult += ','
                if JSONresult[len(JSONresult)-1] == '}':
                  JSONresult += ','
                
                JSONresult += '{ "name":"' + currentItemUpper.replace('.', '') + '"}'
                result = result.strip() + ' ' + currentItemUpper.replace('.', '')
        
        if 'LAB' in currentItemUpper:
          if not (x - 1 > 0 and (my_list[x - 1])[:4].isdigit()):
            JSONresult += '{ "name":"LAB"}'
        elif 'DRILL' in currentItemUpper:
          JSONresult += '{ "name":"DRILL"}'
        
        # The university likes to put this inbetween classes. Sometimes they
        # like to put it in sentences too
        if currentItemUpper == 'OR':
            lastParseNeedsAND = False
            # We want to make sure that the last entry is not an OR before we add another OR
            # Also we want to make sure result is not empty and we add an "OR"
            # to nothing
            tempArray = (result.strip()).split(' ')
            if result.strip() != '' and tempArray[
                    len(tempArray) - 1] != 'or' and result.strip() != 'or':
                # We also want to make sure the last result wasn't an AND
                if tempArray[
                        len(tempArray) -
                        1] != 'and' and result.strip() != 'and':
                    result = result.strip() + ' or '
                    JSONresult += ','
        elif currentItemUpper == 'AND':
            lastParseNeedsAND = False
            tempArray = (result.strip()).split(' ')
            if tempArray[
                    len(tempArray) - 1] != 'and' and result.strip() != 'and':
                result = result.strip() + ' and '
                resultCount += 1
                JSONresult += '],"Course' + str(resultCount) + '": ['

    # it's gotten to the point it's this is just the best I can do
    result = result.replace('and and', 'and')
    result = result.replace('or or', '')
    result = result.replace('or and', 'and')
    result = result.replace('and or', 'and')

    # Now we should check if the first word or the last word is "AND/OR"
    result = result.strip().split(' ')
    if len(result) > 0 and ("and" in result[0] or "or" in result[0]):
        result.pop(0)
    elif len(result) > 0 and ("and" in result[len(result) - 1] or "or" in result[len(result) - 1]):
        result.pop(len(result) - 1)
    result = ' '.join(result)

    JSONresult += "]}"
    JSONresult = JSONresult.replace(',]', ']')
    # print(JSONresult)
    
    r = (json.loads(JSONresult))
    # print(json.dumps(r, sort_keys=True, indent=4))

    returnValue = JSONresult

    return returnValue


# preReqFile = open('PreReq.txt', 'r')
# coReqFile = open('CoReq.txt', 'r')

# while True:
#     prereq = preReqFile.readline()
#     if not prereq:
#         break
#     # print(prereq)
#     print(parseClassRequirements(prereq))

# while True:
#     coreq = coReqFile.readline()
#     if not coreq:
#       break
    
#     # print(coreq)
#     print(parseClassRequirements(coreq))
    

print("Start: " + str(datetime.datetime.now()))

scheduleURL = 'https://scheduleofclasses.uark.edu/Main?strm=1149&Search='
scheduleData = requests.get(scheduleURL)
scheduleContent = scheduleData.content
soup = BeautifulSoup(scheduleContent)
table = soup.find("table")
rows = table.find_all('tr')
i = 0
for row in rows:
  result = 'Section.create('
  cells = row.find_all("td")
  if len(cells) > 0:
    result += "status: '" +  cells[0].get_text() + "',"
    result += "courseID: '" +  cells[1].get_text() + "',"
    result += "title: '" +  cells[2].get_text().replace("'","") + "',"
    result += "component: '" +  cells[3].get_text().replace("'","") + "',"
    result += "session: '" +  cells[4].get_text() + "',"
    result += "hour: '" + cells[5].get_text() + "',"
    result += "classNumber: '" + cells[6].get_text() + "',"
    result += "startDate: '" + cells[7].get_text() + "',"
    result += "endDate: '" + cells[8].get_text() + "',"
    result += "classTime: '" + cells[9].get_text().replace('\xa0', ';') + "',"
    result += "location: '" + cells[10].get_text() + "',"
    result += "instructor: '" + cells[11].get_text().replace("'", "\\'") + "',"
    result += "enrolled: '" + cells[12].get_text().split('/')[0] + "',"
    result += "size: '" + cells[12].get_text().split('/')[0] + "',"
    result += "career: '" + cells[13].get_text() + "',"
    result += "school: '" + cells[14].get_text() + "',"
    result += "department: '" + cells[15].get_text() + "',"
    result += "campus: '" + cells[16].get_text() + "'"
  
  result += ')\n'
  # currentRow += '\n'
  
  # if i>100:
    # break
  i += 1
  if result != 'Section.create(':
    with open("seeds.rb", "a") as sectionFile:
      sectionFile.write(result)
  

# catalogURL = 'http://catalog.uark.edu/undergraduatecatalog/coursesofinstruction/'
# catalogData = requests.get(catalogURL)
# catalogContent = catalogData.content

# soup = BeautifulSoup(catalogContent)

# soup.select(".sitemaplink")

# myfile = open("seeds.rb", "a")
# for link in soup.select(".sitemaplink"):
#  majorURL = 'http://catalog.uark.edu/' + link['href']
#  majorData = requests.get(majorURL)
#  majorContent = majorData.content
#  majorSoup = BeautifulSoup(majorContent)
#  courses = majorSoup.select(".courseblock")

#  for course in courses:
#     courseBlockTitle = course.select(".courseblocktitle")[0].get_text().strip().replace(' ',' ')
#     courseBlockDescription = course.select(".courseblockdesc")[0].get_text().strip().replace(' ',' ')
#     courseBlockDescription = courseBlockDescription.replace("'", "")
#     courseBlockTitle = courseBlockTitle.replace("'", "")
#     # if "student's" in courseBlockDescription:
#     #   print(courseBlockDescription)
#     #   break
#     courseDescriptionAndPreCoReq = courseBlockDescription.split("Corequisite:")
#     courseDescription = courseDescriptionAndPreCoReq[0].strip().replace("'", "\'")
    
#     coReq = ''
#     preReq = ''

#     if len(courseDescriptionAndPreCoReq) >1:
#       preAndCoReq = courseDescriptionAndPreCoReq[1].strip().split('Prerequisite')
#       coReq = preAndCoReq[0].replace(':','').strip().replace("'","\'")
#       if len(preAndCoReq) >1:
#        preReq = preAndCoReq[1].replace("'","\'")
#     elif "Prerequisite" in courseDescription:
#       preReq = courseBlockDescription.split("Prerequisite")[1].replace(':','').strip()
      
#     myfile.write("Course.create(title: '" + courseBlockTitle + "', description: '" + courseDescription.replace("'","\'").replace("'", "\'") + "', coreqDesc: '" + coReq + "', coreqData: '" + parseClassRequirements(coReq.replace('\n',' ')) + "', prereqDesc: '" + preReq + "', prereqData: '" + parseClassRequirements(preReq.replace('\n',' '))+ "')\n")
      
      # myfile.write(courseBlockTitle + "\n" + courseDescription + "\n" + coReq + "\n" + preReq + "\n\n")
      # coreq.write() + "\n")
      # prereqFile.write(+ "\n")
        

print("End: " + str(datetime.datetime.now()))


class Schedule
    attr_accessor :arrOfSections
    
    def initialize(arrOfSections)  
        @arrOfSections = []
        @arrOfSections = arrOfSections
    end  
    
    def addSection(courseSection)
        @arrOfSections.push(courseSection)
    end
    def self.findTime(timeArray, startingLocation, start, finish)
        i = startingLocation + 1
        currentTime = 0
        cont = true
        while cont
            if timeArray[i].chr =~ /;/
                numb = timeArray[i].delete(";")
                currentTime = currentTime + Integer(numb)*60
                cont = false
                #puts "numb " + numb
            end
            i = i + 1
        end
        currentTime = currentTime + Integer(timeArray[i])
        i = i + 1
        if timeArray[i].chr == 'P' && Integer(numb) < 12
            currentTime = currentTime + 720
        end
        start << currentTime.to_s
        i = i  + 2
        numb = timeArray[i]
        #puts "numb " + numb
        currentTime = Integer(numb)*60
        i = i + 1
        currentTime = currentTime + Integer(timeArray[i])
        i = i + 1
        if timeArray[i].chr == 'P' && Integer(numb) < 12
            currentTime = currentTime + 720
        end
        finish << currentTime.to_s
    end
    def self.genereateSchedules(arrOfCourses)
        if arrOfCourses.length == 0
            return
        else 
            currentSchedules = Array.new
            nextSchedules = Array.new
            temporarySections = Array.new
            for i in 0..arrOfCourses.length-1
                currentSchedules = Marshal.load(Marshal.dump(nextSchedules))
                temporarySections = Array.new
                nextSchedules = Array.new
                puts arrOfCourses[i].name
                puts currentSchedules.length
                tempName = arrOfCourses[i].name.split
                tempName[0] = tempName[0]+tempName[1]
                temporarySections = Section.where(name: tempName[0])
            
                if i == 0
                    temporarySections.each do |section|
                        if !(section.component.include? "Drill") && !(section.component.include? 'Laboratory') && !(section.career.include? 'GRAD')
                            
                            tempScheduleSections = Array.new
                            tempScheduleSections[0] = section
                            tempSchedule = Schedule.new(tempScheduleSections)
                            nextSchedules.push(tempSchedule)
                            #puts "Made one"
                        end
                    end
                else
                if currentSchedules.length == 0
                    return currentSchedules
                end
                    temporarySections.each do |section|
                        if !(section.component.include? "Drill") && !(section.component.include? 'Laboratory') && !(section.career.include? 'GRAD')
                            currentSchedules.each do |schedule|
                                canAdd = true
                                schedule.arrOfSections.each do |sectionToCheck|
                                    sectionTimes = section.classTime.split(/ |, |,|:/)
                                    for i in 0..sectionTimes.length - 1
                                        if sectionTimes[i].include? "Mon"
                                            startTime = String.new
                                            endTime = String.new
                                            Schedule.findTime(sectionTimes, i, startTime, endTime)
                                            if sectionToCheck.classTime.include? "Mon"
                                                sectionToCheckTimes = sectionToCheck.classTime.split(/ |, |,|:/)
                                                for j in 0..sectionToCheckTimes.length
                                                    if sectionToCheckTimes[j] != nil
                                                        if sectionToCheckTimes[j].include? "Mon"
                                                            checkStartTime = String.new
                                                            checkEndTime = String.new
                                                            Schedule.findTime(sectionToCheckTimes, j, checkStartTime,checkEndTime)
                                                            intStartTime = Integer(startTime)
                                                            intEndTime = Integer(endTime)
                                                            intCheckStartTime = Integer(checkStartTime)
                                                            intCheckEndTime = Integer(checkEndTime)
                                                            if (intStartTime <= intCheckStartTime && intCheckStartTime <= intEndTime) or (intStartTime <= intCheckEndTime && intCheckEndTime <= intEndTime)
                                                                canAdd = false
                                                                #puts "colision found"
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                            if sectionTimes[i].include? "Tue"
                                                startTime = String.new
                                                endTime = String.new
                                                Schedule.findTime(sectionTimes, i, startTime, endTime)
                                               
                                                if sectionToCheck.classTime.include? "Tue"
                                                    sectionToCheckTimes = sectionToCheck.classTime.split(/ |, |,|:/)
                                                    
                                                    for j in 0..sectionToCheckTimes.length - 1
                                                        if sectionToCheckTimes[j].include? "Tue"
                                                            checkStartTime = String.new
                                                            checkEndTime = String.new
                                                            Schedule.findTime(sectionToCheckTimes, j, checkStartTime,checkEndTime)
                                                            intStartTime = Integer(startTime)
                                                            intEndTime = Integer(endTime)
                                                            intCheckStartTime = Integer(checkStartTime)
                                                            intCheckEndTime = Integer(checkEndTime)
                                                            
                                                            if (intStartTime <= intCheckStartTime && intCheckStartTime <= intEndTime) or (intStartTime <= intCheckEndTime && intCheckEndTime <= intEndTime)
                                                                canAdd = false
                                                                #puts "colision found"
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                            if sectionTimes[i].include? "Wed"
                                                startTime = String.new
                                                endTime = String.new
                                                Schedule.findTime(sectionTimes, i, startTime, endTime)
                                                if sectionToCheck.classTime.include? "Wed"
                                                    sectionToCheckTimes = sectionToCheck.classTime.split(/ |, |,|:/)
                                                    for j in 0..sectionToCheckTimes.length - 1
                                                        if sectionToCheckTimes[j].include? "Wed"
                                                            checkStartTime = String.new
                                                            checkEndTime = String.new
                                                            Schedule.findTime(sectionToCheckTimes, j, checkStartTime,checkEndTime)
                                                            intStartTime = Integer(startTime)
                                                            intEndTime = Integer(endTime)
                                                            intCheckStartTime = Integer(checkStartTime)
                                                            intCheckEndTime = Integer(checkEndTime)
                                                            
                                                            if (intStartTime <= intCheckStartTime && intCheckStartTime <= intEndTime) or (intStartTime <= intCheckEndTime && intCheckEndTime <= intEndTime)
                                                                canAdd = false
                                                                #puts "colision found"
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                            if sectionTimes[i].include? "Thu"
                                                startTime = String.new
                                                endTime = String.new
                                                Schedule.findTime(sectionTimes, i, startTime, endTime)
                                                if sectionToCheck.classTime.include? "Thu"
                                                    sectionToCheckTimes = sectionToCheck.classTime.split(/ |, |,|:/)
                                                    for j in 0..sectionToCheckTimes.length - 1
                                                        if sectionToCheckTimes[j].include? "Thu"
                                                            checkStartTime = String.new
                                                            checkEndTime = String.new
                                                            Schedule.findTime(sectionToCheckTimes, j, checkStartTime,checkEndTime)
                                                            intStartTime = Integer(startTime)
                                                            intEndTime = Integer(endTime)
                                                            intCheckStartTime = Integer(checkStartTime)
                                                            intCheckEndTime = Integer(checkEndTime)
                                                            
                                                            if (intStartTime <= intCheckStartTime && intCheckStartTime <= intEndTime) or (intStartTime <= intCheckEndTime && intCheckEndTime <= intEndTime)
                                                                canAdd = false
                                                                #puts "colision found"
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                            if sectionTimes[i].include? "Fri"
                                                startTime = String.new
                                                endTime = String.new
                                                Schedule.findTime(sectionTimes, i, startTime, endTime)
                                                if sectionToCheck.classTime.include? "Fri"
                                                    sectionToCheckTimes = sectionToCheck.classTime.split(/ |, |,|:/)
                                                    for j in 0..sectionToCheckTimes.length - 1
                                                        if sectionToCheckTimes[j].include? "Fri"
                                                            checkStartTime = String.new
                                                            checkEndTime = String.new
                                                            Schedule.findTime(sectionToCheckTimes, j, checkStartTime,checkEndTime)
                                                            intStartTime = Integer(startTime)
                                                            intEndTime = Integer(endTime)
                                                            intCheckStartTime = Integer(checkStartTime)
                                                            intCheckEndTime = Integer(checkEndTime)
                                                            
                                                            if (intStartTime <= intCheckStartTime && intCheckStartTime <= intEndTime) or (intStartTime <= intCheckEndTime && intCheckEndTime <= intEndTime)
                                                                canAdd = false
                                                                #puts "colision found"
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                    end
                                end
                                #puts canAdd
                                if(canAdd == true)
                                tempSchedule = Marshal.load(Marshal.dump(schedule))
                                tempSchedule.addSection(section)
                                nextSchedules.push(tempSchedule)
                                    if(nextSchedules.length >= 1000)
                                        break
                                    end
                                end
                                
                            end
                            
                        end
                        
                   end
                end
            end
            return nextSchedules
        end
    end
end
courses = Array.new
courses[0] = Course.find_by(name: 'MATH 1204')
courses[1] = Course.find_by(name: 'COMM 1313')
courses[2] = Course.find_by(name: 'PHYS 2054')
courses[3] = Course.find_by(name: 'ENGL 1013')
courses[4] = Course.find_by(name: 'ENGL 1023')
schedules = Schedule.genereateSchedules(courses)
puts schedules.length
=begin
if schedules.length > 0
    for k in 0..schedules.length - 1
        puts "Current Schedule"
        for j in 0..schedules[k].arrOfSections.length - 1
                puts schedules[k].arrOfSections[j].name
                puts schedules[k].arrOfSections[j].classTime
        end
        puts "\n\n"
    end
end
=end
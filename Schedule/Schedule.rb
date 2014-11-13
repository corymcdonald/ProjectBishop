Class Schedule
def arrOfSections
    @arrOfSections
end

def arrOfSections=(value)
    @arrOfSections = value
end
def initialize(arrOfSections)  
    # Instance variables  
    @arrOfSections = arrOfSections
end  
def addSection(courseSection)
    @arrOfSections.push(courseSection)
end
def findTime(timeArray, startingLocation, start, finish)
    i = starting time + 1
    currentTime = 0
    while i != timeArray.length do
        if timeArray[i].chr < 10 && timeArray[i].chr > 0
            currentTime = currentTime + Integer(timeArray[i].chr)*60
            break
        end
    end
    i = i + 1
    currentTime = currentTime + Integer(timeArray[i])
    i = i + 1
    if timeArray[i].chr == 'P'
        currentTime = currentTime + 720
    end
    start << currentTime
    i = i + 1
    currentTime = Integer(timeArray[i])*60
    i = i + 1
    if timeArray[i].chr == 'P'
        currentTime = currentTime + 720
    end
    finish << currentTime
end
def genereateSchedules(arrOfCourses)
    if arrOfCourses.length == 0
        return
    else 
        currentSchedules = Array.new
        nextSchedules = Array.new
        temporarySections = Array.new
        for i in 0..5
            currentSchedules = nextSchedules
            temporarySections = Array.new
            nextSchedules = Array.new
        
            if i == 0
                temporarySections = courses.where(title: arrOfCourses.get(i).title).order('created_at DESC')
                temporarySections.each do |section|
                    nextSchedules.push(Schedule.new(section))
                end
            elsif i < 5
                temporarySections = courses.where(title: arrOfCourses.get(i).title).order('created_at DESC')
                temporarySections.each do |section|
                    canAdd = true
                    currentSchedules.each do |schedule|
                        schedule.arrOfSections.each do |sectionToCheck|
                            sectionTimes = section.classTime.split(/ |, |,|:/)
                            for i in sectionTimes.length
                                if sectionTimes[i].include? "Mon"
                                    startTime = null
                                    endTime = null
                                    findTime(sectionTimes, i, s)
                                end
                                if sectionTimes[i].include? "Tue"
                                    startTime = null
                                    endTime = null
                                    findTime(sectionTimes, i, s)
                                end
                                if sectionTimes[i].include? "Wed"
                                    startTime = null
                                    endTime = null
                                    findTime(sectionTimes, i, s)
                                end
                                if sectionTimes[i].include? "Thu"
                                    startTime = null
                                    endTime = null
                                    findTime(sectionTimes, i, s)
                                end
                                if sectionTimes[i].include? "Fri"
                                    startTime = null
                                    endTime = null
                                    findTime(sectionTimes, i, s)
                                end
                            end
                            #Add logic to add schedules here, unsure how exactly the start and end times will be stored
                            #Probably something like go through all the days the sectionToCheck has, and see if the section is on that day. If so, see if the times overlap. If they do set the bool to false
                        end
                    #if the bool is still true, push a new schedule that is the previous and the new section
                    end
                end
            else
                #Handle breaks
            end
        end
        return nextSchedules
    end
end
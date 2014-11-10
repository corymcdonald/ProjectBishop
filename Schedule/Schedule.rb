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
def genereateSchedules(arrOfCourses)
    if arrOfCourses.length == 0
        return
    else 
        currentSchedules = null
        nextSchedules = null
        temporarySections = null
        for i in 0..5
            currentSchedules = nextSchedules
            temporarySections = null
            nextSchedules = null
        
            if i == 0
                temporarySections = courses.where(title: arrOfCourses.get(i).title).order('created_at DESC')
                temporarySections.each do |section|
                    nextSchedules.push(section)
                end
            elsif i <5
                temporarySections = courses.where(title: arrOfCourses.get(i).title).order('created_at DESC')
                temporarySections.each do |section|
                    #canAdd = true
                    currentSchedules.each do |schedule|
                        schedule.arrOfSections.each do |sectionToCheck|
                            #Add logic to add schedules here, unsure how exactly the start and end times will be stored
                            #Probably something like go through all the days the sectionToCheck has, and see if the section is on that day. If so, see if the times overlap. If they do set the bool to false
                        end
                    #if the bool is still true, push a new schedule that is the previous and the new section
                    end
                end
            else
                
            end
        end
        return nextSchedules
    end
end
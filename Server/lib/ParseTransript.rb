
class parseTranscript
  
  def initialize()

  end
  
  def parseIt(source)
    userCourses = []
    
    str.each_line do |line|
      course = line.match(/^[A-Z]{4}\s*\d{1,4}./)
      grade = line.match(/[.]\d\d [A-Z]./)
      if course and grade
        course = course.to_s.sub('     ',' ')
        grade = grade.to_s.sub('.00','')
        userCourses.push("course" = > course, "grade"=>grade)
      end
    end
    
    return userCourses
    
  end
end
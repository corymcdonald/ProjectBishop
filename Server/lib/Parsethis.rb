class Parsethis
  
  def initialize()

  end
  
  def self.parseIt(source,current_user)
    Rails.logger = Logger.new(STDOUT)

    userCourses = []
    
    
    source.each_line do |line|
      course = line.match(/^[A-Z]{4}\s*\d{1,4}./)
      grade = line.match(/[.]\d\d [A-Z]./)
      Rails.logger.info "Current line [" + line + "]"
      Rails.logger.info course
      Rails.logger.info grade
      if course and grade
        course = course.to_s.sub('     ',' ')
        grade = grade.to_s.sub('.00','')
        @usercourse = Usercourse.new("user"=> current_user.id, "course" => course.strip, "grade"=>grade.strip)
        @usercourse.save
      elsif course
        course = course.to_s.sub('     ',' ')
        @usercourse = Usercourse.create("user"=> current_user.id, "course" => course.strip, "grade"=>'pending')
        @usercourse.save
        
      end
    end
    
    return userCourses
    
  end
end
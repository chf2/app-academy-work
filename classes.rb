class Student
  attr_reader :first_name, :last_name, :enrolled_courses

  def initialize(first_name, last_name)
    @first_name = first_name
    @last_name = last_name
    @enrolled_courses = []
  end

  def name
    first_name + ' ' + last_name
  end

  def enroll(course_object)
    unless enrolled_courses.include?(course_object)

      if has_conflict?(course_object)
        raise "That course conflicts with your schedule"
      end

      enrolled_courses << course_object
      course_object.add_student(self)
    end
  end

  def has_conflict?(course_object)
    enrolled_courses.any? { |el| el.conflicts_with?(course_object) }
  end

  def courses
    enrolled_courses.map(&:name)
  end

  def course_load
    course_load_hash = {}
    enrolled_courses.each do |course|
      key = course.department.to_sym
      course_load_hash[key] = 0 unless course_load_hash[key]
      course_load_hash[key] += course.credits
    end

    course_load_hash
  end

end

class Course
  attr_reader :name, :department, :credits, :enrolled_students, :days, :block

  def initialize(name, department, credits, days, block)
    @name = name    #string
    @department = department  # string
    @credits = credits   #fixnum
    @days = days  # array
    @block = block   # fixnum
    @enrolled_students = []
  end

  def conflicts_with?(course_obj)
    if block == course_obj.block
      return true if !(days & course_obj.days).empty?
    end
    false
  end

  def students
    enrolled_students.map(&:name)
  end

  def add_student(student_object)
    enrolled_students << student_object
  end
end

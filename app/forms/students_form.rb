class StudentsForm
  include ActiveModel::Model

  attr_accessor :students

  def initialize(students)
    @students = students
  end

  def update(params)
    students.each_with_index do |student, i|
      student_param = params[i]
      student.update(real_name: student_param[:real_name])
    end
  end
end

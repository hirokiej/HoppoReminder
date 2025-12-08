class StudentsForm
  include ActiveModel::Model

  attr_accessor :students

  def initialize(students)
    @students = students
  end

  def update(params)
    params.each do |student_param|
      student = students.find { |s| s.id == student_param[:id].to_i }
      student.real_name = student_param[:real_name]
      student.update(real_name: student_param[:real_name]) if student.changed?
    end
  end
end

class StudentsForm
  include ActiveModel::Model

  def initialize(students)
    @students = students
  end

  def update(params)
    any_changes = false

    params.each do |student_param|
      student = @students.find { |s| s.id == student_param[:id].to_i }
      student.real_name = student_param[:real_name]

      if student.changed?
        student.save
        any_changes = true
      end
    end
    any_changes
  end
end

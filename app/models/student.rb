class Student < ApplicationRecord
  belongs_to :admin
  has_many :schedules, dependent: :destroy

  validates :real_name, presence: true, uniqueness: true

  def self.identify_from_summary(event, students)
    students.detect do |student|
      event[:summary].to_s.include?(student.real_name)
    end
  end
end

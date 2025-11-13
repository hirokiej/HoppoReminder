class Student < ApplicationRecord
  belongs_to :admin
  has_many :schedules, dependent: :destroy

  scope :with_real_name, -> { where.not(real_name: [ nil, '' ]) }

  def self.find_real_name(event, students)
    students.with_real_name.detect do |student|
      event[:summary].to_s.include?(student.real_name)
    end
  end
end

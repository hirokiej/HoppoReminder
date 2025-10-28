class Student < ApplicationRecord
  belongs_to :admin
  has_many :schedules, dependent: :destroy
end

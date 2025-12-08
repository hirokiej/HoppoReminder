# frozen_string_literal: true

seeds = [
  Rails.root.join('db/seeds/admins.rb'),
  Rails.root.join('db/seeds/students.rb'),
  Rails.root.join('db/seeds/schedules.rb')
]

seeds.each { |file| load(file) }

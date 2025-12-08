Admin.all.each do |admin|
  10.times do |i|
  Student.create!(
    admin: admin,
    line_user_id: "line_user_id_#{admin.id}_#{i}",
    line_display_name: "生徒LINE#{i + 1}",
    real_name: "せいと#{i +1}"
  )
  end
end

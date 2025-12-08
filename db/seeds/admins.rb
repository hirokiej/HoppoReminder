Admin.destroy_all

admin = Admin.create!(
  name: "ピアノの先生",
  email: "admin@example.com",
  line_channel_access_token: "123456789",
  line_channel_id: "123456789",
  line_channel_secret: "123456789",
)

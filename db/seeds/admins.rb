Admin.destroy_all

admin = Admin.create!(
  name: "ピアノの先生",
  email: "admin@example.com",
  google_token: "google_token",
  google_refresh_token: "google_refresh_token",
  line_channel_id: "line_channel_id",
  line_channel_secret: "line_channel_secret",
  line_channel_access_token: "line_channel_access_token"
)

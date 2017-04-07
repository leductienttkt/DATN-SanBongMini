class Admin::HomeController < AdminController
  def index
    @users = User.by_date_newest
      .take Settings.admin.dashboard.max_items
    @pitches = Pitch.by_date_newest
      .take Settings.admin.dashboard.max_items
    @mini_pitches = MiniPitch.by_date_newest
      .take Settings.admin.dashboard.max_items
  end
end

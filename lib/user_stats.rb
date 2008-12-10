module UserStats

  def update_user_edit_stats(report = false)
    @user = User.find(current_user.id)
    if report
      @user.reports += 1
    else
      @user.edits += 1
    end
    @user.last_track_edit_at = Time.now
    @user.save
  end

end
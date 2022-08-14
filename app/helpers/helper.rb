class Helper


  def self.redirect_if_not_logged_in(session)
    if !self.logged_in?(session) && User.find_by(id: session[:user_id]).nil?
      redirect "/user/error"
    end
  end

  def self.logged_in?(session)
    !!session[:user_id]
  end

  def self.current_user(session)
    User.find(session[:user_id])
  end
end

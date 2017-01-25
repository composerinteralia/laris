module CSRF
  def form_authenticity_token
    @token ||= SecureRandom.urlsafe_base64
  end

  def verify_authenticity
    unless session_auth_token == form_auth_token
      raise "Invalid Authenticity Token"
    end
  end

  private
  def form_auth_token
    params['authenticity_token']
  end

  def set_session_auth_token
    session['authenticity_token'] = form_authenticity_token
  end

  def session_auth_token
    session['authenticity_token']
  end
end

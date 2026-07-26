module AuthHelper
  def decode_token(token, secret)
    JWT.decode(token, secret, true, algorithm: 'HS256')[0]
  rescue
    nil
  end

  def generate_auth_token(user)
    payload = {
      user_id: user.id,
      email: user.email,
      role: user.class.name,
      type: 'auth'
    }
    JWT.encode(payload, ENV['SECRET_KEY_BASE'], 'HS256')
  end

  def generate_refresh_token(user)
    payload = {
      user_id: user.id,
      type: 'refresh'
    }
    JWT.encode(payload, ENV['REFRESH_KEY_BASE'], 'HS256')
  end
end
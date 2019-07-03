# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#

class User < ApplicationRecord
    attr_reader :password
    validates :username, :password_digest, :session_token, uniqueness: true, presence: true
    validates :password, length: { minimum: 6, allow_nil: true }

    after_initialize :ensure_session_token

    def self.generate_session_token
      SecureRandom.urlsafe_base64
    end
    
    def self.find_by_credentials(user_name, password)
      user = User.find_by(username: user_name)
      return user if user && user.is_password?(password)
      nil
    end
    
    def reset_session_token!
      token = User.generate_session_token
      self.session_token = token
      self.update!(session_token: token)
      token
    end

    def ensure_session_token
      self.session_token ||= self.reset_session_token!
    end


    def password=(password)
      @password = password
      self.password_digest = BCrypt::Password.create(password)
    end

    def is_password?(password)
      password_digest = BCrypt::Password.new(self.password_digest)
      password_digest.is_password?(password)
    end




end

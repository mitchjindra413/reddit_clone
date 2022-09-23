class User < ApplicationRecord
    before_validation :ensure_session_token

    attr_reader :password

    def self.find_by_credentials(username, password)
        @user = User.find_by_usernmae(username)
        if @user && @user.is_password?(password)
            @user
        else
            nil
        end
    end

    def password=(password)
        self.password_digest = BCrypt::Password.create(password)
        @password = password
    end

    def is_password?(password)
        password_obj = BCrypt::Password.new(password)
        password_obj.is_password?(password)
    end

    def reset_session_token!
        self.session_token = SecureRandom.urlsafe_base64(16)
        self.save!
        self.session_token
    end

    def ensure_session_token
        self.session_token ||= SecureRandom.urlsafe_base64(16)
    end
end

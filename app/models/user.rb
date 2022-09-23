# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string           not null
#  session_token   :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
    before_validation :ensure_session_token

    validates :username, :password_digest, :session_token, presence:true
    validates :username, :session_token, uniqueness:true

    validates :password, length: {minimum:8 }, allow_nil:true

    has_many :subs, foreign_key: :moderator_id, class_name: :Sub, inverse_of: :moderator

    has_many :posts, foreign_key: :author_id, class_name: :Post

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

class User < ActiveRecord::Base
     before_save {self.email = email.downcase}
     validates :firstName,  presence: true, length: {maximum: 30}
     #validates :lastName,  presence: true, length: {maximum: 30}
     VALID_EMAIL_REGEX = /\A[\w+\-%.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
     validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: {case_sensitive: false}
     has_secure_password
     validates :password, length: {minimum: 8}
end

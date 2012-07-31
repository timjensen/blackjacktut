class User < ActiveRecord::Base
  attr_accessible :name, :password, :password_confirmation, :bankroll
  has_secure_password
  
  validates :name, presence: true, length: { maximum: 25 },  uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  
  before_save :create_remember_token
  
  private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end

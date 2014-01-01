class User < ActiveRecord::Base
  has_secure_password

  has_many :hands

  before_create :create_remember_token

  def retrieve_money request
    bank = self.funds - request.to_i
    self.update_attribute(:funds, bank.to_i)
    self.update_attribute(:money_in_play, self.money_in_play.to_i + request.to_i) 
  end

  def self.create_guest
    self.create! do |user|
      user.guest = true
      user.set_password
    end 
  end

  def set_password
    password_string = SecureRandom.urlsafe_base64
    self.password = password_string
    self.password_confirmation = password_string 
  end

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end

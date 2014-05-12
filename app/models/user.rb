class User < ActiveRecord::Base
  include Sluggable
  
  has_many :posts
  has_many :comments
  has_many :votes, as: :voteable
  
  has_secure_password validations: false
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, on: :create

  sluggable_column :username
  
  def two_factor_auth?
    !self.phone.blank?
  end

  def generate_pin!
    self.update_column(:pin, rand(10**6)) #random 6 digit number
  end

  def remove_pin!
    self.update_column(:pin, nil)
  end

  def send_pin_to_twilio
    account_sid = 'AC3a7d1f6b76ade51b06c798c0c1fe0a9b' 
    auth_token = 'a3548ab0ed22beab93ce0acae9ed77a9' 
 
    # set up a client to talk to the Twilio REST API 
    client = Twilio::REST::Client.new account_sid, auth_token 
    msg = "Hi, please input the pin to continute login: #{self.pin}"
    client.account.messages.create({
      :from => '+15622757362', 
      :to => '3107078800', 
      :body => msg,  
    })
  end

  def admin?
    self.role.to_s.to_sym == :admin
  end


end 
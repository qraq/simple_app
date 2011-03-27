require 'digest'

class User < ActiveRecord::Base

attr_accessible(:name, :email, :password, :password_confirmation)
attr_accessor :password
validates :name, :presence => true, :length => {:maximum =>50}
                
  valid_mail =  /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

validates :email, :presence => true, :format => {:with => valid_mail},
                  :uniqueness => { :case_sensitive => true }
validates :password, :presence => true, :confirmation => true,
            :length => {:within => 6..40}
          
  
  before_save :encrypt_password
  
  # Return true if the user's password matches the submitted password.
def has_password?(submitted_password)
  encrypted_password  ==  encrypt(submitted_password)  
end

  
  private 
  
  def encrypt_password
    self.salt = make_salt if new_record?
    self.encrypted_password = encrypt(password)
  end
  
  def make_salt
    secure_hash("#{Time.now.utc}--#{password}")
  end
  
  def encrypt(string)
    secure_hash("#{salt}--#{string}")
  end
  
  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end

end

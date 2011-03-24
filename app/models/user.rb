class User < ActiveRecord::Base
attr_accessible(:name, :email)
validates :name, :presence => true, :length => {:maximum =>50}
                
  valid_mail =  /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

validates :email, :presence => true, :format => {:with => valid_mail},
                  :uniqueness => { :case_sensitive => true }
           
end

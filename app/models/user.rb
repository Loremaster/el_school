# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  user_login         :string(255)
#  user_role          :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#

class User < ActiveRecord::Base
  attr_accessor :password                                                     #Creating virtual attribute
  attr_accessible :user_login,                                                #ALL users can set these fields.
                  :user_role,
                  :password

  validates :user_login, :presence   => true,
                         :length     => { :maximum => 50 },
                         :uniqueness => true                                  #Warning! It doesn't guarantee that field ll be unique! Tho connection in same time still can create same data!

  validates :user_role, :presence  => true,
                        :inclusion => { :in => %w(admin teacher pupil class_head school_head) }

  validates :password, :presence  => true,
                       :length    => { :within => 6..40 }

  before_save :encrypt_password

  # Return true if the user's password matches the submitted password.
  def has_password?( submitted_password )
    encrypted_password == encrypt( submitted_password )
  end

  def self.authenticate( user_login, submitted_password )
    user = User.find_by_user_login ( user_login )
    return nil  if user.nil?
    return user if user.has_password?( submitted_password )
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end

  private
    def encrypt_password
      self.salt = make_salt if new_record?                                    #Here self means user, object of User's class.
      self.encrypted_password = encrypt( password )
    end

    def encrypt( string )
      secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash( string )
      Digest::SHA2.hexdigest(string)
    end
end

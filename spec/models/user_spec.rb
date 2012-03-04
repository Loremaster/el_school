# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  user_login :string(255)
#  user_role  :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe User do
  before(:each) do
      @attr = {
        :user_login => "Admin",
        :user_role => "admin"
      }
  end

  it "should create a new instance given valid attributes" do
      User.create!(@attr)
  end

  it "should require a login" do
    no_login_user = User.new( @attr.merge( :user_login => "" ) )
    no_login_user.should_not be_valid
  end

  it "should require non-empty role" do
    no_role_user = User.new( @attr.merge( :user_role => "" ) )
    no_role_user.should_not be_valid
  end

  it "should reject logins that are too long" do
      long_name = "a" * 51
      long_name_user = User.new( @attr.merge(:user_login => long_name) )
      long_name_user.should_not be_valid
  end

  it "should accept invalid names of roles" do
    role = %w(admin teacher pupil class_head school_head)
    role.each do |one_role|
      valid_email_user = User.new( @attr.merge( :user_role => one_role ) )
      valid_email_user.should be_valid
    end
  end

  it "should reject duplicate logins" do
    User.create!( @attr )
    user_with_duplicate_login = User.new( @attr )
    user_with_duplicate_login.should_not be_valid
  end
end

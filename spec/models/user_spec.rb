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

require 'spec_helper'

describe User do
  before(:each) do
      @attr = {
        :user_login => "Admin",
        :user_role => "admin",
        :password => "foobar"
      }
  end

  it "should create new user in database" do
      expect do
        user = User.new( @attr )
        user.user_role = "admin"
        user.save!
      end.should change( User, :count ).by( 1 )
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

  it "should accept valid names of roles" do
    role = %w(admin teacher pupil class_head school_head)
    role.each do |one_role| 
      valid_email_user = User.new( @attr )
      valid_email_user.user_role = one_role
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid names of roles" do
    role = %w(admin1 teacher1 pupil1 class_head1 school_head1)
    role.each do |one_role|
      invalid_email_user = User.new( @attr )
      invalid_email_user.user_role = one_role
      invalid_email_user.should_not be_valid
    end
  end

  it "should reject duplicate logins" do
    user = User.new( @attr )
    user.user_role = "admin"
    user.save!
    user_with_duplicate_login = User.new( @attr )
    user_with_duplicate_login.should_not be_valid
  end

  it "should reject too short passwords" do
    short_pass = %w(q qw qwe qwer qwert)
    short_pass.each do |each_pass|
      invalid_pass_user = User.new( @attr.merge( :password => each_pass ) )
      invalid_pass_user.should_not be_valid
    end
  end

  describe "password encryption" do
    before(:each) do
      @user = User.new( @attr )
      @user.user_role = "admin"
      @user.save!
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end


    describe "has_password? method" do
      it "should be true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end

      it "should be false if the passwords don't match" do
        @user.has_password?("invalid").should be_false
      end
    end

    describe "authenticate method" do
      it "should return nil on email/password mismatch" do
        wrong_password_user = User.authenticate(@attr[:user_login], "wrongpass")
        wrong_password_user.should be_nil
      end

      it "should return nil for an email address with no user" do
        nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
        nonexistent_user.should be_nil
      end

      it "should return the user on email/password match" do
        matching_user = User.authenticate(@attr[:user_login], @attr[:password])
        matching_user.should == @user
      end
    end
  end
end

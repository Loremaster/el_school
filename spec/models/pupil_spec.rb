# encoding: UTF-8
# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: pupils
#
#  id                            :integer         not null, primary key
#  user_id                       :integer
#  school_class_id               :integer
#  pupil_last_name               :string(255)
#  pupil_first_name              :string(255)
#  pupil_middle_name             :string(255)
#  pupil_birthday                :date
#  pupil_sex                     :string(255)
#  pupil_nationality             :string(255)
#  pupil_address_of_registration :string(255)
#  pupil_address_of_living       :string(255)
#  created_at                    :datetime        not null
#  updated_at                    :datetime        not null
#

require 'spec_helper'

describe Pupil do
  before(:each) do
    @user = Factory(:user)
    @school_class = Factory(:school_class)
    
    @attr_pupil = {
      :pupil_last_name => "Смирнов",
      :pupil_first_name => "Петр",
      :pupil_middle_name => "Петрович",
      :pupil_birthday => "#{Date.today - 10.years}",
      :pupil_sex => "m",
      :pupil_nationality => "Русский",
      :pupil_address_of_registration => "Москва, ул. Ленина, д. 1",
      :pupil_address_of_living => "Москва, ул. Ленина, д. 1",
      :school_class_id => @school_class.id
    }
  end
  
  describe "Creation" do
    it "should create pupil via user with valid attributes" do
      expect do
        @user.create_pupil( @attr_pupil ).should be_valid  
      end.should change( Pupil, :count ).by( 1 )
    end
  end
end

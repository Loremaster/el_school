# encoding: UTF-8
# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: teacher_phones
#
#  id                    :integer         not null, primary key
#  teacher_id            :integer
#  teacher_home_number   :string(255)
#  teacher_mobile_number :string(255)
#  created_at            :datetime        not null
#  updated_at            :datetime        not null
#

require 'spec_helper'

describe TeacherPhone do
  before(:each) do
    @user = Factory(:user)
    attr_teacher = {
        :teacher_last_name   => "Каров",
        :teacher_first_name  => "Петр",
        :teacher_middle_name => "Иванович",
        :teacher_birthday    => "01.12.1980",                                             #dd.mm.yyyy
        :teacher_sex         => "m",
        :teacher_category    => "1я Категория"
    }   
    @teacher = @user.build_teacher( attr_teacher )
    @teacher.save!
    @attr_teacher_phones = {
      :teacher_mobile_number => "8903111111",
      :teacher_home_number => "777-33-22"
    }    
  end
  
  describe "User-TeacherPhone creation" do
    it "should create teacher phones via user" do
      expect do
        @teacher.create_teacher_phone( @attr_teacher_phones )
      end.should change( TeacherPhone, :count ).by( 1 )
    end

    # it "should not create invalid teacher education via user" do
    #   expect do
    #     @user.create_teacher_education( @attr_invalid_teacher_edu )
    #   end.should_not change( TeacherEducation, :count )
    # end  
  end
end

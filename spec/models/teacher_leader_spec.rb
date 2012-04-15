# encoding: UTF-8
# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: teacher_leaders
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  teacher_id :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe TeacherLeader do
  before(:each) do
    @user = FactoryGirl.create( :user )
    @teacher = FactoryGirl.create( :teacher )
    
    @attr_teacher_leader = {
      :user_id => @user.id,
      :teacher_id => @teacher.id
    }
    
    # @attr_invalid_teacher_leader = {
    #   :user_id => "8594849",
    #   :teacher_id => "2949403"
    # }
  end
  
  describe "User-TeacherLeader creation" do
    it "should create teacher leader via user" do
      expect do
        @user.create_teacher_leader( @attr_teacher_leader )
      end.should change( TeacherLeader, :count ).by( 1 )
    end
      
    # it "should not create invalid teacher leader via user" do
    #   expect do
    #     @user.create_teacher_leader( @attr_invalid_teacher_leader )
    #   end.should_not change( TeacherLeader, :count )
    # end
  end
  
  describe "User-TeacherLeader association" do
    before(:each) do
      @teacher_leader = @user.create_teacher_leader( @attr_teacher_leader )
    end
    
    it "should have a user attribute" do
      @teacher_leader.should respond_to(:user)
    end
    
    it "should have a teacher attribute" do
      @teacher_leader.should respond_to(:teacher)
    end
    
    it "should have the right associated user" do
      @teacher_leader.user_id.should == @user.id
      @teacher_leader.user.should    == @user
    end
    
    it "should have the right associated teacher" do
      @teacher_leader.teacher_id.should == @teacher.id
      @teacher_leader.teacher.should    == @teacher
    end
  end
  
  describe "Validations" do
    it "should not create new teacher leader if it is already exists" do
      expect do
        @user.create_teacher_leader( @attr_teacher_leader )
      end.should change( TeacherLeader, :count ).by( 1 )
      
      expect do
        @user.create_teacher_leader( @attr_teacher_leader )
      end.should_not change( TeacherLeader, :count )
    end
  end
end

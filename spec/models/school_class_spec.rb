# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: school_classes
#
#  id                     :integer         not null, primary key
#  teacher_leader_id      :integer
#  class_code             :string(255)
#  date_of_class_creation :date
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#

require 'spec_helper'

describe SchoolClass do
  before(:each) do
    @user = Factory( :user )
    @teacher = Factory( :teacher, 
                        :user => Factory( :user, :user_login => Factory.next( :user_login )))
    @teacher_leader = @user.create_teacher_leader({ :user_id => @user.id, 
                                                    :teacher_id => @teacher.id })
    
    @attr_school_class = {
      :class_code => "11k",
      :date_of_class_creation => Date.today
    }
  end
  
  describe "SchoolClass creation" do
    it "should create school class" do
      expect do
        @sch_class = @teacher_leader.create_school_class( @attr_school_class )
      end.should change( SchoolClass, :count ).by( 1 )
    end
  end
end

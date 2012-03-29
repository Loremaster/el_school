# encoding: UTF-8
# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: subjects
#
#  id           :integer         not null, primary key
#  subject_name :string(255)
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#

require 'spec_helper'

describe Subject do
  before(:each) do    
    @attr = { :subject_name => "Математика" }
  end
  
  describe "Validations" do
    it "should reject blank subject" do
      Subject.new( @attr.merge( :subject_name => "  " ) ).should_not be_valid
    end
    
    it "should reject too long subject name" do
      Subject.new( @attr.merge( :subject_name => 'a' * 31 ) ).should_not be_valid
    end
    
    it "should accept subject name with correct length" do
      Subject.new( @attr ).should be_valid
    end
    
    it "should save subject with correct attributes" do
      expect do
        Subject.create( @attr )
      end.should change( Subject, :count ).by( 1 )
    end
  end
end

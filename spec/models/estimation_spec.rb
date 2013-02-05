# == Schema Information
#
# Table name: estimations
#
#  id           :integer         not null, primary key
#  reporting_id :integer
#  pupil_id     :integer
#  nominal      :integer
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#

require 'spec_helper'

describe Estimation do
  before(:each) do
    @reporting = FactoryGirl.create( :reporting )
    @pupil = FactoryGirl.create( :pupil )
    @attr_est = { :reporting_id => @reporting.id, :pupil_id => @pupil.id, :nominal => 4 }
  end

  describe "Estimation creation" do
    it "should be success" do
      expect do
        Estimation.create( @attr_est )
      end.should change( Estimation, :count ).by( 1 )
    end

    it "should not success with invalid params" do
      expect do
        Estimation.create( @attr_est.merge( :reporting_id => nil, :pupil_id => nil, :nominal => 10 ) )
      end.should_not change( Estimation, :count )
    end
  end

  describe "Estimation association" do
    before(:each) do
      @estimation = Estimation.create( @attr_est )
    end

    it "should have a pupil attribute" do
      @estimation.should respond_to( :pupil )
    end

    it "should have a reporting attribute" do
      @estimation.should respond_to( :reporting )
    end

    it "should have the right associated pupil" do
      @estimation.pupil_id.should == @pupil.id
      @estimation.pupil.should == @pupil
    end

    it "should have the right associated reporting" do
      @estimation.reporting_id.should == @reporting.id
      @estimation.reporting.should == @reporting
    end
  end

  describe "Validations" do
    describe "Rejection" do
      it "should reject nil reporting_id" do
        wrong_attr = @attr_est.merge( :reporting_id => nil )
        Estimation.new( wrong_attr ).should_not be_valid
      end

      it "should reject nil pupil_id" do
        wrong_attr = @attr_est.merge( :pupil_id => nil )
        Estimation.new( wrong_attr ).should_not be_valid
      end

      it "should reject nominals < 1" do
        (-5..0).each do |i|
          wrong_attr = @attr_est.merge( :nominal => i )
          Estimation.new( wrong_attr ).should_not be_valid
        end
      end

      it "should reject nominals > 5" do
        (6..10).each do |i|
          wrong_attr = @attr_est.merge( :nominal => i )
          Estimation.new( wrong_attr ).should_not be_valid
        end
      end
    end

    describe "Acceptance" do
      it "should accept nil nominal" do
        correct_attr = @attr_est.merge( :nominal => nil )
        Estimation.new( correct_attr ).should be_valid
      end

      it "should accept correct nominals" do
        (2..5).each do |i|
          correct_attr = @attr_est.merge( :nominal => i  )
          Estimation.new( correct_attr ).should be_valid
        end
      end
    end
  end
end

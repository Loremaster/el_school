# == Schema Information
#
# Table name: results
#
#  id            :integer         not null, primary key
#  pupil_id      :integer
#  curriculum_id :integer
#  quarter_1     :integer
#  quarter_2     :integer
#  quarter_3     :integer
#  quarter_4     :integer
#  year          :integer
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#

require 'spec_helper'

describe Result do
  before(:each) do
    @pupil = FactoryGirl.create(:pupil)
    @curriculum = FactoryGirl.create(:curriculum)
    @attr_result = { :pupil_id => @pupil.id, :curriculum_id => @curriculum.id,
                     :quarter_1  => 3, :quarter_2  => 5, :quarter_3  => 4, :quarter_4  => 3,
                     :year       => 5 }
  end

  describe "Creation" do
    it "should create result with valid attributes" do
      expect do
        Result.create( @attr_result ).should be_valid
      end.should change( Result, :count ).by( 1 )
    end

    it "should not create result with valid attributes" do
      expect do
        Result.create( @attr_result.merge( :pupil_id => nil, :curriculum_id => nil )
                     ).should_not be_valid
      end.should_not change( Result, :count )
    end
  end

  describe "Result associations" do
    before(:each) do
      @result = Result.create( @attr_result )
    end

    it "should have pupil attribute" do
      @result.should respond_to( :pupil )
    end

    it "should have curriculum attribute" do
      @result.should respond_to( :curriculum )
    end

    it "should have right associated pupil" do
      @result.pupil_id.should == @pupil.id
      @result.pupil.should == @pupil
    end

    it "should have right associated curriculum" do
      @result.curriculum_id.should == @curriculum.id
      @result.curriculum.should == @curriculum
    end
  end

  describe "Validations" do
    describe "Rejection" do
      it "should reject nil pupil id" do
        wrong_attr = @attr_result.merge( :pupil_id => nil )
        Result.new( wrong_attr ).should_not be_valid
      end

      it "should reject nil curriculum id" do
        wrong_attr = @attr_result.merge( :curriculum_id => nil )
        Result.new( wrong_attr ).should_not be_valid
      end

      it "should reject incorrect nominals of 1st quarter" do
        incorrect_values = []
        incorrect_values << (6..10).to_a; incorrect_values << (-10..1).to_a
        incorrect_values.flatten!
        incorrect_values.each do |v|
          wrong_attr = @attr_result.merge( :quarter_1 => v )
          Result.new( wrong_attr ).should_not be_valid
        end
      end

      it "should reject incorrect nominals of 2nd quarter" do
        incorrect_values = []
        incorrect_values << (6..10).to_a; incorrect_values << (-10..1).to_a
        incorrect_values.flatten!
        incorrect_values.each do |v|
          wrong_attr = @attr_result.merge( :quarter_2 => v )
          Result.new( wrong_attr ).should_not be_valid
        end
      end

      it "should reject incorrect nominals of 3d quarter" do
        incorrect_values = []
        incorrect_values << (6..10).to_a; incorrect_values << (-10..1).to_a
        incorrect_values.flatten!
        incorrect_values.each do |v|
          wrong_attr = @attr_result.merge( :quarter_3 => v )
          Result.new( wrong_attr ).should_not be_valid
        end
      end

      it "should reject incorrect nominals of 4th quarter" do
        incorrect_values = []
        incorrect_values << (6..10).to_a; incorrect_values << (-10..1).to_a
        incorrect_values.flatten!
        incorrect_values.each do |v|
          wrong_attr = @attr_result.merge( :quarter_4 => v )
          Result.new( wrong_attr ).should_not be_valid
        end
      end

      it "should reject incorrect nominals of year" do
        incorrect_values = []
        incorrect_values << (6..10).to_a; incorrect_values << (-10..1).to_a
        incorrect_values.flatten!
        incorrect_values.each do |v|
          wrong_attr = @attr_result.merge( :year => v )
          Result.new( wrong_attr ).should_not be_valid
        end
      end
    end

    describe "Acceptance" do
      it "should accept nil quarter_1" do
        correct_attr = @attr_result.merge( :quarter_1 => nil )
        Result.new( correct_attr ).should be_valid
      end

      it "should accept nil quarter_2" do
        correct_attr = @attr_result.merge( :quarter_2 => nil )
        Result.new( correct_attr ).should be_valid
      end

      it "should accept nil quarter_3" do
        correct_attr = @attr_result.merge( :quarter_3 => nil )
        Result.new( correct_attr ).should be_valid
      end

      it "should accept nil quarter_4" do
        correct_attr = @attr_result.merge( :quarter_4 => nil )
        Result.new( correct_attr ).should be_valid
      end

      it "should accept nil year" do
        correct_attr = @attr_result.merge( :year => nil )
        Result.new( correct_attr ).should be_valid
      end

      it "should accept correct nominals of quarter_1" do
        (2..5).each do |v|
          wrong_attr = @attr_result.merge( :quarter_1 => v )
          Result.new( wrong_attr ).should be_valid
        end
      end

      it "should accept correct nominals of quarter_2" do
        (2..5).each do |v|
          wrong_attr = @attr_result.merge( :quarter_2 => v )
          Result.new( wrong_attr ).should be_valid
        end
      end

      it "should accept correct nominals of quarter_3" do
        (2..5).each do |v|
          wrong_attr = @attr_result.merge( :quarter_3 => v )
          Result.new( wrong_attr ).should be_valid
        end
      end

      it "should accept correct nominals of quarter_4" do
        (2..5).each do |v|
          wrong_attr = @attr_result.merge( :quarter_4 => v )
          Result.new( wrong_attr ).should be_valid
        end
      end

      it "should accept correct nominals of year" do
        (2..5).each do |v|
          wrong_attr = @attr_result.merge( :year => v )
          Result.new( wrong_attr ).should be_valid
        end
      end
    end
  end
end

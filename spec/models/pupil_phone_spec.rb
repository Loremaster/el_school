# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: pupil_phones
#
#  id                  :integer         not null, primary key
#  pupil_id            :integer
#  pupil_home_number   :string(255)
#  pupil_mobile_number :string(255)
#  created_at          :datetime        not null
#  updated_at          :datetime        not null
#

require 'spec_helper'

describe PupilPhone do
  before(:each) do
    @pupil = Factory( :pupil )
    
    @attr_pupil_phones = {
      :pupil_home_number   =>  "8903111111",
      :pupil_mobile_number => "777-33-22"
    }
    
    @attr_invalid_pupil_phones ={
      :pupil_home_number   =>  " ",
      :pupil_mobile_number => " "
    }
  end
  
  describe "Pupil-PupilPhone creation" do
    it "should create pupil phones via pupil" do
      expect do
        @pupil.create_pupil_phone( @attr_pupil_phones )
      end.should change( PupilPhone, :count ).by( 1 )
    end
    
    it "should not create incorrect pupil phones via pupil" do
      expect do
        @pupil.create_pupil_phone( @attr_invalid_pupil_phones )
      end.should_not change( PupilPhone, :count )
    end
  end
  
  describe "Pupil-PupilPhone association" do
    before(:each) do
      @pupil_ph = @pupil.create_pupil_phone( @attr_pupil_phones )
    end
    
    it "should have a pupil attribute" do
      @pupil_ph.should respond_to( :pupil )
    end
    
    it "should have right associated pupil" do
      @pupil_ph.pupil_id.should == @pupil.id
      @pupil_ph.pupil.should == @pupil
    end
  end
  
  describe "Validations" do
    describe "Rejection" do
      it "should reject blank home phone" do
        phone = @attr_pupil_phones.merge( :pupil_home_number => " " )
        @pupil.build_pupil_phone( phone ).should_not be_valid 
      end
    
      it "should reject too long home phone" do
        phone = @attr_pupil_phones.merge( :pupil_home_number => '1' * 21 )
        @pupil.build_pupil_phone( phone ).should_not be_valid      
      end
    
      it "should reject blank mobile phone" do
        phone = @attr_pupil_phones.merge( :pupil_mobile_number => " " )
        @pupil.build_pupil_phone( phone ).should_not be_valid 
      end
    
      it "should reject too long mobile phone" do
        phone = @attr_pupil_phones.merge( :pupil_mobile_number => '1' * 21 )
        @pupil.build_pupil_phone( phone ).should_not be_valid 
      end
    end
    
    describe "Acceptance" do
      it "should accept correct home phone" do
        (1..20).each do |i|
          phone = @attr_pupil_phones.merge( :pupil_home_number => '1' * i )
          @pupil.build_pupil_phone( phone ).should be_valid 
        end  
      end
      
      it "should accept correct mobile phone" do
        (1..20).each do |i|
          phone = @attr_pupil_phones.merge( :pupil_mobile_number => '1' * i )
          @pupil.build_pupil_phone( phone ).should be_valid 
        end  
      end
    end
  end
end

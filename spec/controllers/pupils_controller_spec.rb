# encoding: UTF-8
require 'spec_helper'

describe PupilsController do
  render_views
  
  before(:each) do
    @adm = Factory( :user, :user_login => "usr" )
    @adm.user_role = "admin"
    @adm.save!
    
    @sh = Factory( :user, :user_login => "shh" )
    @sh.user_role = "school_head"
    @sh.save!
    
    @user = Factory( :user )
    @pupil = Factory( :pupil )
  end
  
  describe "GET 'index'" do
    describe "for non-signed users" do
      it "should deny access to show pupils" do
        get :index
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как завуч/i
      end
    end
    
    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end
      
      it "should deny access to show pupils" do
        get :index
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end
    
    describe "for signed-in school-heads" do
      before(:each) do
        test_sign_in( @sh )
      end
      
      it "should show pupils" do
        get :index
        response.should be_success
        flash[:error].should be_nil
      end
    end
  end

  describe "GET 'new'" do
    describe "for non-signed users" do
      it "should deny access to show create page" do
        get :new
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как завуч/i
      end
    end
    
    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end
      
      it "should deny access to show create page" do
        get :new
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end
  
    describe "for signed-in school-heads" do
      before(:each) do
        test_sign_in( @sh )
      end
      
      it "should show pupils" do
        get :new
        response.should be_success
        flash[:error].should be_nil
      end
    end
  end

  describe "GET 'edit'" do
    describe "for non-signed users" do
      it "should deny access to edit pupil" do
        get :edit, :id => @pupil
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как завуч/i
      end
    end
    
    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end
      
      it "should deny access to edit pupil" do
        get :edit, :id => @pupil
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end
    
    describe "for signed-in school-heads" do
      before(:each) do
        test_sign_in( @sh )
      end
      
      it "should get page to edit pupil" do
        get :edit, :id => @pupil
        response.should be_success
        flash[:error].should be_nil
      end
    end
  end

  describe "PUT 'update'" do
    describe "for non-signed users" do
      it "should deny access to update pupil" do
        put :update, :id => @pupil, 
                     :pupil => @pupil.attributes.merge(:pupil_last_name => "some") 
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как завуч/i             
      end
    end
    
    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end
      
      it "should deny access to edit pupil" do
        put :update, :id => @pupil, 
                     :pupil => @pupil.attributes.merge(:pupil_last_name => "some")
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end
    
    describe "for signed-in school-heads" do
      before(:each) do
        test_sign_in( @sh )
      end
      
      it "should reject to update pupil if params are not correct" do
        last_name = "  "
        put :update, :id => @pupil, 
                     :pupil => @pupil.attributes.merge(:pupil_last_name => last_name)
        @pupil.reload
        @pupil.pupil_last_name.should_not == last_name
      end
      
      it "should update pupil if params are correct" do
        last_name = "last"
        put :update, :id => @pupil, 
                     :pupil => @pupil.attributes.merge(:pupil_last_name => last_name)
        @pupil.reload
        @pupil.pupil_last_name.should == last_name
      end
    end
  end

  # describe "POST 'create'" do
  #     before(:each) do
  #       @attr_pupil = {
  #         :pupil_last_name => "Bion",
  #         :pupil_first_name => "Joo",
  #         :pupil_middle_name => "Joo",
  #         :pupil_birthday => "#{Date.today - 10.years}",
  #         :pupil_sex => "m",
  #         :pupil_nationality => "American",
  #         :pupil_address_of_registration => "Dallas",
  #         :pupil_address_of_living => "London",
  #         :user_attributes => {                              
  #                               :user_login => @user.user_login,
  #                               :password => @user.password
  #                             }
  #       }
  #       
  #       # @attr_pupil = {"pupil_last_name"=>"Bion", 
  #       #                "pupil_first_name"=>"kooo",                             
  #       #                "pupil_middle_name"=>"dfdf",                            
  #       #                "pupil_sex"=>"w",                                   
  #       #                "pupil_birthday"=>"#{Date.today - 10.years}",                               
  #       #                "pupil_nationality"=>"American",                            
  #       #                "pupil_address_of_registration"=>"Dallas",                
  #       #                "pupil_address_of_living"=>"London",                      
  #       #                "user_attributes"=>{                                
  #       #                                     "user_login"=> @user.user_login,              
  #       #                                     "password"=> @user.password       
  #       #                                    }                               
  #       #                }                                                    
  #                     
  #       
  #     end
  #         
  #     describe "for signed-in school-heads" do
  #       before(:each) do
  #         test_sign_in( @sh )
  #       end
  #       
  #       it "should create pupil" do
  #         # expect do
  #           post :create, :pupil => @attr_pupil 
  #           flash[:success].should =~ /успешно создан/i        
  #         # end.should change( Pupil, :count ).by( 1 )
  #         
  #         # expect do
  #         #   pupil = @user.build_pupil( @attr_pupil )
  #         #   pupil.should be_valid
  #         #   post :create, :pupil => pupil.attributes
  #         # end.should change( Pupil, :count ).by( 1 )
  #       end
  #     end  
  #   end
end

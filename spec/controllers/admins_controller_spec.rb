# encoding: UTF-8
require 'spec_helper'

describe AdminsController do
  render_views
  
  describe "GET 'users_of_system'" do
    describe "for non-signed-in users" do
      it "should deny access" do
        get :users_of_system
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как администратор/i
      end
    end
  end
end
# describe AdminsController do
#   render_views
# 
#   describe "GET 'users_of_system'" do
#     describe "for non-signed-in users" do
#       it "should deny access" do
#         get :users_of_system
#         response.should redirect_to( signin_path )
#         flash[:notice].should =~ /войдите в систему как администратор/i
#       end
#     end
# 
#         # describe "for signed-in users" do
#         #       before(:each) do
#         #         # @user = test_sign_in( Factory(:user) )
#         #     
#         #         @attr = {
#         #                :user_login => "Admin",
#         #                :user_role => "admin",
#         #                :password => "foobar"
#         #              }
#         #         
#         #       #   @user2 = User.create!(@attr)
#         #       #   
#         #       #   # @signed_user = test_sign_in( @user2 )
#         #       #   
#         #       #   @signed_user = SessionsController.sign_in ( @user2 )
#         #       # end
#         #       end
#         #     
#         #       it "should be successful" do
#         #          get :users_of_system
#         #          response.should redirect_to ( admins_users_of_system_path )
#         #          # response.should have_selector("legend", :content => "Список учетных записей системы")
#         #       end
#         #     end
# end

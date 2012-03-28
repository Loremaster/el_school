# encoding: UTF-8
class AdminsController < ApplicationController
  before_filter :authenticate_admins, :only => [ 
                                                 :backups,
                                                 :users_of_system,
                                                 :new_school_head,
                                                 :new_teacher,
                                                 :create_school_head,
                                                 :create_teacher 
                                                ]

  #TODO Creating backups. Restore DB from backup.
  #TODO Test, that only admin can see his pages.
  #TODO Refactor AdminsController.
  #TODO Test user updating.
  def backups
  end

  def users_of_system
    @all_users = User.all
  end

  def new_school_head
    @user = User.new
    @user_login, @user_pass = "", ""
    @everpresent_field_placeholder = "Обязательное поле"
    
    @user_login = params[:user_login]
    @user_pass  = params[:password]
  end

  def create_school_head
    user = User.new( params[:user] )
    user.user_role = "school_head"

    if user.save
      redirect_to admins_users_of_system_path
      flash[:success] = "Завуч успешно создан!"
    else
      redirect_to admins_new_school_head_path( params[:user] )
      flash[:error] = user.errors.full_messages.to_sentence :last_word_connector => ", ",
                                                            :two_words_connector => ", "
    end
  end

  def new_teacher
    @user = User.new
    teacher = @user.build_teacher
    teacher_education = teacher.build_teacher_education
    teacher_phone = teacher.build_teacher_phone
    
    @everpresent_field_placeholder = "Обязательное поле"
    @teacher_last_name, @teacher_first_name, @teacher_middle_name     = "", "", ""
    @teacher_birthday, @teacher_category, @user_login, @user_password = "", "", "", ""
    @teacher_university, @teacher_finish_univ, @teacher_graduation    = "", "", ""
    @teacher_specl, @teacher_mobile_num, @teacher_home_num            = "", "", ""
    @user_sex_man, @user_sex_woman                                    = false, true       # Values of radio buttons of sex.

    if ( params.has_key?( :user ) )                                                       # This has such key only if user have wrong values in fields and we've redirected to this method.
      @teacher_last_name   = params[:user][:teacher_attributes][:teacher_last_name]     
      @teacher_first_name  = params[:user][:teacher_attributes][:teacher_first_name]
      @teacher_middle_name = params[:user][:teacher_attributes][:teacher_middle_name]
      @teacher_birthday    = params[:user][:teacher_attributes][:teacher_birthday]
      @teacher_category    = params[:user][:teacher_attributes][:teacher_category]
      @user_login          = params[:user][:user_login]
      @user_password       = params[:user][:password]        
      user_sex             = params[:user][:teacher_attributes][:teacher_sex]
      @teacher_university  = params[:user][:teacher_attributes][:teacher_education_attributes][:teacher_education_university]
      @teacher_finish_univ = params[:user][:teacher_attributes][:teacher_education_attributes][:teacher_education_year]
      @teacher_graduation  = params[:user][:teacher_attributes][:teacher_education_attributes][:teacher_education_graduation]
      @teacher_specl       = params[:user][:teacher_attributes][:teacher_education_attributes][:teacher_education_speciality]
      @teacher_mobile_num  = params[:user][:teacher_attributes][:teacher_phone_attributes][:teacher_mobile_number]
      @teacher_home_num    = params[:user][:teacher_attributes][:teacher_phone_attributes][:teacher_home_number]
      
      # Set value of radio button by receiving value from users.
      case user_sex
        when 'm' then @user_sex_man, @user_sex_woman = true, false
        when 'w' then @user_sex_man, @user_sex_woman = false, true  
      end    
    end
  end
  
  def create_teacher
    user_errors, date_errors = nil, nil; all_correct_errors = []     
    @user = User.new( params[:user] )                                                     # Important note! We shouldn't set id here, nested_attributes do that automatically. Also, be sure, that you don't check id presence in belongs_to models.
    @user.user_role = "teacher"                                                            

    valid_birthday = date_valid?( params[:user][:teacher_attributes][:teacher_birthday] ) # Check our date. You can find method in application controller. Such way is bad, but i didn't find good solution to use it in validation.
    valid_finish_univer = date_valid?( params[:user][:teacher_attributes][:teacher_education_attributes][:teacher_education_year] )
        
    if @user.save and valid_birthday and valid_finish_univer                              # Save if validaions gone well and date is ok.
      redirect_to admins_users_of_system_path     
      flash[:success] = "Завуч успешно создан!"
    else
      redirect_to admins_new_teacher_path( params )
      
      all_correct_errors = collect_all_errors( @user )
      all_correct_errors << "Дата рождения неверного формата или не существует" if not valid_birthday
      all_correct_errors << "Дата выпуска из ВУЗа неверного формата или не существует" if not valid_finish_univer
      
      flash[:error] = all_correct_errors.to_sentence :last_word_connector => ", ",        
                                                     :two_words_connector => ", "  if all_correct_errors.present?
    end 
  end
  
  private
    
    # Here we collecting all errors for each table and return them.
    # We do that because it's impossible to get all errors correctly via calling 'user.errors'
    # This is impossible because we use nested_attributes too deep.
    #
    # For example - Teacher belongs to User - all errors look fine, 
    # TeacherEdu belongs to Teacher, Teacher belongs to User - can't show all errors correctly.
    def collect_all_errors( usr )
      user_errors = collect_user_errors( usr, :user_login, :password ) 
      teacher_errors = usr.teacher.errors.full_messages
      
      
      all_errors = ( user_errors + teacher_errors )
    end
    
    # Collect errors only for user. In our case - only for login and password.
    def collect_user_errors( usr_model, login_field, pass_field )
      tmp, errors = [], [] 
      
      # Collect all results and adding result to errors if it is NOT empty     
      tmp << get_full_error_for_field( usr_model, login_field )
      tmp << get_full_error_for_field( usr_model, pass_field  )
            
      tmp.each { |e| errors << e if not e.empty? }                                        
      
      return errors
    end
    
    # Find full message for field of model and return that of empty string if nothing 
    # was found
    def get_full_error_for_field( model_name, field )
      empty_field = model_name.errors[field].empty?

      if ( not empty_field )
        model_name.errors.full_message( field, model_name.errors[field]
                                                         .to_sentence
                                                         .gsub(" and", ",")  )            # Using gsub because here it doesn't want to use word_connectors.
      else
        ""
      end
    end
end
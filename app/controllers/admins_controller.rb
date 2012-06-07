# encoding: UTF-8
class AdminsController < ApplicationController
  before_filter :authenticate_admins, :only => [
                                                 :backups,
                                                 :new_school_head,
                                                 :new_teacher,
                                                 :create_school_head,
                                                 :create_teacher
                                                ]

  #TODO Creating backups. Restore DB from backup.
  #TODO Test user updating (integration).
  def backups
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
    user.user_role = "school_head" if current_user_admin?

    if user.save
      redirect_to users_path
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
  end

  def create_teacher
    @everpresent_field_placeholder = "Обязательное поле"
    user_errors, date_errors = nil, nil; all_correct_errors = []
    @user = User.new( params[:user] )                                                     # Important note! We shouldn't set id here, nested_attributes do that automatically. Also, be sure, that you don't check id presence in belongs_to models.
    @user.user_role = "teacher" if current_user_admin?

    if @user.save
      redirect_to users_path
      flash[:success] = "Учитель успешно создан!"
    else
      all_correct_errors = collect_all_errors( @user )
      flash[:error] = all_correct_errors.to_sentence :last_word_connector => ", ",
                                                     :two_words_connector => ", "  if all_correct_errors.present?
      render 'new_teacher'
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
# encoding: UTF-8
class TeacherLeadersController < ApplicationController
  before_filter :authenticate_school_heads, :only => [ :new, :create ] 
  
  def new
    @everpresent_field_placeholder = "Обязательное поле"
    @user = User.new
    
    @teachers_collection = Teacher.all                                                    # Collect array of ["teacher names", teacher.id] which are options of select in view.
                                  .collect do |t| 
                                    [ "#{t.teacher_last_name} #{t.teacher_first_name} #{t.teacher_middle_name}", t.id ] 
                                   end
    # @teachers_collection = []
    @choosen_teacher = @teachers_collection.first.last unless @teachers_collection.empty? # First array, then last element in array. Get it ONLY if we've found teachers.
  end
   
  def create
    user = User.new( params[:user] )
    user.user_role = "class_head"
    
    if ( params.has_key?( :teacher_id ) )
      if user.save
        t = TeacherLeader.new( :teacher_id => params[:teacher_id], :user_id => user.id )
        t.save
      else
        flash[:error] = user.errors.full_messages.to_sentence :last_word_connector => ", ",
                                                              :two_words_connector => ", "
      end
    else
      flash[:notice] = "Sorry, you can't create teacher leader, because there are no teachers."  
    end  
  end
end

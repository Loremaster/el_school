# encoding: UTF-8
class ParentsInfosController < ApplicationController
  before_filter :authenticate_parents, :only => [ :index, :edit, :update ]

  def index
    @parent = current_user.parent
  end

  def edit
    @everpresent_field_placeholder = "Обязательное поле"
    @parent = Parent.find( params[:id] )
  end

  def update
    @everpresent_field_placeholder = "Обязательное поле"
    @parent = Parent.find( params[:id] )

    if @parent.update_attributes( params[:parent] )
      redirect_to parents_infos_path
      flash[:success] = "Ваши данные успешно обновлены!"
    else
      flash.now[:error] = @parent.errors.full_messages
                                        .to_sentence :last_word_connector => ", ",
                                                     :two_words_connector => ", "
      render 'edit'                                                                       # After calling this we get all from params. That means that fields are not autocomplete if user edited them.
    end
  end
end

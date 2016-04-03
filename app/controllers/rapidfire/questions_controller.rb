module Rapidfire
  class QuestionsController < Rapidfire::ApplicationController
    before_filter :authenticate_administrator!

    before_filter :find_question_group!
    before_filter :find_question!, :only => [:edit, :update, :destroy]

    def index
      @questions = @question_group.questions
    end

    def new
      @question_form = QuestionForm.new(:question_group => @question_group)
    end

    def create
      form_params = params[:question].merge(:question_group => @question_group)
      @question = QuestionForm.new(form_params)
      if !@question.question.position
        lastq=Question.where(:question_group_id => @question_group.id).order("position").last
        if lastq && lastq.position
          @question.question.position=lastq.position1
        else
          @question.question.position=1
        end
      end
      save_and_redirect(form_params, :new)
    end

    def edit
      @question_form = QuestionForm.new(:question => @question)
    end

    def update
      form_params = params[:question].merge(:question => @question)

      save_and_redirect(form_params, :edit)
    end

    def destroy
      @question.destroy
      respond_to do |format|
        format.html { redirect_to index_location }
        format.js
      end
    end

    def move
      @question = @question_group.questions.find(params[:question_id])
      lastp=@question.position
      startp=params[:position].to_i
      set=Question.where(:question_group_id => @question_group.id).where("position >= ?",startp).where("position < ?",lastp)
      #can be a big load!
      set.each do |q|
        if q.id
          mquestion=Question.find(q)
          mquestion.position=mquestion.position+1
          mquestion.save
        end
      end
      @question.position=startp
      @question.save

      redirect_to index_location
    end


    private

    def save_and_redirect(params, on_error_key)
      @question_form = QuestionForm.new(params)
      @question_form.save

      if @question_form.errors.empty?
        respond_to do |format|
          format.html { redirect_to index_location }
          format.js
        end
      else
        respond_to do |format|
          format.html { render on_error_key.to_sym }
          format.js
        end
      end
    end

    def find_question_group!
      @question_group = QuestionGroup.find(params[:question_group_id])
    end

    def find_question!
      @question = @question_group.questions.find(params[:id])
    end

    def index_location
      rapidfire.question_group_questions_url(@question_group)
    end
  end
end

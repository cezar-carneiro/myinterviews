class InterviewsController < ApplicationController
  before_action :set_interview, only: [:show, :edit, :update, :destroy]
  before_action :load_applications, only: [:new, :edit]

  def index
    @interviews = Interview.includes(:my_application).ordered_by_last.all
  end

  def show; end

  def new
    @interview = Interview.new(my_application_id: params[:my_application_id])
  end

  def edit; end

  def create
    @interview = Interview.new(interview_params)

    if @interview.save
      redirect_to @interview, notice: t('messages.successfully_created', entity: t('interviews.item'))
    else
      load_applications
      render :new
    end
  end

  def update
    if @interview.update(interview_params)
      redirect_to @interview, notice: t('messages.successfully_updated', entity: t('interviews.item'))
    else
      load_applications
      render :edit
    end
  end

  def destroy
    @interview.destroy
    redirect_to interviews_path, notice: t('messages.successfully_destroyed', entity: t('interviews.item'))
  end

  protected

  def correct_stale_record_version
    @interview.reload
  end

  private

  def load_applications
    @applications = MyApplication.all
  end

  def set_interview
    @interview = Interview.includes(:my_application).find(params[:id])
  end

  def interview_params
    params.fetch(:interview, {}).permit(:interviewer_name, :interviewer_email, :at, :type_of, :lock_version,
                                        :my_application_id, :notes, :feedback)
  end
end

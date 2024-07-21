class Users::AvailabilitiesController < ApplicationController
  before_action :set_user
  before_action :set_availability, only: %i[show update destroy]
  after_action :assign_hours, only: %i[create update]

  def index
    render json: @user.availabilities.map(&:show)
  end

  def all
    render json: Users::Availability.all.map(&:show)
  end

  def show
    render json: @availability.show
  end

  def create
    availability = @user.availabilities.build(availability_params)

    if availability.save
      render json: availability.show, status: :created
    else
      render json: {
        message: 'Something went wrong',
        errors: availability.errors.full_messages
      }, status: :internal_server_error
    end
  end

  def update
    if @availability.update(availability_params)
      render json: @availability.show, status: :ok
    else
      render json: {
        message: 'Something went wrong',
        errors: @user.errors.full_messages
      }, status: :internal_server_error
    end
  end

  def destroy
    if @availability.destroy
      render json: { message: 'User availability removed' }, status: :ok
    else
      render json: {
        message: 'Something went wrong',
        errors: @availability.errors.full_messages
      }, status: :internal_server_error
    end
  end

  private

  def availability_params
    params.require(:availability).permit(
      :users_id,
      :day,
      :week,
      :month,
      :year,
      :available,
      :services_id, # This params could be optional
      :catalog_hours_id
    )
  end

  def set_user
    @user = User.find_by(id: params[:user_id])
    return if @user

    render json: { message: 'User is not found' }, status: :not_found
  end

  def set_availability
    @availability = @user.availabilities.find_by(id: params[:id])
    return if @availability

    render json: { message: 'User is not availabe' }, status: :not_found
  end

  def assign_hours
    Thread.new do
      KronosService.instance.assign_services
    end
  end
end

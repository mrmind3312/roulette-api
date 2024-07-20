class Users::AvailabilitiesController < ApplicationController
  before_action :set_user
  before_action :set_availability, only: %i[show update destroy]

  def index
    render json: @user.availabilities.map(&:show)
  end

  def show
    render json: @availability.show
  end

  def create
    availability = @user.availabilities.build(availability_params)

    if availability.save
      render json: { message: 'User availability created' }, status: :created
    else
      render json: {
        message: 'Something went wrong',
        errors: service.errors.full_messages
      }, status: :internal_server_error
    end
  end

  def update
    if @availability.update(availability_params)
      render json: { message: 'User availability updated' }, status: :ok
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
end

class Users::AvailabilitiesController < ApplicationController
  before_action :set_users_availability, only: %i[show update destroy]

  def index
    render json: Users::Availability.include(:user, :catalog_hour, :service).all
  end

  def show
    render json: @users_availability
  end

  def create
    user_availability = Users::Availability.new(users_availability_params)

    if user_availability.save
      render json: { message: 'User availability created' }, status: :created
    else
      render json: {
        message: 'Something went wrong',
        errors: service.errors.full_messages
      }, status: :internal_server_error
    end
  end

  def update
    if @users_availability.update(users_availability_params)
      render json: { message: 'User availability updated' }, status: :ok
    else
      render json: {
        message: 'Something went wrong',
        errors: @user.errors.full_messages
      }, status: :internal_server_error
    end
  end

  def destroy
    if @users_availability.destroy
      render json: { message: 'User availability removed' }, status: :ok
    else
      render json: {
        message: 'Something went wrong',
        errors: @users_availability.errors.full_messages
      }, status: :internal_server_error
    end
  end

  private

  def users_availability_params
    params.require(:users_availability).permit(
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

  def set_users_availability
    @user_availability = Users::Availability.find_by(id: params[:id])
    return if @user_availability

    render json: { message: 'User is availability not found' }, status: :not_found
  end
end

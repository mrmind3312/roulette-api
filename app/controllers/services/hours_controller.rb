class Services::HoursController < ApplicationController
  before_action :set_services_hour, only: %i[show update destroy]

  def index
    render json: Services::Hour.include(:service, :catalog_hour).all
  end

  def show
    render json: @services_hour
  end

  def create
    services_hour = Services::Hour.new(services_hour_params)

    if services_hour.save
      render json: { message: 'Service hour saved' }, status: :created
    else
      render json: {
        message: 'Something went wrong',
        errors: services_hour.errors.full_messages
      }, status: :internal_server_error
    end
  end

  def update
    if @services_hour.update(services_hour_params)
      render json: { message: 'Service hour updated' }, status: :ok
    else
      render json: {
        message: 'Something went wrong',
        errors: @services_hour.errors.full_messages
      }, status: :internal_server_error
    end
  end

  def destroy
    if @services_hour.destroy
      render json: { message: 'Service hour removed' }, status: :ok
    else
      render json: {
        message: 'Something went wrong',
        errors: @services_hour.errors.full_messages
      }, status: :internal_server_error
    end
  end

  private

  def services_hour_params
    params.require(:services_hour).permit(
      :services_id,
      :catalog_hours_id
    )
  end

  def set_services_hour
    @services_hour = Services::Hour.find_by(id: params[:id])
    return if @services_hour

    render json: { message: 'Service hour not found' }, status: :not_found
  end
end

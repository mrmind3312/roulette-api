class ServicesController < ApplicationController
  before_action :set_service, only: %i[show update destroy]

  def index
    render json: Service.include(:catalog_hours).all
  end

  def show
    render json: @service
  end

  def create
    service = Service.new(service_params)

    if service.save
      render json: { message: 'Service created' }, status: :created
    else
      render json: {
        message: 'Something went wrong',
        errors: service.errors.full_messages
      }, status: :internal_server_error
    end
  end

  def update
    if @service.update(service_params)
      render json: { message: 'Service updated' }, status: :ok
    else
      render json: {
        message: 'Something went wrong',
        errors: @service.errors.full_messages
      }, status: :internal_server_error
    end
  end

  def destroy
    if @service.destroy
      render json: { message: 'Service removed' }, status: :ok
    else
      render json: {
        message: 'Something went wrong',
        errors: @service.errors.full_messages
      }, status: :internal_server_error
    end
  end

  private

  def service_params
    params.require(:service).permit(:name)
  end

  def set_service
    @service = Service.find_by(id: params[:id])
    return if @service

    render json: { message: 'Service not found' }, status: :not_found
  end
end

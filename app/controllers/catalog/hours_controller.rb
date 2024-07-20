class Catalog::HoursController < ApplicationController
  before_action :set_catalog_hour, only: %i[show update destroy]

  def index
    render json: Catalog::Hour.all
  end

  def show
    render json: @catalog_hour
  end

  def create
    catalog_hour = Catalog::Hour.new(catalog_hour_params)

    if catalog_hour.save
      render json: { message: 'hour created' }, status: :created
    else
      render json: {
        message: 'Something went wrong',
        errors: catalog_hour.errors.full_messages
      }, status: :internal_server_error
    end
  end

  def update
    if @catalog_hour.update(catalog_hour_params)
      render json: { message: 'hour updated' }, status: :ok
    else
      render json: {
        message: 'Something went wrong',
        errors: @catalog_hour.errors.full_messages
      }, status: :internal_server_error
    end
  end

  def destroy
    if @catalog_hour.destroy
      render json: { message: 'hour removed' }, status: :ok
    else
      render json: {
        message: 'Something went wrong',
        errors: @catalog_hour.errors.full_messages
      }, status: :internal_server_error
    end
  end

  private

  def catalog_hour_params
    params.require(:catalog_hour).permit(
      :start_at,
      :end_at
    )
  end

  def set_catalog_hour
    @catalog_hour = Catalog::Hour.find_by(id: params[:id])
    return if @catalog_hour

    render json: { message: 'hour not found' }, status: :not_found
  end
end

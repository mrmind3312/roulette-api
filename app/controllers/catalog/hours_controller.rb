class Catalog::HoursController < ApplicationController
  before_action :set_hour, only: %i[show update destroy]

  def index
    render json: Catalog::Hour.all.map(&:show)
  end

  def show
    render json: @hour.show
  end

  def create
    hour = Catalog::Hour.new(hour_params)

    if hour.save
      render json: { message: 'hour created' }, status: :created
    else
      render json: {
        message: 'Something went wrong',
        errors: hour.errors.full_messages
      }, status: :internal_server_error
    end
  end

  def update
    if @hour.update(hour_params)
      render json: { message: 'hour updated' }, status: :ok
    else
      render json: {
        message: 'Something went wrong',
        errors: @hour.errors.full_messages
      }, status: :internal_server_error
    end
  end

  def destroy
    if @hour.destroy
      render json: { message: 'hour removed' }, status: :ok
    else
      render json: {
        message: 'Something went wrong',
        errors: @hour.errors.full_messages
      }, status: :internal_server_error
    end
  end

  private

  def hour_params
    params.require(:hour).permit(
      :start_at,
      :end_at
    )
  end

  def set_hour
    @hour = Catalog::Hour.find_by(id: params[:id])
    return if @hour

    render json: { message: 'hour not found' }, status: :not_found
  end
end

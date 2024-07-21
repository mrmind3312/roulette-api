class UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]

  def index
    render json: User.all.map(&:show)
  end

  def show
    render json: @user.show
  end

  def create
    user = User.new(user_params)

    if user.save
      render json: { message: 'User created' }, status: :created
    else
      render json: {
        message: 'Something went wrong',
        errors: service.errors.full_messages
      }, status: :internal_server_error
    end
  end

  def update
    if @user.update(user_params)
      render json: { message: 'User updated' }, status: :ok
    else
      render json: {
        message: 'Something went wrong',
        errors: @user.errors.full_messages
      }, status: :internal_server_error
    end
  end

  def destroy
    if @user.destroy
      render json: { message: 'User removed' }, status: :ok
    else
      render json: {
        message: 'Something went wrong',
        errors: @user.errors.full_messages
      }, status: :internal_server_error
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :email,
      :password,
      :password_confirmation,
      :name,
      :color
    )
  end

  def set_user
    @user = User.find_by(id: params[:id])
    return if @user

    render json: { message: 'User not found' }, status: :not_found
  end
end

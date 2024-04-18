class AddressesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  before_action :set_address, only: [:edit, :update, :destroy]

  def index
    @addresses = @user.addresses
  end

  def new
    @address = @user.addresses.build
  end

  def create
    @address = @user.addresses.build(address_params)
    if @address.save
      redirect_to user_addresses_path(@user), notice: 'Address was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @address.update(address_params)
      redirect_to user_addresses_path(@user), notice: 'Address was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @address.destroy
    redirect_to user_addresses_path(@user), notice: 'Address was successfully destroyed.'
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_address
    @address = @user.addresses.find(params[:id])
  end

  def address_params
    params.require(:address).permit(:name,:address, :city, :province, :zip)
  end
end

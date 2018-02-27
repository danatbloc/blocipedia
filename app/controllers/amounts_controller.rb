class AmountsController < ApplicationController
  before_action :check_if_user_is_admin

  def index
    @amounts = Amount.all
    # there's only one amount in the database
  end

  def new
    @amount = Amount.new
  end

  def create
    @amount = Amount.new(amount_params)

    if @amount.save

      Amount.first.destroy if Amount.all.size > 1

      flash.now[:notice] = "Price was saved."
      redirect_to amounts_path
    else
      flash.now[:notice] = "There was a problem saving the price."
      render :new
    end
  end

  def edit
    @amount = Amount.find(params[:id])
  end

  def update
    @amount = Amount.find(params[:id])

    if @amount.update(amount_params)
      flash.now[:notice] = "Price was updated."
      redirect_to amounts_path
    else
      flash.now[:notice] = "There was a problem saving the price."
      render :new
    end
  end

  private

  def amount_params
    params.require(:amount).permit(:price)
  end

end

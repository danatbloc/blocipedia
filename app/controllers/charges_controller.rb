class ChargesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_if_user_is_standard

  def new
    @price = Amount.first.price
  end

  def create
    # Creates a Stripe Customer object, for associating
   # with the charge
   customer = Stripe::Customer.create(
     email: current_user.email,
     card: params[:stripeToken]
   )

   # Where the real magic happens
   charge = Stripe::Charge.create(
     customer: customer.id, # Note -- this is NOT the user_id in your app
     amount: Amount.first.price,
     description: "Membership Upgrade - #{current_user.email}",
     currency: 'usd'
   )

   current_user.premium!

   flash[:notice] = "Membership upgraded to #{current_user.role}."

   redirect_to "/"

   # Stripe will send back CardErrors, with friendly messages
   # when something goes wrong.
   # This `rescue block` catches and displays those errors.
   rescue Stripe::CardError => e
     flash[:alert] = e.message
     redirect_to new_charge_path
  end


  private

  def check_if_user_is_standard
    return true if current_user.standard?
    flash[:notice] = "You are already upgraded."
    redirect_to "/"
  end
end

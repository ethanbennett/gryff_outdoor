class CartsController < ApplicationController
  include ActionView::Helpers::TextHelper
  before_action :set_user_and_addresses, only: [:show]

  def show
    @items = Item.item_list(@cart.contents)
    @checkout_path = path?(@user)
    @total_cost = @cart.total_cost
  end

  def path?(user)
    if user
      return view_context.link_to "Checkout", orders_path, method: "post" 
    else
      return view_context.link_to "Login or Create Account to Checkout", login_path
    end
  end

  def create
    item = Item.find(params[:item_id])
    @cart.add_item(item.id)
    session[:cart] = @cart.contents
    session[:address] = @cart.address
    flash[:notice] = "You now have #{pluralize(@cart.count_of(item.id), item.title)}."
    redirect_back fallback_location: items_path
  end

  def destroy
    @item = Item.find(params[:item_id])
    @cart.remove(@item.id)
    flash[:success] = "Successfully removed #{view_context.link_to(@item.title, item_path(@item))} from your cart."
    redirect_to cart_path(@cart)
  end

  def update
    item = Item.find(params[:item_id])
    @cart.change_quantity(item.id, params[:quantity_change])
    redirect_to cart_path(@cart)
  end

private

  def set_user_and_addresses
    if session[:user]
      @user = User.find(session[:user])
      @addresses = @user.addresses.all
    else
      @user = nil
    end
  end
end

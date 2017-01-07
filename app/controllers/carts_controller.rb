class CartsController < ApplicationController
  include ActionView::Helpers::TextHelper

  def show
    @items = @cart.contents.map do |item, quantity|
      [Item.find(item), quantity]
    end
    @checkout_msg = "Login or Create Account to Checkout"
    @checkout_msg = "Checkout" if session[:user]
    @checkout_path = login_path
    @checkout_path = orders_path if session[:user]
    @total_cost = @cart.total_cost
  end

  def create
    item = Item.find(params[:item_id])

    @cart.add_item(item.id)
    session[:cart] = @cart.contents

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
end

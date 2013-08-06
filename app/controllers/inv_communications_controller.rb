class InvCommunicationsController < ApplicationController
  respond_to :json

  # Get enrolle by autocomplete
  def enrolle
    respond_with InvEnrolle.filtered_list(params[:q]).limit(5)
  end

  # Get product by autocomplete
  def product
    respond_with InvProduct.filtered_list(params[:q]).limit(5)
  end

  # Get variety by autocomplete
  def variety
    respond_with InvVariety.filtered_list(params[:q]).limit(5)
  end

  # Get destiny by autocomplete
  def destiny
    respond_with InvDestiny.filtered_list(params[:q]).limit(5)
  end
end

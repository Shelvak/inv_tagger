class InvCommunicationsController < ApplicationController
  respond_to :json

  # Get enrolle by autocomplete
  def enrolle
    respond_with InvEnrolle.filtered_list(params[:q]).limit(5)
  end
end

class HomeController < ApplicationController
  before_action :authenticate!, only: :admin
  
  def index
    # Redirect to the Vue frontend where vue_router will handle the routing
    render template: 'layouts/app'
  end

  def admin
    if Current.user&.admin
      render template: 'layouts/admin'
    else
      redirect_to '/'
    end
  end
end

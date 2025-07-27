class HomeController < ApplicationController
  def index
    render template: 'layouts/app'
  end

  def admin
    if !Current.user.admin
      redirect_to root_path, status: :not_found
    end
    
    render template: 'layouts/admin'
  end
end

class HomeController < ApplicationController
  def index
    render template: 'layouts/app'
  end

  def admin
    render template: 'layouts/admin'
  end
end

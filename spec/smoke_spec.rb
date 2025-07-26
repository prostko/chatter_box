require 'rails_helper'

RSpec.describe "Application Smoke Test", type: :smoke do
  it "can boot the app" do
    expect(Rails.application).to be_a(Rails::Application)
    expect(Rails.env).to be_a(String)
    expect(Rails.application.routes).to be_a(ActionDispatch::Routing::RouteSet)
  end

  it "can access the Faker gem" do
    name = Faker::Name.name
    expect(name).to be_a(String)
    expect(name).not_to be_empty
    expect(name).to match(/\w+/)
  end
end

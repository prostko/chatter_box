module AuthHelper
    def sign_in(user)
        # Create a session for the user and set the cookie
        session = user.sessions.create!
        cookies.signed[:session_token] = session.id
        # Set the Current.session for the request
        Current.session = session
    end
end

RSpec.configure do |config|
  config.include AuthHelper
end
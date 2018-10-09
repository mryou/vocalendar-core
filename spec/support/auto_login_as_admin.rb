RSpec.configure do |config|
  google_email = "google-test-user@example.com"
  google_scope = 'https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/calendar https://www.googleapis.com/auth/calendar.readonly'

  admin_user_valid_attrs = Proc.new {
    email = "test-admin-user-#{rand(10000)}@example.com"
    {
      :role              => :admin,
      :name              => 'Test Admin User',
      :email             => email,
      :google_account    => email,
      :google_auth_scope => google_scope,
      :google_auth_valid => true,
    }
  }

  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:google_oauth2] = Hashie::Mash.new({
    'provider' => 'google_oauth2',
    'scope' => google_scope,
    'uid' => google_email,
    'info' => {'email' => google_email, 'name' => 'Test Admin User'},
    'credentials' => {
      'token' => '--test-atuh-token--',
      'refresh_token' => '--test-refresh-token--',
      'expires_at' => Time.now.to_i
    },
  })

  config.include Devise::Test::ControllerHelpers, :type => :controller
  config.include Devise::Test::ControllerHelpers, :type => :view

  config.before(:each, :type => :view) do
    allow(view).to receive(:user_signed_in?).and_return(true)
    allow(view).to receive(:current_user).and_return User.create(admin_user_valid_attrs.call)
  end

  config.before(:each, :type => :controller) do
    sign_in User.create(admin_user_valid_attrs.call)
    subject.current_user
    subject.instance_eval {
      @current_ability = nil
    }
  end

  config.before(:all, :type => :request) do
    @session = Hashie::Mash.new({:google_oauth2_scope => google_scope})
    get user_google_oauth2_omniauth_callback_path
  end

  # rspec-rails 3 will no longer automatically infer an example group's spec type
  # from the file location. You can explicitly opt-in to the feature using this
  # config option.
  # To explicitly tag specs without using automatic inference, set the `:type`
  # metadata manually:
  #
  #     describe ThingsController, :type => :controller do
  #       # Equivalent to being in spec/controllers
  #     end
  config.infer_spec_type_from_file_location!
end

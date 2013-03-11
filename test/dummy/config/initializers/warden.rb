Rails.configuration.middleware.use Warden::Manager do |config|
  config.default_scope = :user
end

Warden::Strategies.add :basic do
  def authenticate!
    success! if params[:login].true?
  end
end

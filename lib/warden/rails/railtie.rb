module Warden
  module Rails
    class Railtie < ::Rails::Railtie
      initializer 'warden.load_helpers' do
        ActiveSupport.on_load(:action_controller) do
          include Warden::Rails::Helpers
        end
      end
    end
  end
end
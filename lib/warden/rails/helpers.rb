module Warden
  module Rails
    module Helpers
      extend ActiveSupport::Concern

      included do
        helper_method :warden, :logged_in?, :logged_user
      end

      def warden
        request.env['warden']
      end

      def login(*args)
        warden.authenticate(*args)
      end

      def login?(*args)
        warden.authenticate?(*args)
      end

      def login!(*args)
        warden.authenticate!(*args)
      end

      def logout(*scopes)
        # Without this inspect the session does not clear.
        warden.raw_session.inspect
        warden.logout(*scopes)
      end

      def logged_in?(scope = nil)
        warden.authenticated?(scope)
      end

      def logged_user(opts = {})
        warden.user(opts)
      end

      def set_user(user, opts = {})
        warden.set_user(user, opts)
      end
    end
  end
end
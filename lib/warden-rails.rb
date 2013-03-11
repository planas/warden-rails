require 'warden'
require 'rails'

module Warden
  # A session serializer that should suit most cases
  # and avoids CookieOverflow on Rails produced by the
  # default Warden's serializer
  class SessionSerializer
    def serialize(record)
      [ record.class.name, record.id ]
    end

    def deserialize(keys)
      klass, id = keys
      klass.first(:conditions => [ :id => id ])
    end
  end

  module Mixins::Common
    def request
      @request ||= ActionDispatch.Request.new(env)
    end

    def cookies
      request.cookie_jar
    end

    def reset_session!
      request.reset_session
    end
  end
end

require 'warden/rails'

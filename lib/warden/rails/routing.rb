module ActionDispatch::Routing
  class Mapper
    def authenticated(scope = nil, block = nil)
      constraint = lambda do |request|
        request.env['warden'].authenticated?(scope) && (block.nil? || block.call(request.env['warden'].user(scope)))
      end

      constraints(constraint) do
        yield
      end
    end

    def authenticated!(args = [], block = nil)
      constraint = lambda do |request|
        request.env['warden'].authenticate?(*args) && (block.nil? || block.call(request.env['warden'].user(scope)))
      end

      constraints(constraint) do
        yield
      end
    end

    def unauthenticated(scope = nil)
      constraint = lambda do |request|
        request.env['warden'].unauthenticated?(scope)
      end

      constraints(constraint) do
        yield
      end
    end
  end
end

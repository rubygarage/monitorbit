
module Monitorbit
  class ErrorNotificationsLayer
    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, body = @app.call(env)
      request = Rack::Request.new(env)
      if status.between?(400, 600)
        ActiveSupport::Notifications.instrument(
          'monitorbit.4xx_5xx_errors',
          path: request.path,
          ip: request.ip,
          params: request.params,
          method: request.request_method,
          status: status
        )
      end

      [status, headers, body]
    end
  end
end

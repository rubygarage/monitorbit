# frozen_string_literal: true

module Monitorbit
  class ErrorsNotificationsLayer
    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, body = @app.call(env)

      if status.between?(400, 600)
        request = Rack::Request.new(env)

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

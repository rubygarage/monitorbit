require 'active_support'
require 'rack'
require 'monitorbit/errors_notifications_layer'

RSpec.describe Monitorbit::ErrorsNotificationsLayer do
  describe '#call' do
    let(:subject) { described_class.new(app) }
    let(:app) { instance_double('app') }
    let(:status) { 400 }
    let(:app_response) { [status, {}, []] }

    let(:env) { instance_double('env') }

    context 'when status is between 400 && 600' do
      let(:request) { instance_double('request', path: 'path', ip: 'ip', params: 'params', request_method: 'request_method') }

      it 'triggers monitorbit.4xx_5xx_errors event' do
        expect(app).to receive(:call).and_return(app_response)
        expect(Rack::Request).to receive(:new).and_return(request)
        expect(ActiveSupport::Notifications).to receive(:instrument).with(
          'monitorbit.4xx_5xx_errors',
          path: request.path,
          ip: request.ip,
          params: request.params,
          method: request.request_method,
          status: app_response.first
        )
        expect(subject.call(env)).to eq(app_response)
      end
    end

    context 'when status is not between 400 && 600' do
      let(:status) { 200 }

      it 'does nothing' do
        expect(app).to receive(:call).and_return(app_response)
        expect(Rack::Request).not_to receive(:new)
        expect(ActiveSupport::Notifications).not_to receive(:instrument)
        expect(subject.call(env)).to eq(app_response)
      end
    end
  end
end

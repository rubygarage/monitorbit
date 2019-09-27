class ServerErrorsController < ApplicationController
  def index
    raise [ PG::UniqueViolation ].sample
  end
end

class ClientErrorsController < ApplicationController
  def index
    raise [ ActiveRecord::RecordNotFound, ActiveRecord::RecordInvalid ].sample
  end
end

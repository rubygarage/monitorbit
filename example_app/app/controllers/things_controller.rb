class ThingsController < ApplicationController
  def index
    render json: Thing.first(50)
  end

  def show
    id = Thing.ids.sample
    render json: Thing.find(id)
  end

  def create
    render json: Thing.create(thing_params)
  end

  private

  def thing_params
    params.permit(:name)
  end
end

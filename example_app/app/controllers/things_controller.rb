class ThingsController < ApplicationController
  def index
    render json: Thing.first(50)
  end

  def show
    render json: Thing.find(params[:id]0)
  end

  def create
    render json: Thing.create(thing_params)
  end

  private

  def thing_params
    params.require(:name)
  end
end

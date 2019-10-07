class JobsController < ApplicationController
  def index
    [ EmptyJob, WaitingJob, DangerJob ].sample.send(:perform_later)
  end
end

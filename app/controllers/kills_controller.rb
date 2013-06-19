class KillsController < ApplicationController
  def log
    @kill_log = Kill.all
  end
end

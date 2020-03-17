class JoinusController < ApplicationController

  def show
    reset_session
    @ctl = Control.first(1)[0]
  end
end

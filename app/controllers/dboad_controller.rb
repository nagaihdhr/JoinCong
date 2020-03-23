class DboadController < ApplicationController
  def show
    session[:caller] = 'dboad'
    @ctl = Control.first(1)[0]
  end
end

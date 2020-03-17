class StuffController < ApplicationController
  def show
    @ctl = Control.first(1)[0]
    @stfname = params[:stfname]
    @attendants = Attendant.all.records
    @count = @attendants.inject(0) {|sum, atd|  sum += atd.mbrsutoday}
  end
end

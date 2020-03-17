class MechaController < ApplicationController
  def show
    @ctl = Control.first(1)[0]
    @attendants = Attendant.all.records
    @count = @attendants.inject(0) {|sum, atd|  sum += atd.mbrsutoday}
    @messages = Message.all
  end

  def message
    ctl = Control.find(1)
    ctl.message = params[:text]
    ctl.save
  end
end

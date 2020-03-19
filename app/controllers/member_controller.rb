class MemberController < ApplicationController

  def show
    @ctl = Control.first(1)[0]
    @members = Member.all.records
  end

  def ninzu
    @ctl = Control.first(1)[0]
    reset_session
    session[:atdname] = params['mbrname']
    session[:id] = params['id']
    @atdname = params['mbrname']
    @sankasu = params['mbrsu']
  end

  def attend
    @ctl = Control.first(1)[0]
    @atdname = session[:atdname]
    id = session[:id]
    @sankasu = params['mbrsutoday'].to_i
    session[:mbrsu] = @sankasu;
    # attendants 更新
    atd = Attend.find_by(member_id: id.to_i)
    if !!atd
      atd.update(mbrsutoday: @sankasu)
    else
      atd = Attend.create(member_id: id.to_i, status: 0, mbrsutoday: @sankasu.to_i)
    end
    @mbr_id = id

    @attendant = Attendant.find_by(member_id: @mbr_id.to_i)
    text = render_to_string partial: 'layouts/attendant', collection: [@attendant]
    ActionCable.server.broadcast 'room_channel', message: ['add', @mbr_id, text, @sankasu]

    session[:attendant_id] = atd[:id]

    @attendants = Attendant.all.records
    @count = @attendants.inject(0) {|sum, atd| sum += atd.mbrsutoday}
  end

  def updstatus
    mbr_id = params[:mbrid]
    status = params[:status]
    rec = Attend.find_by(member_id: mbr_id.to_i)
    rec.update(status: status.to_i)
  end

  def leave
    mbr_id = params[:mbrid]
    rec = Attend.find_by(member_id: mbr_id.to_i)
    if rec != nil then
      rec.destroy
    end
    ActionCable.server.broadcast 'room_channel', message: ['del', mbr_id, session[:mbrsu]]
    redirect_to :action => 'show'
  end
end

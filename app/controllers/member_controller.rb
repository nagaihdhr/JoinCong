class MemberController < ApplicationController

  def show
    @ctl = Control.first(1)[0]
    @members = Member.all.records
  end

# CRUD part
  def show4crud
    @members = Member.all.records
  end

  def edit
    mbrid = params[:mbrid].to_i
    @members = Member.find_by(id: mbrid)
    @mbrname = @members.mbrname
    @email = @members.email
    @mbrsu = @members.mbrsu
    session[:mbrid] = mbrid
  end

  def new
    @members = Member.none
    @mbrname = params[:mbrname]
    @email = ''
    @mbrsu = '1'
    session[:mbrid] = nil
    render :edit
  end

  def update
    if session[:mbrid] == nil
      # logger.debug params.inspect
      permitted = params.permit(:mbrname, :email, :mbrsu)
      member = Member.create(permitted)
      member.save
    else
      member = Member.find_by(id: session[:mbrid])
      permitted = params.permit(:mbrname, :email, :mbrsu)
      member.update(permitted)
    end
    session[:mbrid] = nil
    redirect_to :action => 'show4crud'
  end

  def delete
    member = Member.find_by(id: params[:mbrid])
    member.destroy
    redirect_to :action => 'show4crud'
  end

# Functional part
  def ninzu
    @ctl = Control.first(1)[0]
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

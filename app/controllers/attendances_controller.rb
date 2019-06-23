class AttendancesController < ApplicationController

  #before_action :ensure_correct_user, only: [:edit]

  def create
    @user = User.find(params[:user_id])
    @attendance = @user.attendances.find_by(worked_on: Date.today)
    if @attendance.started_at.nil?
      @attendance.update_attributes(started_at: current_time)
      flash[:info] = "おはようございます。"
    elsif @attendance.finished_at.nil?
      @attendance.update_attributes(finished_at: current_time)
      flash[:info] = "お疲れ様でした。"    
    else
      flash[:danger] = "トラブルがあり、登録出来ませんでした。"
    end
    redirect_to @user
  end
  
  def edit
    @user = User.find(params[:id])
    @first_day = first_day(params[:date])
    @last_day = @first_day.end_of_month
    @dates = user_attendances_month_date
  end
  
  def update
    @user = User.find(params[:id])
    if attendances_invalid?
      attendances_params.each do |id, item|
          attendance = Attendance.find(id)
          attendance.update_attributes(item)
      end
      flash[:success] = '勤怠情報を更新しました。'
      redirect_to user_url(@user, params:{first_day: params[:date]})
    else
      flash[:danger] = '不正な時間入力がありました、再入力してください。'
      redirect_to edit_attendances_path(@user, params[:date])  
    end
  end
  
  def edit_overwork_request
    @user = User.find(params[:user_id])
    @attendance = @user.attendances.find(params[:id])
  end
  
  def update_overwork_request
    @user = current_user
    @attendance = @user.attendances.find(params[:id])
    if @attendance.update_attributes(overwork_params)
      flash[:success] = "残業申請しました。"
      redirect_to user_url(@user, params:{first_day: params[:date]})
    else
      render '@user'
    end  
  end
  
  def update_month_request
    @user = current_user
    @attendance = @user.attendances.find(params[:id])
    if @attendance.update_attributes(month_request_params)
      flash[:success] = "残業申請しました。"
      redirect_to current_user
    else
      render '@user'
    end  
  end

  
    private
    
      def month_request_params
        params.require(:attendance).permit(:month_superior_id)
      end
      

      def attendances_params
        params.permit(attendances: [:started_at, :finished_at, :note, :change_tomorrow, :change_superior_id])[:attendances]
      end
      
      def overwork_params
        params.require(:attendance).permit(:overwork_time, :overwork_note, :overwork_tomorrow, :overwork_superior_id)
      end
      
      
      def ensure_correct_user
        if current_user.id != params[:id].to_i && !current_user.admin?
          flash[:danger] = "そのアクセスはできません。"
          redirect_to current_user
        end
      end
end

class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:destroy, :edit_basic_info, :update_basic_info]
  before_action :ensure_correct_user, only: [:show]
  
  def index
    @users = User.paginate(page: params[:page]).search(params[:search])
  end
  
  def import
    # fileはtmpに自動で一時保存される
    if params[:file].blank?
      flash[:danger] = "インポートするCSVファイルを選択してください。"
      redirect_to users_url
    elsif File.extname(params[:file].original_filename) != ".csv"
      flash[:danger] = "ＣＳＶファイルのみインポートが可能です。"
      redirect_to users_url      
    else
      User.import(params[:file])
      flash[:success] = "CSVファイルをインポートしました。"
      redirect_to users_url
    end
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = "データに不備があります。"
      redirect_to users_url
    
  end

  def show
    @user = User.find(params[:id])
    @first_day = first_day(params[:first_day])
    @last_day = @first_day.end_of_month
    (@first_day..@last_day).each do |day|
      unless @user.attendances.any? {|attendance| attendance.worked_on == day}
        record = @user.attendances.build(worked_on: day)
        record.save
      end
    end
    @dates = user_attendances_month_date
    @worked_sum = @dates.where.not(started_at: nil).count
    @user.code = @user.id
    respond_to do |format|
      format.html do
      end 
      format.csv do
        send_data render_to_string, filename: "#{@user.name}.csv", type: :csv
      end
    end
  end
  

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "ユーザーの新規作成に成功しました。"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "削除しました。"
    redirect_to users_url
  end
  
  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def edit_basic_info
    @user = User.find(params[:id])
  end

  def update_basic_info
    @user = User.find(params[:id])
    if @user.update_attributes(basic_info_params)
      flash[:success] = "基本情報を更新しました。"
      redirect_to @user
    else
      render 'edit_basic_info'
    end
  end

  private

    def basic_info_params
      params.require(:user).permit(:basic_time, :work_time)
    end
  
    def user_params
      params.require(:user).permit(:name, :email, :department, :password, :password_confirmation, :basic_time, :work_time, :code, :basic_start_time, :basic_finish_time, :uid )
    end

    # beforeアクション

    # ログイン済みユーザーか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください。"
        redirect_to login_url
      end
    end

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user) || current_user.admin?
    end
    
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
    
    def superior_user
      redirect_to(root_url) unless current_user.superior?
    end
    
    def ensure_correct_user
      if current_user.id != params[:id].to_i && !current_user.admin?
        flash[:danger] = "そのアクセスはできません。"
        redirect_to current_user
      end
    end

    
end
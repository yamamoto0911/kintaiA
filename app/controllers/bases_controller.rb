class BasesController < ApplicationController
before_action :admin_user

  def index
    @bases = Base.all
  end
  
  def new 
	@base = Base.new
    respond_to do |format| 
      format.html{ redirect_to @base, notice: '拠点が追加されました。' }
      format.js {} 
    end
  end
  
  
  def create
    @base = Base.new(base_params)
    if @base.save
      flash[:success] = "拠点が追加されました。"
    else
      flash[:danger] = "拠点の追加に失敗しました。" 
    end
    redirect_to bases_url
  end
  
  def edit_base_info
    @base = Base.find(params[:id])
  end

  def update_base_info
    @base = Base.find(params[:id])
    if @base.update_attributes(base_params)
      flash[:success] = "拠点情報を更新しました。"
    else
      flash[:danger] = "拠点の更新に失敗しました。" 
    end
    redirect_to bases_url
  end
  
  def destroy
    Base.find(params[:id]).destroy
    flash[:success] = "拠点を削除しました。"
    redirect_to bases_url
  end
  
  
    private

    def base_params
      params.require(:base).permit(:name, :type, :number)
    end
    
    def admin_user
      redirect_to current_user unless current_user.admin?
    end
end

class BasesController < ApplicationController

  def index
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
    respond_to do |format|
      if @base.save
        format.html { redirect_to @base, notice: '拠点が追加されました。' }
        format.json { render :show, status: :created, location: @base }
        format.js { @status = "success"}
      else
        format.html { render :new }
        format.json { render json: @base.errors, status: :unprocessable_entity }
        format.js { @status = "fail" }
      end
    end
  end
  
  
    private

    def base_params
      params.require(:base).permit(:name, :type, :number)
    end
end

module UsersHelper
 
# 基本時間などの値を、指定の書式にフォーマットして返す
  def format_basic_work_time(datetime)
    format("%.2f", ((datetime.hour * 60) + datetime.min)/60.0)
  end
  
  def superior_user_name(superior_user_id)
    return User.find(superior_user_id).name
  end
 
end


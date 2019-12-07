module AttendancesHelper
  def current_time
    Time.new(
      Time.now.year,
      Time.now.month,
      Time.now.day,
      Time.now.hour,
      Time.now.min, 0
    )
  end
  
  def working_times(started_at, finished_at)
    format("%.2f", (((finished_at - started_at) /60) / 60.0))      
  end
  
  
  def working_times_sum(seconds)
    format("%.2f", seconds / 60 / 60.0)
  end
  
  def overwork_times(designated_work_end_time, overwork_time, overwork_tomorrow)
    if overwork_tomorrow == false;
      format("%.2f", (format_basic_work_time(overwork_time).to_f - format_basic_work_time(designated_work_end_time).to_f ))
    else
      format("%.2f", (format_basic_work_time(overwork_time).to_f + 24 - format_basic_work_time(designated_work_end_time).to_f ))
    end
  end
  
  def first_day(date)
    !date.nil? ? Date.parse(date) : Date.current.beginning_of_month
  end
  
  def user_attendances_month_date
    @user.attendances.where('worked_on >= ? and worked_on <= ?', @first_day, @last_day).order('worked_on')
  end
  
  def attendance_invalid?(item)
    attendance = true
    if item[:after_started_at].blank? || item[:after_finished_at].blank?
      attendance = false
    elsif @after_started_at > @after_finished_at
      debugger
      attendance = false
    end
    return attendance
  end
end
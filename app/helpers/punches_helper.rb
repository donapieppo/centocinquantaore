module PunchesHelper

  # options[:min] e' un fixnum
  def select_hour_minute2(options)
    options[:hour] ||= "12"
    options[:min]  ||= "00"
    options[:name] ||= ""
    # in arrivo arrotondo in difetto e in partenza in eccesso... come siamo dannatamente buoni!!!!
    options[:min] = (options[:name] == 'arrival_') ? ( options[:min] / 10 ) * 10 : ( (options[:min] + 9) / 10 ) * 10
    select_tag("#{options[:name]}hour", options_for_select((06..22), options[:hour])) + " : " +
    select_tag("#{options[:name]}min", options_for_select(["00", "10", "20", "30", "40", "50"], options[:min]))
  end

  def select_hour_minute(hour, min = 00)
    select_tag(:hour, options_for_select((06..22), hour)) + " : " +
    select_tag(:min, options_for_select(["00", "10", "20", "30", "40", "50"], min))
  end

end


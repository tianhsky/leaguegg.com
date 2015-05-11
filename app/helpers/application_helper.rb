module ApplicationHelper

  def decimal(number, round)
    if number
      number.round(round)
    else
      '-'
    end
  end

  def percentage(number, round)
    if number
      "#{(number*100).round(round)}%"
    else
      '-'
    end
  end

end

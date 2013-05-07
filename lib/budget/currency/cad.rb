module Budget::Currency::CAD

  def curr_format(amt)
    dollars = amt.abs / 100
    cents = amt.abs % 100
    sign = amt < 0 ? '-' : ''
    "%s%d.%02d" % [sign, dollars, cents]
  end

  def curr_parse(str)
    if str =~ /\A-?\d*\.\d\d\Z/
      str.sub('.', '').to_i
    elsif str =~ /\A-?\d+\Z/
      str.to_i*100
    else
      raise "invalid currency amount: #{str}"
    end
  end

end
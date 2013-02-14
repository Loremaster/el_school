class Statistic
  def self.pupil_quality(pupil)
    marks = pupil.estimations

    unless marks.empty?
      nominals = marks.collect{ |m| m.nominal }
      positive_nominals = nominals.count{ |m| m == 5 or m == 4 }
      positive_nominals / nominals.size.to_f                                                        # Convert on value to float to get flot value.
    else
      0                                                                                             # If there is no marks then orin 0.
    end
  end
end

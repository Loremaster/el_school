class Statistic
  def self.pupil_quality(pupil)
    marks = pupil.estimations

    unless marks.empty?
      nominals = marks.collect{ |m| m.nominal }
      nominals.count{ |m| m == 5 or m == 4 }
    else
      0                                                                                             # If there is no marks then orin 0.
    end
  end
end

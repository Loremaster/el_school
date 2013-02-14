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

  # Level of pupil's skill in the class:
  # (number of "5" + number of "4" * 0,64 + number of "3" * 0,36) / number of pupils in the class.
  # => 0 - if pupil don't have estimation.
  # => Number - otherwise.
  def self.pupil_skilled_level(pupil)
    marks = pupil.estimations
    pupils_in_class = pupil.school_class.pupils.size

    unless marks.empty?
      nominals = marks.collect{ |m| m.nominal }
      five_nominals = nominals.count(5)
      four_nominals = nominals.count(4)
      three_nominals = nominals.count(3)

      (five_nominals + five_nominals * 0.64 + three_nominals * 0.36) / pupils_in_class
    else
      0
    end
  end
end

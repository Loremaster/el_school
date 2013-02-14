# encoding: UTF-8
class Statistic

  # Quality of knowledge of pupil.
  # (number of "4" + number of "5") / number of all pupil's marks.
  # => "Нет оценок" - if pupil don't have estimation.
  # => Number - otherwise.
  def self.pupil_quality(pupil)
    marks = pupil.estimations

    unless marks.empty?
      nominals = marks.collect{ |m| m.nominal }
      positive_nominals = nominals.count{ |m| m == 5 or m == 4 }
      (positive_nominals / nominals.size.to_f).round(3)                                             # Convert on value to float to get flot value.
    else
      "Нет оценок"
    end
  end

  # Level of pupil's skill in the class:
  # (number of "5" + number of "4" * 0,64 + number of "3" * 0,36) / number of pupils in the class.
  # => "Нет оценок" - if pupil don't have estimation.
  # => Number - otherwise.
  def self.pupil_skilled_level(pupil)
    marks = pupil.estimations
    pupils_in_class = pupil.school_class.pupils.size

    unless marks.empty?
      nominals = marks.collect{ |m| m.nominal }
      five_nominals = nominals.count(5)
      four_nominals = nominals.count(4)
      three_nominals = nominals.count(3)

      ((five_nominals + five_nominals * 0.64 + three_nominals * 0.36) / pupils_in_class).round(3)
    else
      "Нет оценок"
    end
  end

  # Quality of knowledge in the class.
  # (number of "4" in class + number of "5" in class) / number of class's marks.
  # => "Нет оценок" - if pupil don't have estimation.
  # => Number - otherwise.
  def self.class_quality( school_class )
    class_nominals = school_class.estimations

    unless class_nominals.empty?
      nominals = class_nominals.collect{ |m| m.nominal }
      positive_nominals = nominals.count{ |m| m == 5 or m == 4 }
      (positive_nominals / nominals.size.to_f).round(3)
    else
      "Нет оценок"
    end
  end

  # Level of class's skill in the class:
  # (number of class's "5" + number of class's "4" * 0,64 + number of class's "3" * 0,36) / number of pupils in the class.
  # => "Нет оценок" - if pupil don't have estimation.
  # => Number - otherwise.
  def self.class_skilled_level( school_class )
    class_nominals = school_class.estimations
    pupils_in_class = school_class.pupils.size

    unless class_nominals.empty?
      nominals = class_nominals.collect{ |m| m.nominal }
      five_nominals = nominals.count(5)
      four_nominals = nominals.count(4)
      three_nominals = nominals.count(3)

      ((five_nominals + five_nominals * 0.64 + three_nominals * 0.36) / pupils_in_class).round(3)
    else
      "Нет оценок"
    end
  end
end

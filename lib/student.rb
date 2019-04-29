class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_song = self.new
    new_song.id = row[0]
    new_song.name = row[1]
    new_song.grade = row[2]
    new_song
  end

  def self.all
    all_students_sql = <<-SQL 
      SELECT * FROM students
    SQL

    DB[:conn].execute(all_students_sql).map { |row|
      self.new_from_db(row)
    }

  end

  def self.find_by_name(name)
    student_name_sql = <<-SQL 
      SELECT * FROM students 
      WHERE name = ?
      LIMIT 1
    SQL

    DB[:conn].execute(student_name_sql, name).map { |row|
      self.new_from_db(row)
    }.first

  end

  def self.all_students_in_grade_9
    students_grade_9_sql = <<-SQL 
      SELECT * FROM students 
      WHERE grade = 9
    SQL

    DB[:conn].execute(students_grade_9_sql).map { |row|
      self.new_from_db(row)
    }

  end

  def self.all_students_in_grade_X(number)
    students_grade_x_sql = <<-SQL 
      SELECT * FROM students 
      WHERE grade = ?
    SQL

    DB[:conn].execute(students_grade_x_sql, number).map { |row|
      self.new_from_db(row)
    }

  end
  
  def self.students_below_12th_grade
    students_grade_under_12_sql = <<-SQL 
      SELECT * FROM students 
      WHERE grade < 12
    SQL

    DB[:conn].execute(students_grade_under_12_sql).map { |row|
      self.new_from_db(row)
    }

  end

  def self.first_X_students_in_grade_10(number)
    x_students_grade_10_sql = <<-SQL 
      SELECT * FROM students 
      WHERE grade = 10
      LIMIT ?
    SQL

    DB[:conn].execute(x_students_grade_10_sql, number).map { |row|
      self.new_from_db(row)
    }

  end

  def self.first_student_in_grade_10
    first_students_grade_10_sql = <<-SQL 
      SELECT * FROM students 
      WHERE grade = 10
    SQL

    DB[:conn].execute(first_students_grade_10_sql).map { |row|
      self.new_from_db(row)
    }.first

  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end

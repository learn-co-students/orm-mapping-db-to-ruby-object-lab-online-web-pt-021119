require 'pry'

class Student

attr_accessor :id, :name, :grade
@@all = []

  def self.new_from_db(row)

    @student = self.new
    @student.id = row[0]
    @student.name = row[1]
    @student.grade = row[2]
    @student

  end

  def self.all
    arry = DB[:conn].execute("SELECT * FROM students")
    arry.collect do
      |row| self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    arry = DB[:conn].execute("SELECT id, name, grade FROM students WHERE name = ? LIMIT 1", name).first
    self.new_from_db(arry)
  end

def self.all_students_in_grade_9
  DB[:conn].execute("SELECT id, name, grade FROM students WHERE grade = ?", 9)
end

def self.students_below_12th_grade
  arry = DB[:conn].execute("SELECT id, name, grade FROM students WHERE grade < ?", 12)
  arry.collect do
    |row| self.new_from_db(row)
  end

end

def self.first_X_students_in_grade_10(x)
  DB[:conn].execute("SELECT id, name, grade FROM students WHERE grade = ? LIMIT ?", 10, x)
end

def self.first_student_in_grade_10
  arry = DB[:conn].execute("SELECT id, name, grade FROM students WHERE grade = 10 LIMIT 1").first
  self.new_from_db(arry)
end

def self.all_students_in_grade_X(x)
  DB[:conn].execute("SELECT id, name, grade FROM students WHERE grade = ?", x)
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

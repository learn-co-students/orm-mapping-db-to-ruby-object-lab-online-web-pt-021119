require "pry"

class Student
  attr_accessor :id, :name, :grade

  @@all = []

  def self.new_from_db(row)
    student = Student.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    all_students = DB[:conn].execute("SELECT * FROM students")
    all_students.each do |student|
      @@all << Student.new_from_db(student)
    end
  @@all
  end

  def self.find_by_name(name)
    student = DB[:conn].execute("SELECT * FROM students WHERE name=?", name).flatten
    new_student = Student.new_from_db(student)
    new_student
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

  def self.all_students_in_grade_9
    student_nine = DB[:conn].execute("SELECT * FROM students WHERE grade = 9")
    student_nine
  end

  def self.students_below_12th_grade
    below = []
    student_twelve = DB[:conn].execute("SELECT * FROM students WHERE grade < 12").flatten
    students = Student.new_from_db(student_twelve)
    below << students
    below
  end

  def self.first_student_in_grade_10
    student_ten = DB[:conn].execute("SELECT * FROM students WHERE grade = 10").first
    first_student = Student.new_from_db(student_ten)
    first_student
  end

  def self.first_X_students_in_grade_10(x)
    ten_students = DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT ?", x)
  end

  def self.all_students_in_grade_X(x)
    all_students_grade = DB[:conn].execute("SELECT * FROM students WHERE grade = ?", x)
    all_students_grade
  end
end

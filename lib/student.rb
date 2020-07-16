require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = Student.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
    SQL
    row = DB[:conn].execute(sql, name).flatten
    Student.new_from_db(row)
  end

  def self.all_students_in_grade_9
    ary = []
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 9
    SQL
    all_in_9 = DB[:conn].execute(sql)
    ary << Student.new_from_db(all_in_9)
  end

  def self.students_below_12th_grade
    ary=[]
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade < 12
    SQL
    all_but_12th = DB[:conn].execute(sql).flatten
    ary << Student.new_from_db(all_but_12th)
  end


  def self.all
    sql = <<-SQL
      SELECT *
      FROM students
    SQL
    all_students = DB[:conn].execute(sql)
    all_students.map do |student|
      Student.new_from_db(student)
    end
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

  def self.first_X_students_in_grade_10 (num)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
      LIMIT ?
    SQL
    DB[:conn].execute(sql, num)
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
      LIMIT 1
    SQL
    first_student = DB[:conn].execute(sql).flatten
    Student.new_from_db(first_student)
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = ?
    SQL
    DB[:conn].execute(sql, grade)
  end

end

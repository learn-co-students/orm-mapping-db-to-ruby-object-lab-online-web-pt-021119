require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    Student.new.tap{|e| e.id, e.name, e.grade = row[0], row[1], row[2]}
  end

  def self.all
    all_from_db = []
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = "SELECT * FROM students"
    all_students = DB[:conn].execute(sql)
    if all_students.size > 1
      all_from_db << all_students.map{|e| self.new_from_db(e)}.flatten
    else
      all_from_db << self.new_from_db(all_students)
    end
    all_from_db.flatten
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql =  "SELECT * FROM students WHERE name = ?"
    student_row = DB[:conn].execute(sql, name).flatten
    new_student = self.new_from_db(student_row)
  end

  def self.all_students_in_grade_9
    all_in_9 = []
    sql = "SELECT * FROM students WHERE grade == 9"
    students_in_9 = DB[:conn].execute(sql)
    if students_in_9.size > 1
      all_in_9 << students_in_9.map{|e| self.new_from_db(e)}
    else
      all_in_9 << self.new_from_db(students_in_9.flatten)
    all_in_9
    end
  end

  def self.students_below_12th_grade
    all_but_12th = []
    sql = "SELECT * FROM students WHERE grade < 12"
    students_below_12 = DB[:conn].execute(sql)
    if students_below_12.size > 1
      all_but_12th << students_below_12.flatten.map{|e| self.new_from_db(e)}
    else
      all_but_12th << self.new_from_db(students_below_12.flatten)
    end
    all_but_12th
  end

  def self.first_X_students_in_grade_10(x)
    first_x_students = []
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT ?"
    x_students = DB[:conn].execute(sql, x)
    first_x_students << x_students.map {|e| self.new_from_db(e)}
    first_x_students.flatten
  end

  def self.first_student_in_grade_10
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT 1"
    find_student = DB[:conn].execute(sql)
    first_student_10 = self.new_from_db(find_student.flatten)
  end

  def self.all_students_in_grade_X(x)
    all_students_in_grade = []
    sql = "SELECT * FROM students WHERE grade = ?"
    x_students = DB[:conn].execute(sql, x)
    all_students_in_grade << x_students.map {|e| self.new_from_db(e)}
    all_students_in_grade.flatten
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

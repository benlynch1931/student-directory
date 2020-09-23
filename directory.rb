@students = [] # an empty array accessible to all methods
def interactive_menu
  loop do
    print_menu
    process(STDIN.gets.chomp)
  end
end

def print_menu
  # 1. print the menu and ask the user what to do
  puts "1. Input the students"
  puts "2. Show the students"
  puts "3. Save the list to students.csv"
  # puts "4. Load the list from students.csv"
  puts "9. Exit"
end

def process(selection)
  case selection
  when "1"
    input_students
  when "2"
    show_students
  when "3"
    save_students
  # when "4"
  #   load_students
  when "9"
    exit
  else
    puts "I don't know what you meant. Try again"
  end
end

def input_students
  puts "Please enter the names of the students"
  puts "To finish, just hit return twice"
  # get the first name
  name = STDIN.gets.chomp.capitalize
  # while the name is not empty, repeat this code
  while !name.empty? do
    # get cohort
    puts "Enter cohort: "
    cohort = STDIN.gets.chomp.capitalize
    # add the student hash to the array
    if cohort.empty?
      cohort = "TBC"
    end
    students_to_array(name, cohort)
    if @students.count == 1
      puts "Now we have #{@students.count} student"
    else
      puts "Now we have #{@students.count} students"
    end
    # get another name from the user
    name = STDIN.gets.chomp
  end
end

def students_to_array(name, cohort = "TBC")
  @students << {name: name, cohort: cohort.to_sym}
end

def show_students
  print_header
  print_students
  print_footer
end

def print_header
  puts "The students of Villains Academy".center(70, "-")
   puts "-" * 70
end

def print_students
  @students.each do |student|
    puts "#{student[:name]} (#{student[:cohort]} cohort)"
  end
end

def print_footer
  if @students.count == 1
    puts "Overall, we have #{@students.count} great student"
  else
    puts "Overall, we have #{@students.count} great students"
  end
end

def save_students
  # open the file for writing
  file = File.open("students.csv", "w")
  file_read = File.open("students.csv", "r")
  # iterate over the array of students
  @students.each do |student|
    student_data = [student[:name], student[:cohort]]
    csv_line = student_data.join(",")
    if !file_read.include? csv_line
      file.puts csv_line
    end
  end
  file.close
  puts "Students successfully saved!"
end

def load_students(filename = "students.csv")
  file = File.open(filename, "r")
  file.readlines.each do |line|
    name, cohort = line.chomp.split(',')
    students_to_array(name, cohort)
  end
  file.close
  puts "Students successfully loaded!"
end

def try_load_students
  filename = ARGV.first # first argument from cmd
  # return if filename.nil? # get out of methon if it isn't given
  if filename.nil?
    puts "which file do you want to load?"
    filename = STDIN.gets.chomp
  end
  return if filename == "none" || filename.nil?
  if File.exists?(filename) # if it exists
    load_students(filename)
    puts "Loaded #{@students.count} from #{filename}"
  else # if it doesn't exist
    puts "Sorry, #{filename} doesn't exist."
    exit # quit the program
  end
end

try_load_students
interactive_menu

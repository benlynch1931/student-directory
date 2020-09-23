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
  puts "3. Save the list"
  puts "4. Load the list"
  puts "9. Exit"
end

def process(selection)
  # different menu options and their corresponding functions
  case selection
  when "1"
    input_students
  when "2"
    show_students
  when "3"
    save_students
  when "4"
    load_students
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
    # checks to see if cohort was blank -> assumes cohort is TBC
    if cohort.empty?
      cohort = "TBC"
    end
    # checks to see if the entered student is a duplicate in the array
    @students.each do |student|
      # is the name and same cohort in the arrya already?
      if student[:name] == name && student[:cohort] == cohort.to_sym
        puts "This person already exists. Do you wish to continue?"
        continue = STDIN.gets.chomp.downcase
        # getting input option from user
        case continue
        when "yes"
          # moves down to code as if nothing was wrong ;)
          break
        else
          puts "Sending you back to the main menu..."
          print_menu
        end
      end
    end
    # add the student hash to the array
    students_to_array(name, cohort)
    # if/else depending on no. of students
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
  # Easy function for appending to student array
  @students << {name: name, cohort: cohort.to_sym}
end

def show_students
  # print all info
  print_header
  print_students
  print_footer
end

def print_header
  # centers text around 70th value, uses - rather than blanks
  puts "The students of Villains Academy".center(70, "-")
   puts "-" * 70
end

def print_students
  # iterates array and prints values from hash in formatted order
  @students.each do |student|
    puts "#{student[:name]} (#{student[:cohort]} cohort)"
  end
end

def print_footer
  # prints number of students
  if @students.count == 1
    puts "Overall, we have #{@students.count} great student"
  else
    puts "Overall, we have #{@students.count} great students"
  end
end

def save_students
  # variable assigned at start up. Identifies if file was given or not
  # if filename was given, it will continue. Otherwise it warns of duplication
  # WILL ALWAYS LOAD AND WRITE TO SAVE FILE. CANNOT LOAD ONE AND SAVE TO OTHER
  if @given_file == false
    puts "No file was loaded so there is a chance for duplicate students"
    puts "put 'exit' to quit, or type the filename to continue: "
    option = STDIN.gets.chomp
    if option == "exit"
      exit
    else
      # sets filename variable to name of file the user inputs
      filename = option
    end
  else
    # sets filename to GVariable set on startup when file  was inputted
    filename = @filename
  end
  # open the file for writing
  file = File.open(filename, "w")
  # iterate over the array of students
  @students.each do |student|
    student_data = [student[:name], student[:cohort]]
    csv_line = student_data.join(",")
    # puts() with period writes to file rather than prints to screen
    file.puts csv_line
  end
  # ALWAYS close the file
  file.close
  # Message as assurance for user
  puts "Students successfully saved!"
end

def load_students
  # THIS FUNCTION IS CALLED AT STARTUP AS WELL AS MANUALLY BY USER
  # Same idea as "save students"
  # GVariable assigned at startup to differentiate possibility of duplication
  # and need of inputting a filename
  # WILL ALWAYS LOAD AND WRITE TO SAVE FILE. CANNOT LOAD ONE AND SAVE TO OTHER
  if @given_file == false
    puts "No file was given at startup. There is a chance for duplicate students."
    puts "Do you wish to continue?"
    # Check if user wants to continue with chance of duplication
    continue = STDIN.gets.chomp
    case continue
    when "yes"
      # entering the filename as not stated at startup
      puts "Please enter the filename to load: "
      filename = STDIN.gets.chomp
      # continues past 'case' and onto loading the file
    when "no"
      puts "Back to the main menu..."
      print_menu
    when "exit"
      exit
    else
      puts "That was not an option. Back to the main menu..."
      print_menu
    end
  else
    # filename given at startup so assigning it for the loading
    filename = @filename
  end
  #  'r' as reading not writing
  file = File.open(filename, "r")
  # read each line in turn and split up into variables and append to array
  file.readlines.each do |line|
    name, cohort = line.chomp.split(',')
    students_to_array(name, cohort)
  end
  file.close
  puts "Students successfully loaded!"
end

def try_load_students
  @filename = ARGV.first # first argument from cmd
  # return if filename.nil? # get out of methon if it isn't given
  # if no filename used when calling program:
  if @filename.nil?
    # option to enter file on startup
    puts "which file do you want to load? (Type 'none' to not load a file)"
    @filename = STDIN.gets.chomp
  end
  # if 'none', no filename given
  if @filename == "none"
    # sets the GVariable to false as no file
    @given_file = false
    return
  end
  if File.exists?(@filename) # if it exists
    load_students
    puts "Loaded #{@students.count} from #{@filename}"
    # sets GVariable to true as file given
    @given_file = true
    filename = @filename
  else # if it doesn't exist
    puts "Sorry, #{@filename} doesn't exist."
    exit # quit the program
  end
end

# on startup, load these functions in turn
try_load_students
interactive_menu

# EXERCISES!!!!!!


def input_students
  puts "Please enter the names of the students"
  puts "To finish, just hit return twice"
  # Create an empty array
  students = []
  # get the first name
  name = gets.chomp
  # while the name is not empty, repeat this code
  while !name.empty? do
    # get cohort
    puts "Enter cohort: "
    cohort = gets.chomp
    # add the student hash to the array
    if cohort == ""
      students << {name: name.capitalize, cohort: "TBC"}
    else
      students << {name: name.capitalize, cohort: cohort.capitalize.to_sym}
    end
    if students.count == 1
      puts "Now we have #{students.count} student"
    else
      puts "Now we have #{students.count} students"
    end
    # get another name from the user
    name = gets.gsub("\n", "")
  end
  # return the array of students
  return students
end

def print_header
  puts "The students of Villains Academy"
  puts "--------------"
end
def print_students(students)
  if students.length >= 1
    # puts "Please enter a letter to search by: "
    # letter = gets.chomp
    students.each_with_index do |student, idx|
      # if student[:name][0].downcase == "b"
      # if student[:name][0].downcase == letter
      if student[:name].length < 12
        puts "#{idx + 1}. #{student[:name]} (#{student[:cohort]} cohort)"
      end
    end
  end
end
def print_footer(names)
  puts "Overall, we have #{names.count} great students"
end

def print_by_cohort(students)
  cohorts = []
  students.each do |student|
    if !cohorts.include? student[:cohort]
      cohorts.push(student[:cohort])
    end
  end
  cohorts.each do |cohort|
    puts "#{cohort}".center(20)
    students.each do |student|
      puts "#{student[:name]}" if student[:cohort] == cohort
    end
    puts ""
  end
end

students = input_students
print_header
# print_students(students)
print_by_cohort(students)
print_footer(students)

require 'date'
require_relative 'task-mangement'

def print_menu
 puts "\n=== Task Scheduler  ==="
 puts "1. Create new task"
 puts "2. View all tasks"
 puts "3. Update task"
 puts "4. Delete task"
 puts "5. View high priority tasks"
 puts "6. View overdue tasks"
 puts "7. Exit"
 print "\nSelect an option (1-7): "
end

def get_date
 begin
   print "Enter deadline (YYYY-MM-DD): "
   Date.parse(gets.chomp)
 rescue ArgumentError
   puts "Invalid date format. Please use YYYY-MM-DD"
   retry
 end
end

scheduler = TaskScheduler.new

loop do
 print_menu
 choice = gets.chomp

 case choice
 when "1"
   print "Enter task description: "
   description = gets.chomp
   deadline = get_date
   print "Enter priority (high/medium/low): "
   priority = gets.chomp.downcase
   scheduler.create_task(description, deadline, priority)
   puts "Task created successfully!"
   
   

 when "2"
   puts "\nAll Tasks:"
   scheduler.read_tasks.each do |task|
     puts "Description: #{task.description}"
     puts "Deadline: #{task.deadline}"
     puts "Priority: #{task.priority}"
     puts "-----------------"
   end

 when "3"
   print "Enter task description to update: "
   description = gets.chomp
   print "What to update? (deadline/priority): "
   field = gets.chomp.downcase
   
   case field
   when "deadline"
     deadline = get_date
     scheduler.update_task(description, deadline: deadline)
   when "priority"
     print "Enter new priority (high/medium/low): "
     priority = gets.chomp
     scheduler.update_task(description, priority: priority)
   end
   puts "Task updated successfully!"

 when "4"
   print "Enter task description to delete: "
   description = gets.chomp
   scheduler.delete_task(description)
   puts "Task deleted successfully!"

 when "5"
   puts "\nHigh Priority Tasks:"
   scheduler.filter_by_priority("high") do |tasks|
     tasks.each do |task|
       puts "#{task.description} - Due: #{task.deadline}"
     end
   end

 when "6"
   puts "\nOverdue Tasks:"
   scheduler.overdue_tasks do |tasks|
     tasks.each do |task|
       puts "#{task.description} - Was due: #{task.deadline}"
     end
   end

 when "7"
   puts "Goodbye!"
   break

 else
   puts "Invalid option. Please try again."
 end
end
Task = Struct.new(:description, :deadline, :priority) do
  
  def to_s
    "Description : #{description}, Deadline : #{deadline}, Priority : #{deadline}"
  end
end

class TaskScheduler
 def initialize(file_path = 'tasks.txt')
   @file_path = file_path
 end

 def create_task(description, deadline, priority)
   begin
     task = Task.new(description, deadline, priority)
     tasks = read_tasks
     tasks << task
     save_tasks(tasks)
     task
   rescue StandardError => e
     raise "Error creating task: #{e.message}"
   end
 end

 def read_tasks
   begin
     if File.exist?(@file_path)
       tasks = []
       File.foreach(@file_path) do |line|
         description, deadline, priority = line.chomp.split('|')
         tasks << Task.new(description,Date.parse(deadline),priority)
       end
       tasks
     else
       []
     end
   rescue StandardError => e
     raise "Error reading tasks: #{e.message}"
   end
 end

 def update_task(description, attributes = {})

   begin
     tasks = read_tasks
     task = tasks.find { |t| t.description == description }
     raise "Task not found" unless task

     attributes.each do |key, value|
       if task.members.include?(key)
         task[key] = value
       end
     end
     
     save_tasks(tasks)
     task
   rescue StandardError => e
     raise "Error updating task: #{e.message}"
   end
 end

 def delete_task(description)
   begin
     tasks = read_tasks
     tasks.reject! { |task| task.description == description }
     save_tasks(tasks)
   rescue StandardError => e
     raise "Error deleting task: #{e.message}"
   end
 end

  def save_tasks(tasks)
    begin
      File.open(@file_path, 'w') do |file|
        tasks.each do |task|
          file.puts "#{task.description}|#{task.deadline}|#{task.priority}"
        end
      end
    rescue IOError => e
      raise "Error while"

    end
    
    
  end

 def overdue_tasks(&block)
   tasks = read_tasks.select { |task| task.deadline < Date.today }
   block.call(tasks) if block_given?
   tasks
 end

 def filter_by_priority(priority, &block)
   tasks = read_tasks.select { |task| task.priority == priority }
   block.call(tasks) if block_given?
   tasks
 end
end
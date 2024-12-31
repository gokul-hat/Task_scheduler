require 'rspec'
require 'date'
require_relative '../task-mangement'

RSpec.describe TaskScheduler do
 let(:scheduler) { TaskScheduler.new('test_tasks.txt') }
 
 before(:each) do
   File.delete('test_tasks.txt') if File.exist?('test_tasks.txt')
 end

 describe '#create_task' do
   it 'creates a new task' do
     task = scheduler.create_task('Learn Ruby', Date.today, 'high')
     expect(task.description).to eq('Learn Ruby')
     expect(task.priority).to eq('high')
   end
 end

 describe '#read_tasks' do
   it 'returns empty array when no tasks exist' do
     expect(scheduler.read_tasks).to be_empty
   end

   it 'returns array of tasks when tasks exist' do
     scheduler.create_task('Learn Ruby', Date.today, 'high')
     tasks = scheduler.read_tasks
     expect(tasks.length).to eq(1)
     expect(tasks.first.description).to eq('Learn Ruby')
   end
 end

 describe '#update_task' do
   it 'updates task attributes' do
     scheduler.create_task('Learn Ruby', Date.today, 'high')
     updated_task = scheduler.update_task('Learn Ruby', priority: 'low')
     expect(updated_task.priority).to eq('low')
   end

   it 'raises error for non-existent task' do
     expect { scheduler.update_task('Nonexistent Task') }.to raise_error(/Task not found/)
   end
 end

 describe '#delete_task' do
   it 'removes task from storage' do
     scheduler.create_task('Learn Ruby', Date.today, 'high')
     scheduler.delete_task('Learn Ruby')
     expect(scheduler.read_tasks).to be_empty
   end
 end

 describe '#overdue_tasks' do
   it 'returns overdue tasks' do
     scheduler.create_task('Overdue Task', Date.today - 1, 'high')
     scheduler.create_task('Future Task', Date.today + 1, 'high')
     
     overdue = scheduler.overdue_tasks
     expect(overdue.length).to eq(1)
     expect(overdue.first.description).to eq('Overdue Task')
   end
 end

 describe '#filter_by_priority' do
   it 'returns tasks with specified priority' do
     scheduler.create_task('High Task', Date.today, 'high')
     scheduler.create_task('Low Task', Date.today, 'low')
     
     high_priority = scheduler.filter_by_priority('high')
     expect(high_priority.length).to eq(1)
     expect(high_priority.first.description).to eq('High Task')
   end
 end
end
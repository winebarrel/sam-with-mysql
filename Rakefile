# frozen_string_literal: true

require 'rubocop/rake_task'

Dir.glob('tasks/*.rake').each do |tasks|
  load tasks
end

RuboCop::RakeTask.new do |task|
  task.options = %w[-c .rubocop.yml]
end

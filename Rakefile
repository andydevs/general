=begin 

Program: Roject

Roject is a programming project manager written in Ruby.
With Roject, you can create and edit projects based on templates
using simple commands without a heavy IDE.

Author:  Anshul Kharbanda
Created: 7 - 8 - 2016

=end

# Required libraries
require "rspec/core/rake_task"
require "rubygems/tasks"
require "fileutils"

# Directories
SPECDIR = "spec"

# Default Task
task :default => :spec

# RSpec Tasks
RSpec::Core::RakeTask.new do |task|
	task.pattern    = "#{SPECDIR}/*.spec.rb"
	task.rspec_opts = "--format documentation --color"
end

# Gem Tasks
namespace :gem do
	Gem::Tasks.new
end

# Git Tasks
namespace :git do
	desc "Push changes to remote"
	task :push, [:message] => :commit do
		sh "git push origin master"
	end

	desc "Commit changes"
	task :commit, [:message] do |task, args|
		sh "git add --all"
		sh "git commit -m #{args[:message].inspect}"
	end

	desc "Ammend recent commit"
	task :ammend, [:messave] do |task, args|
		sh "git commit --ammend"
	end

	desc "Soft git reset"
	task :reset do
		sh "git reset"
	end

	desc "Hard git reset"
	task :hardreset do
		sh "git reset --hard HEAD"
	end
end
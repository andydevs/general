require_relative "general"

general = General::GIO.load "source.general"
puts
puts general.instance_variable_get(:@partials).collect(&:inspect)
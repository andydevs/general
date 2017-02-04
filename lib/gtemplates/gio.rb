# General is a templating system in ruby
# Copyright (C) 2016  Anshul Kharbanda
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require_relative "gtemplate"
require_relative "gmeta"
require_relative "../gerror"
require_relative "../gprepartials/gpretext"
require_relative "../gprepartials/ginclude"
require_relative "../gprepartials/gextend"
require_relative "../gprepartials/gyield"

# General is a templating system in ruby
#
# Author: Anshul Kharbanda
# Created: 3 - 4 - 2016
module General
	# Implements the general IO writer template
	#
	# Author: Anshul Kharbanda
	# Created: 3 - 4 - 2016
	class GIO < GTemplate
		# The general file extension
		EXTENSION = ".general"

		# Public read source
		attr :source

		# Loads a GIO from a file with the given path
		#
		# Parameter: path - the path of the file to load
		#
		# Return: GIO loaded from the file
		def self.load path
			# Get current working directory
			cwd = Dir.getwd

			# Change to path of file
			Dir.chdir File.dirname(path)

			# Read raw text
			string = IO.read File.basename(path)

			# Prepartial types
			ptypes = [
				General::GExtend,
				General::GInclude,
				General::GYield,
				General::GPretext
			]

			# Breakdown algorithm
			preparts = []
			m = nil
			while string.length > 0
				# Match the front of the string to a preprocessor
				prepart = ptypes.find { |ptype| m = ptype::REGEX.match(string) }

				# Raise error if no matching prepart can be found
				if prepart.nil?
					Dir.chdir cwd # Make sure to change back to current directory
					raise GError.new "Unmatched prepartial at #{(string.length <= 5 ? string : string[0..5] + "...").inspect}"
				end

				# Add the partial to the array
				preparts << prepart.new(m)

				# Trim the front of the string
				string = string[m.end(0)..-1]
			end

			# Find an extend
			extindex = preparts.index{ |prepart| prepart.is_a? General::GExtend }

			# Run extend algorithm (throw error if extend is found elsewhere)
			if extindex == 0
				preparts = GMeta.load(preparts[extindex].filename+General::GIO::EXTENSION).gextend(preparts[1..-1])
			elsif !extindex.nil?
				Dir.chdir cwd # Make sure to change back to current directory
				raise GError.new "@@extend prepartial needs to be at beginning of template."
			end

			# Find a yield
			yindex = preparts.index{ |prepart| prepart.is_a? General::GYield }

			# Raise error if yield is found
			unless yindex.nil?
				Dir.chdir cwd # Make sure to change back to current directory
				raise GError.new "#{path} is a meta template and cannot be parsed. Must be extended by other GIO template"
			end

			# Combine text
			text = preparts.collect{ |prepart| prepart.apply }.join

			# Change to current directory
			Dir.chdir cwd

			# Return new GIO
			return self.new text, path
		end

		# Creates a GIO with the given template string and source filename
		#
		# Parameter: string - the string being converted to a template
		# Parameter: source - the name of the source file of the template
		def initialize string, source=nil
			super string
			@source = source
		end

		# Writes the template with the given data applied to the target stream
		#
		# Parameter: ios  - if String, is the name of the file to write to
		# 					if IO, is the stream to write to
		# Parameter: data - the data to be applied (merges with defaults)
		def write ios, data={}
			if ios.is_a? String
				IO.write ios, apply(data)
			elsif ios.is_a? IO
				ios.write apply(data)
			else
				raise TypeError.new "Expected IO or String, got: #{ios.class}"
			end
		end
	end
end
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

		# Loads a GIO from a file with the given path
		#
		# Parameter: path - the path of the file to load
		#
		# Return: GIO loaded from the file
		def self.load path
			file = File.new path
			gio = self.new file.read
			file.close
			return gio
		end

		# Writes the template with the given 
		# data applied to the target stream
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
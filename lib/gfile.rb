# Generic is a templating system in ruby
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

# Generic is a templating system in ruby
#
# Author: Anshul Kharbanda
# Created: 3 - 4 - 2016
module Generic
	# Implements the generic file IO
	#
	# Author: Anshul Kharbanda
	# Created: 3 - 4 - 2016
	class GFile
		# The generic file extention
		EXTENTION = ".generic"

		# Can write to attributes "name" and "path"
		#
		# "name" is the name of the target file
		#
		# "path" is the path of the target file
		attr_writer :name, :path

		# Creates a new GFile with the given path
		#
		# Paraeter: path the path to the GFile
		def initialize path
			@name = File.basename path, EXTENTION
			@path = File.dirname path
			@generic = Generic::GTemplate.new IO.read path
		end

		# Returns the path of the target file
		#
		# Return: the path of the target file
		def target
			@path + "/" + @name	
		end

		# Writes the generic with the given 
		# data applied to the target file
		#
		# Parameter: data - the data to be applied (merges with defaults)
		def write data={}
			IO.write target, @generic.apply(data)
		end

		# Returns the string representation of the GFile
		#
		# Return: the string representation of the GFile
		def to_s
			"#{@generic} >>> #{target}"
		end
	end
end
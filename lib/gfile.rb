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
	# Implements the general file IO
	#
	# Author: Anshul Kharbanda
	# Created: 3 - 4 - 2016
	class GFile
		# The general file extention
		EXTENTION = ".general"

		# Can read and write target file
		attr_accessor :target

		# Creates a new GFile with the given path
		#
		# Paraeter: path the path to the GFile
		def initialize path
			@template = General::GTemplate.new IO.read path
			@target = path.gsub(/.general\z/, "")
		end

		# Writes the template with the given 
		# data applied to the target file
		#
		# Parameter: data - the data to be applied 
		# 					(merges with defaults)
		def write(data={}); IO.write target, @template.apply(data); end
	end
end
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

# Imports
require_relative "../gtemplates/gio"

# General is a templating system in ruby
#
# Author: Anshul Kharbanda
# Created: 3 - 4 - 2016
module General
	# Includes another file in the template
	#
	# Author: Anshul Kharbanda
	# Created: 1 - 30 - 2017
	class GPrePartial
		# Creates a new GPrePartial
		#
		# Parameters: match - the match result returned from the parser
		def initialize(match); @text = match.to_s; end

		# Applies the GPrePartial
		#
		# Return: the value returned from the executed GPrePartial
		def apply; @text; end

		# Returns the string representation of the GPrePartial
		#
		# Return: the string representation of the GPrePartial
		def to_s; @text; end
	end
end
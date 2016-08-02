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

# General is a templating system in ruby
#
# Author: Anshul Kharbanda
# Created: 3 - 4 - 2016
module General
	# A unit of the GTemplate. Returns a string based on an argument hash
	# When GTemplate is applied
	#
	# Author:  Anshul Kharbanda
	# Created: 7 - 29 - 2016
	class GPartial
		protected

		# Regular expression that matches placeholder names
		NAME = /(?<name>[a-zA-Z]\w*)/

		public

		# Get name
		attr :name

		# Initializes the GPartial with the given object
		#
		# Parameter: obj - the object containing information for the partial
		def initialize(obj); @name = obj[:name].to_sym; end
	end
end
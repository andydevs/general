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
	# Represents an abstract meta file
	#
	# Author: Anshul Kharbanda
	# Created: 1 - 31 - 2016
	class GMeta < GTemplate
		def self.load path
			# Read file
			string = IO.read path

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
			loop do
				# Match the front of the string to a preprocessor
				prepart = ptypes.find { |ptype| m = ptype::REGEX.match(string) }

				# Raise error if no matching prepart can be found
				if prepart.nil?
					raise GError.new "Unmatched prepartial at #{(string.length <= 5 ? string : string[0..5] + "...").inspect}"
				end

				# Add the partial to the array
				preparts << prepart.new(m)

				# Trim the front of the string
				string = string[m.end(0)..-1]

				# End when string is empty
				break if string.length == 0
			end

			# Find an extend
			extindex = preparts.index { |prepart| prepart.is_a? General::GExtend }

			# Run extend algorithm (throw error if extend is found elsewhere)
			if extindex == 0
				preparts = GMeta.load(preparts[extindex].filename+General::GIO::EXTENSION).gextend(preparts[1..-1])
			elsif !extindex.nil? && extindex > 0
				raise GError.new "@@extend prepartial needs to be at beginning of template."
			end

			# Check for multiple yields
			yields = preparts.find_all{ |prepart| prepart.is_a? General::GYield  }
			if yields.length > 1
				raise GError.new "@@yield prepartial can only appear ONCE!"
			end

			# Find the yield
			yindex = preparts.index{ |prepart| prepart.is_a? General::GYield }

			# Return a new meta file if yield is found. Else default is end.
			unless yindex.nil?
				return self.new preparts[0...yindex], preparts[(yindex + 1)..-1], path
			else
				return self.new preparts, [], path
			end
		end

		# Creates a new GMeta
		#
		# Parameter: top    - the top end of the meta (in preparts)
		# Parameter: bottom - the bottom end of the data (in preparts)
		# Parameter: source - the source of the file
		def initialize top, bottom, source=nil
			@top    = top
			@bottom = bottom
			@source = source
		end

		# Extends the given preparts from the GMeta
		#
		# Parameter: preparts - the preparts array to extend
		#
		# Returns: the extended preparts
		def gextend preparts
			return @top + preparts + [General::GPretext.new("\r\n")] + @bottom
		end
	end
end
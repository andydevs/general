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

require_relative "spec_require"

# Describe General::GSpecial
# 
# Represents a special character in a GTemplate
#
# Author:  Anshul Kharbanda
# Created: 7 - 1 - 2016
describe General::GSpecial do
	before :all do
		@text    = "@"
		@regex   = "@"
		@partial = General::GSpecial.new key: "at"
	end

	# Describe General::GSpecial::new
	# 
	# Creates the GSpecial with the given match
	#
	# Parameter: match - the match object of the GSpecial
	describe '::new' do
		it 'creates the GSpecial with the given match object' do
			expect(@partial).to be_an_instance_of General::GSpecial
			expect(@partial.name).to eql General::GSpecial::PTNAME
			expect(@partial.instance_variable_get :@text).to eql @text
		end
	end
end
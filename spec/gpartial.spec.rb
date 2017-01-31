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

# Describe General::GPartial
# 
# A unit of the GTemplate. Returns a string based on an argument hash
# When GTemplate is applied
#
# Author:  Anshul Kharbanda
# Created: 7 - 29 - 2016
describe General::GPartial do
	before :all do
		@name = :partial_name
		@partial = General::GPartial.new name: @name
	end

	# Describe General::GPartial::new
	#
	# Creates the GPartial with the given object
	#
	# Parameter: obj - the object containing information for the partial
	describe '::new' do
		it 'creates the GPartial wih the given object' do
			expect(@partial).to be_an_instance_of General::GPartial
			expect(@partial.instance_variable_get :@name).to eql @name
		end
	end

	# Describe General::GPartial#name
	#
	# Returns the name of the partial
	#
	# Return: the name of the partial
	describe '#name' do
		it 'returns the name of the GPartial' do
			expect(@partial.name).to eql @name
		end
	end
end
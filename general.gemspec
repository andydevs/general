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

Gem::Specification.new do |spec|
	spec.name        = "general"
	spec.version     = "1.4.1"
	spec.license     = "GPL-3.0"
	spec.summary     = "A templating system for ruby."
	spec.authors     = ["Anshul Kharbanda"]
	spec.email       = "akanshul97@gmail.com"
	spec.homepage    = "https://andydevs.github.io/general"

	spec.description = "General is a simple templating system in ruby that allows you to create templates from both" \
					   "pure strings and files (with the extension .general), as well as create new strings and files" \
					   "with these created objects. For more information, visit the homepage"
	
	spec.add_development_dependency "rspec", "~> 3.4"

	spec.files  = ["lib/general.rb",
				   "lib/gpartials.rb",
				   "lib/gtemplate.rb",
				   "lib/gio.rb",
				   "lib/gtimeformat.rb",
				   "lib/goperations.rb",
				   "spec/spec_require.rb",
				   "spec/gtemplate_spec.rb",
				   "spec/gio_spec.rb"]
end
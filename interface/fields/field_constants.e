note
	description: "[
		Constants for use by classes dealing with class {FIELD} (i.e {FIELD} 
		and {SCHEMA} and any descendants.
		]"
	date: "28 Feb 04"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/interface/fields/field_constants.e $"
	date:		"$Date: 2012-03-16 14:05:07 -0400 (Fri, 16 Mar 2012) $"
	revision:	"$Revision: 7 $"


class
	FIELD_CONSTANTS

feature -- Access

	Default_label_field_name: STRING = "label"
	Default_x_field_name: STRING = "x"
	Default_y_field_name: STRING = "y"
	Default_height_field_name: STRING = "height"
	Default_width_field_name: STRING = "width"

	Default_name: STRING = "name: "
	Default_x: INTEGER = 0
	Default_y: INTEGER = 0
	Default_height: INTEGER = 30
	Default_width: INTEGER = 150

end

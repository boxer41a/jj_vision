note
	description: "[
			Used with {EDITOR} classes.
			Object that describes how to create a {CONTROL}.
			]"
	date: "7 Mar 03"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/interface/fields/field.e $"
	date:		"$Date: 2012-03-16 14:05:07 -0400 (Fri, 16 Mar 2012) $"
	revision:	"$Revision: 7 $"


deferred class
	FIELD

inherit

	FIELD_CONSTANTS
		undefine
			default_create,
			is_equal
		end

	EDITABLE
		redefine
			default_create,
			schema,
			is_schema_available,
			schema_imp,
			set_schema,
			remove_schema
		end

feature {NONE} -- Initialization

	default_create
			-- Initialize the object.
		do
			Precursor {EDITABLE}
--			schema_imp := Field_schema
				-- Add the "data".  The data is the lables and positions.
			set_label (Default_label_field_name)
			set_x (Default_x)
			set_y (Default_y)
			set_width (Default_width)
			set_height (Default_height)
		end

feature -- Access

	schema: FIELD_SCHEMA
			-- The schema used to display and edit a FIELD.
		once
			create Result
			Result.extend_mandatory (Label_field)
			Result.extend_mandatory (X_field)
			Result.extend_mandatory (Y_field)
			Result.extend_mandatory (Width_field)
			Result.extend_mandatory (Height_field)
--			Result.set_up
		end

	Type: ANY
			-- Anchor.
		deferred
		end

	label: STRING_32
			-- Identifier of this field.
		do
			check attached {STRING_32} value (Default_label_field_name) as s then
				Result := s
			end
		end

	x: INTEGER_REF
			-- x-position of field in a dialog
		do
			check attached {INTEGER_REF} value (Default_x_field_name) as i then
				Result := i
			end
		end

	y: INTEGER_REF
			-- y-position of field in a dialog
		do
			check attached {INTEGER_REF} value (Default_y_field_name) as i then
				Result := i
			end
		end

	width: INTEGER_REF
			-- Width of this field.  Used to create a control
			-- that is `width' pixels wide.
		do
			check attached {INTEGER_REF} value (Default_width_field_name) as i then
				Result := i
			end
		end

	height: INTEGER_REF
			-- Height of this field.  Used to create a control
			-- that is `height' pixels tall.
		do
			check attached {INTEGER_REF} value (Default_height_field_name) as i then
				Result := i
			end
		end

--	format: STRING is
--			-- Used to set how the data is displayed.
--		do
--			Result ?= value_by_field (format_field)
--		ensure
--			valid_result: Result /= Void
--		end
--
--	posible_formats: LINKED_SET [STRING]
--			-- Set of posible formats which can be used in `format'.
--
--	function: STRING_32
--			-- Function to be assigned to any widget created from
--			-- this field.
--		do
--			Result ?= value_by_field (schema.formula_field)
--		ensure
--			valid_result: Result /= Void
--		end

--	function_result_as_string: STRING_32
--			-- The result of executing the `function' converted to
--			-- a string.
--		local
----			p: FUNCTION_PARSER
--			r: ANY
--			t: like Type
--		do
--			if function = Void then
--				Result := "Value is calculated, but no formula entered."
--			else
----				p.parse_string (function)
----				r := parser.last_value
--				if r.same_type (Type) then
--					t ?= r
--					check
--						should_not_happen: t /= Void
--							-- Because `r.same_type' insures `r' conforms to `t'.
--					end
--					Result := type_to_string (t)
--				else
--						-- there was a parse error.
--					Result ?= r
--					check
--						should_not_happen: Result /= Void
--							-- Because parser should return an error string
--							-- if it failed to get a good result.
--					end
--				end
--			end
--		end

--	function_result_as_type: like type
--			-- The result of executing the `function'.
--		require
--			has_function: function /= Void
--			function_works: is_valid_function (function)
--		local
----			p: FUNCTION_PARSER
--		do
----			p.parse_string (function)
----			Result := p.last_value
--		end

feature -- Element Change

	set_label (a_string: STRING_32)
			-- Change the `name'.
		require
			string_exists: a_string /= Void
		do
			extend_value (a_string, Default_label_field_name)
		ensure
			id_was_set: equal (label, a_string)
		end

	set_x (a_x: INTEGER)
		do
			extend_value (a_x, Default_x_field_name)
		ensure
			x_was_set: x.item = a_x
		end

	set_y (a_y: INTEGER)
		do
			extend_value (a_y, Default_y_field_name)
		ensure
			y_was_set: y.item = a_y
		end

	set_width (a_width: INTEGER)
			-- Change `width'
		require
			valid_width: a_width > 0
		do
			extend_value (a_width, Default_width_field_name)
		ensure
			width_was_set: width.item = a_width
		end

	set_height (a_height: INTEGER)
			-- Change `height'
		require
			valid_height: a_height > 0
		do
			extend_value (a_height, Default_height_field_name)
		ensure
			height_was_set: height.item = a_height
		end

--	set_format (a_format: STRING) is
--			-- Change `format'
--		require
--			schema_exists: schema /= Void
--			valid_format: posible_formats.has (a_format)
--		do
--			extend_with_field (a_format, format_field)
--			extend (a_format, "format")
--		ensure
--			format_was_set: format = a_format
--		end

--	set_function (a_string: STRING) is
--			-- Change the `formula'
--		require
--			schema_exists: schema /= Void
--			string_exists: a_string /= Void
--		do
--			extend_with_field (a_string, schema.formula_field)
--		ensure
--			formula_was_set: equal (formula, a_string)
--		end

feature -- Status report

	is_calculated: BOOLEAN
			-- Should the value (produced by any control) use the result
			-- of executing (parsing) the `formula'?  (Oposite is to use
			-- what ever data is set into the control.)
-- fix		-- Set by `use_formula' or `use_data'.
		do
--			Result := formula.count >= 1
		end

	is_schema_available: BOOLEAN
			-- Does Current have a schema?
			-- Redefined to always be True to follow the redefinition of `schema'.
		do
			Result := True
		end

feature -- Status setting

	use_function
			-- Set `is_calculated' to True
		do
--			is_calculated := True
		end

	use_data
			-- Set `is_calculated' to False
		do
--			is_calculated := False
		end

feature -- Query

--	parser: PARSER is
--			-- Parser for evaluating the `formula'
--		once
--			create Result
--		end

	is_valid_data (a_value: ANY): BOOLEAN
			-- Is `a_value' valid data for this field?
			-- Must redefine `parsed' if redefine this feature.
		do
			Result := a_value /= Void and then a_value.conforms_to (Type)
		end

	is_valid_function (a_function: STRING_32): BOOLEAN
			-- Can `a_function' be parsed, returning a result
			-- of the correct `type'?
		local
--			p: FUNCTION_PARSER
		do
--			p.parse_string (a_function)
--			Result :=  p.last_value.same_type (type)
		end

	string_to_type (a_string: STRING_32): like Type
			-- Convert `a_string' to an object of `Type'
			-- Default is to simply return `a_string' since
			-- it conforms to ANY if it exists.
		require
			valid_string: is_valid_data (a_string)
		do
			Result := a_string
		end

	type_to_string (a_value: ANY): STRING_32
			-- The string representation of `a_value'.
			-- The default is to call feature `out' on `a_value' or to
			-- return the string "Void" or "Non-conforming data".
		do
			if a_value = Void then
				Result := "Void"
			elseif a_value /= Void and then not a_value.conforms_to (Type) then
				Result := "Non-conforming data"
			else
				Result := a_value.out
			end
		ensure
			result_exists: Result /= Void
		end

	controls_from: LINKED_LIST [CONTROL]
			-- All the controls whose positioning is dictated by
			-- this field (i.e. created from this field)
		local
			c_list: LINKED_LIST [CONTROL]
			c: CONTROL
		do
			create Result.make
			c_list := control_list
			from c_list.start
			until c_list.exhausted
			loop
				c := c_list.item
				if c.field = Current then -- or c.field.formula.has_field (Current) then
-- make a formula class and put parser in it.				
					Result.extend (c)
				end
				c_list.forth
			end
		end

	controls_dependent: LINKED_LIST [CONTROL]
			-- All the controls in `controls_from' plus any controls
			-- whose `formula' contains a reference to Current.
		local
			c_list: LINKED_LIST [CONTROL]
			c: CONTROL
		do
			create Result.make
			c_list := control_list
			from c_list.start
			until c_list.exhausted
			loop
				c := c_list.item
				if c.field = Current then -- or c.field.formula.has_field (Current) then
-- make a formula class and put parser in it.				
					Result.extend (c)
				end
				c_list.forth
			end
		end


feature -- Transformation

	as_widget: CONTROL
			-- Each descendent class must create the appropriate control and
			-- put the control into `control_list'.
		deferred
		ensure
			result_has_field: Result.field = Current
			result_added_to_list: control_list.has (Result)
		end

feature {CONTROL} -- Implementation

	control_list: LINKED_LIST [CONTROL]
			-- Keeps track of all the controls so one control can update
			-- others and used to make formulas work.
			-- NOTE:  This can be a once feature here as these are only valid
			-- for the current execution.
			-- The creation procedures for CONTROL should add the created
			-- widget to the list; `destroy' from CONTROL should remove it.
			-- Declared as once function so the list (of EV_WIDGETs) does
			-- not get stored.  That could get messy.
		once
			create Result.make
		end

	schema_imp: FIELD_SCHEMA
			-- Implementation and/or anchor for `schema'. Set by `set_schema' and
			-- removed by `remove_schema.
			-- NOTE:  The FIELDs in a SCHEMA will determine the keys to be
			-- used in `data_table' and will be used to build the controls
			-- for obtaining the values asscociated with the keys.

feature {NONE} -- Implementation (fields used by `field_schema')

	Label_field: STRING_FIELD
			-- Create a field to store the `label' of a FIELD
		once
			create Result
--			Result.extend (Default_name, Default_label_field_name)
			Result.set_label (Default_label_field_name)
			Result.set_x (0)
			Result.set_y (0)
			Result.set_width (Default_width)
			Result.set_height (Default_height)
		end

	X_field: INTEGER_FIELD
			-- Create a field to store the `x' value of a FIELD
		once
			create Result
--			Result.extend (Default_x_field_name, Default_x_field_name)
			Result.set_label (Default_x_field_name)
			Result.set_x (0)
			Result.set_y (50)
			Result.set_width (Default_width)
			Result.set_height (Default_height)
		end

	Y_field: INTEGER_FIELD
			-- Create a field to store the `y' value of a FIELD
		once
			create Result
			Result.set_label (Default_y_field_name)
			Result.set_x (0)
			Result.set_y (100)
			Result.set_width (Default_width)
			Result.set_height (Default_height)
		end

	Width_field: INTEGER_FIELD
			-- Create a field to store the `width' of a FIELD
		once
			create Result
			Result.set_label (Default_width_field_name)
			Result.set_x (0)
			Result.set_y (150)
			Result.set_width (Default_width)
			Result.set_height (Default_height)
		end

	Height_field: INTEGER_FIELD
			-- Create a field to store the `height' of a FIELD
		once
			create Result
			Result.set_label (Default_height_field_name)
			Result.set_x (0)
			Result.set_y (200)
			Result.set_width (Default_width)
			Result.set_height (Default_height)
		end

feature {NONE} -- Inaplicable

	set_schema (a_schema: like schema_imp)
			-- Change `schema' indirectly by changing `schema_imp'.
		do
			check
				should_not_be_called: False
					-- Because `schema' was redefined to a constant
			end
		end

	remove_schema
			-- Make `schema' imp Void
		do
			check
				should_not_be_called: False
					-- Because `schema' was redefined to a constant
			end
		end

end

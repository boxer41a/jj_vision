note
	description: "[
			Used with {EDITOR} classes to make EV_WIDGETs for displaying and
			editting an object.  It is composed of an EV_TEXT_FIELD, `display'
			and an optional EV_LABEL, `label' which can be positioned to the
			top, left, right, or bottom of the `display'.
			
			A {CONTROL} can be created normally with `default_create' or using
			`create_from_field'.  Feature `create_from_field' is used to allow
			creation of controls from a {SCHEMA} (a list of {FIELD}) for placement
			in an {DIALOG_EDITOR_VIEW} (a form maker).  Features from `field' can
			then be used to determine placement, size, etc for the {CONTROL}.
			
			The object to be editted is placed into the control with feature
			`set_data' and is stored in `data' from ANY.  The current `value'
			of the object can be obtained if `is_display_valid'.  Feature
			`is_display_valid' is True when the string displayed in the	`text'
			field of `display' can be converted into an object of the correct
			type.  This convertion is ultimately done by feature `string_to_type'
			from class FIELD through `field'.
			]"
	instructions: "[
			To allow the editting of objects of types other than STRING, redefine
			`default_field', or create an heir of {FIELD}, redefine `type'.

			Feature `draw' takes care of checking the `values' type and putting
			into `display' the appropriate string if the type of the `value'
			does not conform to the control, or if there is no data, etc.  If
			the data is good then `draw_display' is called to show the actual
			data.  Therefore, do not redefine `draw'; redefine `draw_data'.
			]"
	date: "5 Mar 03"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2009, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/interface/controls/control.e $"
	date:		"$Date: 2012-03-16 14:05:07 -0400 (Fri, 16 Mar 2012) $"
	revision:	"$Revision: 7 $"

deferred class
	CONTROL

inherit

	EV_STOCK_COLORS
		rename
			implementation as colors_implementation
		export
			{NONE} all
		undefine
			default_create,
			copy,
			is_equal
		end

		-- Current must be an EV_WIDGET of some sort in order to be placed into
		-- and EV_CONTAINER.  That's the whole point; do not delete EV_FIXED
		-- without adding some other widget.
	EV_FIXED
		redefine
			set_data,
			initialize,
			create_interface_objects,
			destroy,
			is_destroyed,
			is_in_default_state
--			enable_sensitive,
--			disable_sensitive,
--			is_sensitive
		end

feature {NONE} -- Initialization

	create_interface_objects
			-- Create objects to be used by `Current' in `initialize'
			-- Implemented by descendants to create attached objects
			-- in order to adhere to void-safety due to the implementation bridge pattern.
		do
			Precursor {EV_FIXED}
			create valid_change_actions
			create select_actions
			create label
			create display
			field := Default_field
		end

	initialize
			-- Set up the control
		do
			Precursor {EV_FIXED}
			label.set_minimum_width (1)
			label.set_minimum_height (1)
			display.set_minimum_height (20)
			display.set_minimum_width (50)
			extend (label)
			extend (display)
					-- descendents must create the `display'
					-- and set_actions for display.
			label_position := Label_top
			label.set_pebble_function (agent get_field)
--			label.set_drag_and_drop_mode
			set_actions
			field.control_list.extend (Current)
		end

	make_from_field (a_field: like field)
			-- Create a control using the values in `a_field'.
		do
			default_create
			field := a_field
			field.control_list.extend (Current)
		end

	set_actions
			-- Add actions to the controls of Current.
		do
			display.change_actions.extend (agent on_display_changed)
			label.pointer_button_press_actions.extend (agent on_control_selected)
			display.pointer_button_press_actions.extend (agent on_control_selected)
		end

feature -- Access

	value: ANY
			-- A new object created from the `text' in `display'.
			-- Normally only redefine to change the result type by using an
			-- assignment attempt on Precursor.  This is to to preserve
			-- the "definition" post-condition.
		require
			display_is_valid: is_display_valid
		do
			Result := field.string_to_type (display.text)
		ensure
			valid_result: Result /= Void
			definition: equal (Result, field.string_to_type (display.text))
		end

	field: like Default_field
			-- Dictates appearanced of current Control
			-- Redefine `Default_field' to change the type.

	valid_change_actions: EV_NOTIFY_ACTION_SEQUENCE
			-- Actions to be called when this control changes to a valid value.

	select_actions: EV_NOTIFY_ACTION_SEQUENCE
			-- Actions to be called when this control is selected

feature -- Element change

	frozen set_data (a_data: ANY)
			-- Pass in any type of object and display the string representation
			-- of it by calling `refresh'.
			-- The argument can be Void as it will be checked on `refresh' and
			-- the control will so indicate.
		do
			Precursor {EV_FIXED} (a_data)
			refresh
		end

	set_label_top
			-- Make the 'label' appear to the top of the `display'
		do
			label_position := Label_top
		ensure
			label_position_correct: label_position = Label_top
		end

	set_label_bottom
			-- Make the 'label' appear to the bottom of the `display'
		do
			label_position := Label_bottom
		ensure
			label_position_correct: label_position = Label_bottom
		end

	set_label_left
			-- Make the `label' appear to the left of the `display'.
		do
			label_position := Label_left
		ensure
			label_position_correct: label_position = Label_left
		end

	set_label_right
			-- Make the 'label' appear to the right of the `display'
		do
			label_position := Label_right
		ensure
			label_position_correct: label_position = Label_right
		end

	set_label_none
			-- Make the 'label' not appear at all.  Make a labelless control.
		do
			label_position := Label_none
		ensure
			label_position_correct: label_position = Label_none
		end

feature -- Basic operations

	destroy
			-- Remove Current from the `control_list' in `field' when
			-- the underlying graphical object is destroyed.
		do
			Precursor {EV_FIXED}
			field.control_list.prune (Current)
		ensure then
			control_not_in_list: not field.control_list.has (Current)
		end

	build
			-- Position and size the `label' and `display' based on
			-- values in `field'.
		local
			fh: INTEGER
			f: EV_FONT
			s_size: TUPLE [INTEGER, INTEGER]
		do
			label.set_text (field.label)
			set_item_height (label, (label.font.height).max (label.minimum_height))
			set_item_width (label, (label.font.string_width (label.text)).max (label.minimum_width))
--			set_item_height (display, field.height.item.max (display.minimum_height))
			set_item_width (display, field.width.item.max (display.minimum_width))
				-- Set the height of the font in `display'.
			fh := field.height.item
			f := display.font.twin
			f.set_height (fh.max (1))	-- `max' to meet precondition h > 0
			display.set_font (f)
				-- Use any string because all I need is the height a string
				-- would be if it were displayed in that font.  I can't use
				-- display.text because when the control is first built there
				-- may not be any text in it.
			s_size := f.string_size ("This is a STRING.")
			check attached {INTEGER_REF} s_size.item (2) as dh then
					-- because result of `string_size' is a TUPLE [INTEGER, INTEGER]
				set_item_height (display, dh.item.max (display.minimum_height))
			end
				-- Place the label in the correct possition.
			inspect
				label_position
			when Label_left then
				set_item_position (label, 0, 0)
				set_item_position (display, label.x_position + label.width, 0)
				set_minimum_width (label.width + display.width)
				set_minimum_height ((display.height).max (label.height))
			when Label_top then
				set_item_position (label, 0, 0)
				set_item_position (display, 0, label.font.height)
				set_minimum_width ((display.width).max (label.width))
				set_minimum_height (display.height + label.height)
			when Label_right then
				set_item_position (label, field.width.item.max (display.minimum_width), 0)
				set_item_position (display, 0, 0)
				set_minimum_width (label.width + display.width)
				set_minimum_height ((display.height).max (label.height))
			when Label_bottom then
				set_item_position (label, 0, field.height.item.max (display.minimum_height))
				set_item_position (display, 0, 0)
				set_minimum_width ((display.width).max (label.width))
				set_minimum_height (display.height + label.height)
			when Label_none then
				set_item_height (label, label.minimum_height)
				set_item_width (label, label.minimum_width)
				set_item_position (label, 0, 0)
				set_minimum_width (display.width)
				set_minimum_height (display.height)
			else
				check
					should_not_happen: False
				end
			end
		end

	frozen refresh
			-- Displays the string representation of `data'.
			-- Normally do not redefine; redefine `load_display' instead.
		do
			display.change_actions.block
--			change_actions.block
			if field.is_calculated then
--				display.disable_sensitive
			else
				display.enable_sensitive
			end
			if field.is_calculated then
				display.set_text ("{CONTROL}.refresh -- fix me")
--				display.set_text (field.function_result_as_string)
			elseif attached data as d then
				display.set_text (field.type_to_string (d))
			else
				display.set_text ("Void")
			end
			build_colors
--			change_actions.resume
			display.change_actions.resume
		end

feature -- Query

	is_display_valid: BOOLEAN
			-- Is the representation in `display' valid for
			-- object of `Type' based on `field'?
			-- Default is True because assumes `Type' is an ANY.
		do
			Result := not equal (display.text, Void_representation) and then
						field.is_valid_data (display.text)
		end

feature -- Status report

	is_in_default_state: BOOLEAN = True
				-- redefined to make it get past the Eiffel Vision2
				-- post condition of `default create'.

	is_destroyed: BOOLEAN
			-- Is current usable as a widget?
		do
			Result := Precursor {EV_FIXED} and not field.control_list.has (Current)
		end

--	is_sensitive: BOOLEAN is
--			-- Is the object sensitive to user input?
--		do
--			Result := display.is_sensitive
--		end
--
--feature -- Status setting
--
--	enable_sensitive is
--			-- Make the `display' sensitive to user input.
--		do
--			display.enable_sensitive
--		end
--		
--	disable_sensitive is
--			-- Make the `display' unresponsive to user input.
--		do
--			display.disable_sensitive
--		end

feature {NONE} -- Implementation

	load_display (a_value: STRING)
			-- Put `a_value' into `display'.
			-- This feature should be called when redefining.
--		require
--			value_exists: a_value /= Void
		do
			display.set_text (a_value.out)
		end

	build_colors
			-- Change display to red if the `text' in `display'
			-- (not necessarilly the same `data' that is in
			-- Current) is not valid.
		do
			if is_display_valid then
				display.set_foreground_color (Black)
			else
				display.set_foreground_color (Red)
			end
		end

	get_field: like field
			-- Getter function for `field' so can use `set_pebble_function'.
			-- `set_pebble_function' cannot take an attribute such as
			-- `field' as a parameter; it must be a function.
		do
			Result := field
		end

	refresh_dependent_controls
			-- Refresh all other controls which are dependent on
			-- this one.  Called when display changes.
		local
			c_list: LINKED_LIST [CONTROL]
			c: CONTROL
		do
			c_list := field.controls_dependent
			from c_list.start
			until c_list.exhausted
			loop
				c := c_list.item
				if c /= Current then
					c.refresh
				end
				c_list.forth
			end
		end

	on_display_changed
			-- Update because something was done in the control
		do
			build_colors
			refresh_dependent_controls
			if is_display_valid then
				valid_change_actions.call ([Current])
			end
		end

	on_control_selected (a_x, a_y, button: INTEGER;
						a_x_tilt, a_y_tilt, a_pressure: DOUBLE;
						a_screen_x, a_screen_y: INTEGER)
			-- Execute the agents in `select_actions'
			-- The parameters are ignored but are needed to match the
			-- signature of the `pointer_button_press_actions' of `display'.
			-- EV_ACTION_SEQUENCE [TUPLE [x, y, button: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; screen_x, screen_y: INTEGER]]
		do
			select_actions.call ([Current])
		end

feature {FIELD_EDITOR_VIEW} -- Implementation

	label: EV_LABEL
			-- Displays the name (`key') if `is_label_shown'

	display: EV_TEXT_FIELD
			-- Displays the `value'.

	label_position: INTEGER
			-- Where is the label displayed?  (top,
			-- bottom, left, or right of the `display'.

	Label_top, Label_bottom, Label_left, Label_right, Label_none: INTEGER = unique
			-- Position of `label' in relation to display

	default_field: FIELD
			-- Create a field to be used if Current was `default_create'd.
			-- The anchor for `field'.
		deferred
		end

	Void_representation: STRING_32
			-- A string with the value "Void".
		once
			create Result.make_from_string ("Void")
		ensure
			definition: equal (Result, ("Void").as_string_32)
		end

invariant

	field_exists: field /= Void
	label_exists: label /= Void
	display_exists: display /= Void
	select_actions_exists: select_actions /= Void
	valid_change_actions_exists: valid_change_actions /= Void

	in_control_list_if_not_destroyed: not is_destroyed implies field.control_list.has (Current)
	not_in_control_list_if_destroyed: is_destroyed implies not field.control_list.has (Current)

	is_sensitive_definition: is_sensitive implies display.is_sensitive

end

note
	description: "Objects that ..."
	author: ""
	date: "$Date: 2012-03-16 14:05:07 -0400 (Fri, 16 Mar 2012) $"
	revision: "$Revision: 7 $"

class
	YMDHMS_DURATION_CONTROL

inherit

	EV_KEY_CONSTANTS
		export
			{NONE} all
		undefine
			default_create,
			copy,
			is_equal
		end

	YMDHMS_DURATION_CONSTANTS
		export
			{NONE} all
		undefine
			default_create,
			copy,
			is_equal
		end

	CONTROL
		redefine
			initialize,
			value_imp,
			is_value_valid,
			draw
		end

create
	default_create

feature -- Initialization

	initialize
		do
			Precursor {CONTROL}
			create parser.make
			create static
			create up_button
			create down_button
			extend (static)
			extend (up_button)
			extend (down_button)
			position_widgets
			set_actions
		end

	position_widgets
			-- Set the size and location of each widget in `Current'
		do
			static.set_minimum_width (150)
			up_button.set_text ("+")
			down_button.set_text ("-")
			up_button.set_minimum_size (static.height // 2, static.height // 2)
			down_button.set_minimum_size (static.height // 2, static.height // 2)
--			set_item_size (up_button, up_button.width, static.height // 2)
--			set_item_size (down_button, down_button.width, static.height // 2)
			set_item_position (up_button, static.width, 0)
			set_item_position (down_button, static.width, static.height // 2)
		end

	set_actions
			-- Add actions to the widgets
		do
			up_button.select_actions.extend (agent increment_value)
			down_button.select_actions.extend (agent decrement_value)
			static.key_press_actions.extend (agent on_key_press)
		end

--	set_height (a_height: INTEGER) is
--		local
--			but_size: INTEGER
--		do
--			Precursor (a_height)
--			but_size := height // 2
--			static.set_height (height)
--			static.set_width (width - but_size-1)
--			up_button.set_x (static.width+1)
--			down_button.set_y (static.width+1)
--			up_button.set_height (but_size)
--			up_button.set_width (but_size)
--			down_button.set_height (but_size)
--			down_button.set_width (but_size)
--		end
--
--	set_width (a_width: INTEGER) is
--		local
--			but_size: INTEGER
--		do
--			Precursor (a_width)
--			but_size := height // 2
--			static.set_width (width - but_size-1)
--			up_button.set_x (static.width+1)
--			down_button.set_x (static.width+1)
--		end

feature -- Access

feature -- Element Change

feature -- Status report

	is_value_valid: BOOLEAN
		do
-- FIX ME !!!
			Result := True
		end

feature -- Basic operations

	draw
			-- Update the screen representation (ie `static').  This feature
			-- is not called directly from Current; it is called by
			-- JJJ_CONTROL.`set_value'.
		do
			static.set_text (parser.to_string (value_imp))
		end

feature {NONE} -- Implementation

	increment_value
			-- Increase the value by one unit. Unit is based
			-- on position of caret within the edit box.
		do
			change_value (1)
			change_actions.call ([])
		end

	decrement_value
			-- Decrease the value by one unit. Unit is based
			-- on position of caret within the edit box.
		do
			change_value (-1)
			change_actions.call ([])
		end

	change_value (sign: INTEGER)
			-- Change the value by + or - one unit based on `sign'
		require
			valid_sign: sign = 1 or sign = -1
		local
			pos: INTEGER
		do
			pos := static.caret_position
			if parser.is_index_in_year_string (value_imp, pos) then
				value_imp.add (One_year * sign)
			elseif parser.is_index_in_month_string (value_imp, pos) then
				value_imp.add (One_month * sign)
			elseif parser.is_index_in_day_string (value_imp, pos) then
				value_imp.add (One_day * sign)
			elseif parser.is_index_in_hour_string (value_imp, pos) then
				value_imp.add (One_hour * sign)
			elseif parser.is_index_in_minute_string (value_imp, pos) then
				value_imp.add (One_minute * sign)
			elseif parser.is_index_in_second_string (value_imp, pos) then
				value_imp.add (One_second * sign)
			else
			end
			draw
			static.set_caret_position (pos)
		end

	on_key_press (a_key: EV_KEY)
			-- Process a key pressed in static
		do
			if a_key.code = Key_up then
				increment_value
				static.set_caret_position ((static.caret_position - 1).max (0))
						-- to move the caret back after the key press
						-- otherwise it move forward one position.
			elseif a_key.code = Key_down then
				decrement_value
				static.set_caret_position ((static.caret_position + 1).max (0))
						-- to move the caret back after the key press
						-- otherwise it move forward one position.
			else
			end
		end

feature {NONE} -- Implementation

	value_imp: YMDHMS_DURATION
			-- Implementation (and anchor) of `value'.
			-- Redefined to change type.

	static: EV_TEXT_FIELD

	up_button: EV_BUTTON

	down_button: EV_BUTTON

	parser: YMD_TIME_PARSER
--	parser: YMDHMS_DURATION_PARSER
			-- For converting `value' to and from strings

end -- class YMDHMS_DURATION_CONTROL

note
	description: "Objects that ..."
	author: ""
	date: "$Date: 2012-03-16 14:05:07 -0400 (Fri, 16 Mar 2012) $"
	revision: "$Revision: 7 $"

class
	YMDHMS_TIME_CONTROL

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
			create calendar_button
			extend (static)
			extend (up_button)
			extend (down_button)
			extend (calendar_button)
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
			calendar_button.set_minimum_size (static.height, static.height)
--			set_item_size (up_button, up_button.width, static.height // 2)
--			set_item_size (down_button, down_button.width, static.height // 2)
			set_item_position (up_button, static.width, 0)
			set_item_position (down_button, static.width, static.height // 2)
			set_item_position (calendar_button, static.width + up_button.width, 0)
		end

	set_actions
			-- Add actions to the widgets
		do
			up_button.select_actions.extend (agent increment_data)
			down_button.select_actions.extend (agent decrement_data)
			calendar_button.select_actions.extend (agent open_calendar_dialog)
			static.key_press_actions.extend (agent on_key_press)
		end


--	set_minimum_height (a_height: INTEGER) is
--		local
--			but_size: INTEGER
--		do
--			Precursor {JJJ_CONTROL} (a_height)
--			but_size := minimum_height // 2
--			set_item_height (static, minimum_height)
--			set_item_height (up_button, but_size)
--			set_item_height (down_button, but_size)
--			set_item_y_position (up_button, 0)
--			set_item_y_position (down_button, but_size)
--		end

--	set_minimum_width (a_width: INTEGER) is
--		local
--			but_size: INTEGER
--		do
--			Precursor {JJJ_CONTROL} (a_width)
--			but_size := up_button.width
--			set_item_width (static, minimum_width - but_size - 1)
--			set_item_x_position (up_button, minimum_width - but_size)
--			set_item_x_position (down_button, minimum_width - but_size)
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

	increment_data
			-- Increase the data by one unit. Unit is based
			-- on position of caret within the edit box.
		do
			change_data (1)
			change_actions.call ([])
		end

	decrement_data
			-- Decrease the data by one unit. Unit is based
			-- on position of caret within the edit box.
		do
			change_data (-1)
			change_actions.call ([])
		end

	change_data (sign: INTEGER)
			-- Change the data by + or - one unit based on `sign'
			-- Update `value_imp'.
		require
			valid_sign: sign = 1 or sign = -1
		local
			pos: INTEGER
			h: INTEGER
		do
			pos := static.caret_position
			if parser.is_index_in_year_string (value_imp, pos) then
				value_imp.add_duration (One_year * sign)
			elseif parser.is_index_in_month_string (value_imp, pos) then
				value_imp.add_duration (One_month * sign)
			elseif parser.is_index_in_day_string (value_imp, pos) then
				value_imp.add_duration (One_day * sign)
			elseif parser.is_index_in_hour_string (value_imp, pos) then
				value_imp.add_duration (One_hour * sign)
			elseif parser.is_index_in_minute_string (value_imp, pos) then
				value_imp.add_duration (One_minute * sign)
			elseif parser.is_index_in_second_string (value_imp, pos) then
				value_imp.add_duration (One_second * sign)
			elseif parser.is_index_in_am_pm_string (value_imp, pos) then
				h := value_imp.hour
				h := h + 12
				if h >= 24 then
					h := h - 24
				end
				value_imp.set_hour (h)
			else
			end
			draw
			static.set_caret_position (pos)
		end

	on_key_press (a_key: EV_KEY)
			-- Process a key pressed in static
		do
			if a_key.code = Key_up then
				increment_data
				static.set_caret_position ((static.caret_position - 1).max (0))
						-- to move the caret back after the key press
						-- otherwise it move forward one position.
			elseif a_key.code = Key_down then
				decrement_data
				static.set_caret_position ((static.caret_position + 1).max (0))
						-- to move the caret back after the key press
						-- otherwise it move forward one position.
			else
			end
		end

	open_calendar_dialog
			-- Open a caladar for selecting a date.
		do
			calendar_tool.set_date (value)
			calendar_tool.show
			calendar_tool.raise
--			calendar_tool.enable_capture
		end

feature {NONE} -- Implementation

	value_imp: YMDHMS_TIME
			-- Implementation (and anchor) of `value'.
			-- Redefined to change type.

	static: EV_TEXT_FIELD

	up_button: EV_BUTTON

	down_button: EV_BUTTON

	calendar_button: EV_BUTTON
			-- Opens a calendar for selecting a date.

	calendar_tool: EV_COLOR_DIALOG
-- temp fix just to do something; empliment a calendar dialog
			-- Used to select a date
		once
			create Result
			Result.disable_user_resize
		end

	parser: YMD_TIME_PARSER
--	parser: YMDHMS_PARSER
			-- For converting dates to and from strings

end

note
	description: "Objects that ..."
	author: ""
	date: "$Date: 2012-03-16 14:05:07 -0400 (Fri, 16 Mar 2012) $"
	revision: "$Revision: 7 $"

class
	YMDHMS_INTERVAL_CONTROL

inherit

	CONTROL
		redefine
			initialize,
			value_imp,
			is_value_valid,
			draw
		end

create
	default_create

feature {NONE} -- Initialization

	initialize
		local
			lab: EV_LABEL
		do
			Precursor {JJJ_CONTROL}
			create start_date_edit
			create finish_date_edit
			create duration_edit

			extend (start_date_edit)
			extend (finish_date_edit)
			extend (duration_edit)

			create lab.make_with_text ("Start")
			extend (lab)
			set_item_position (lab, 0, 0)
--			set_item_width (lab, 20)
			create lab.make_with_text ("Finish")
			extend (lab)
			set_item_position (lab, 0, 30)
			create lab.make_with_text ("Duration")
			extend (lab)
			set_item_position (lab, 0, 60)
--			set_item_width (lab, 20)
			set_item_position (start_date_edit, lab.width + 5, 0)
			set_item_position (finish_date_edit, lab.width +5, 30)
			set_item_position (duration_edit, lab.width + 5, 60)
--			set_item_width (start_date_edit, 150)
--			set_item_width (finish_date_edit, 150)
--			set_item_width (duration_edit, 150)

--			!! duration_edit.make (Current)
--			!! value.make

--			start_date_edit.set_x (5)
--			start_date_edit.set_y (5)
--			finish_date_edit.set_x (5)
--			finish_date_edit.set_y (start_date_edit.y + start_date_edit.height + 5)
--			duration_edit.set_x (5)
--			duration_edit.set_y (finish_date_edit.y + finish_date_edit.height + 5)

			set_actions
		end

	set_actions
			-- Add actions to the widgets in `Current'
		do
			start_date_edit.change_actions.extend (agent on_start_changed)
			finish_date_edit.change_actions.extend (agent on_finish_changed)
			duration_edit.change_actions.extend (agent on_duration_changed)
		end

feature -- Access

feature -- Element Change

feature -- Status report

	is_value_valid: BOOLEAN
		do
--			if is_valid_date_string (text) then
--				set_date_string (text)
				Result := True
--			end
		end

feature -- Basic operations

	draw
			-- Update the screen representation of Current by simply loading
			-- the various pieces of `value_imp' into the proper controls.
			-- This feature is called from JJJ_CONTROL.`set_value'.
		do
			start_date_edit.set_value (value_imp.start)
			finish_date_edit.set_value (value_imp.finish)
			duration_edit.set_value (value_imp.duration)
		end

feature {NONE} -- Implementation

	on_start_changed
			-- Start has changed so update `Current'
		local
			s, f: YMDHMS_TIME
		do
			s := start_date_edit.value
			f := finish_date_edit.value
			if f < s then
				f := s
			end
			value_imp.set_start_finish (s, f)
			draw
			change_actions.call ([])
		end

	on_finish_changed
			-- Finished has changed so update `Current'
		local
			s, f: YMDHMS_TIME
		do
			s := start_date_edit.value
			f := finish_date_edit.value
			if f < s then
				s := f
			end
			value_imp.set_start_finish (s, f)
			draw
			change_actions.call ([])
		end

	on_duration_changed
			-- `Duration_edit' has changed so update `Current'
		local
			s: YMDHMS_TIME
			d: YMDHMS_DURATION
		do
			s := start_date_edit.value
			d := duration_edit.value
			if d.is_negative then
				value_imp.set_start_finish (s, s)
			else
				value_imp.set_start_duration (s, d)
			end
			draw
			change_actions.call ([])
		end

feature {NONE} -- Implementation

	value_imp: YMDHMS_INTERVAL
			-- Implementation (and anchor) of `value'.
			-- Redefined to change type.

	start_date_edit: YMDHMS_TIME_CONTROL

	finish_date_edit: YMDHMS_TIME_CONTROL

	duration_edit: YMDHMS_DURATION_CONTROL

end

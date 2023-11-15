note
	description: "[
			A {CONTROL} that adds an `increment_button' and a `decrement_button'
			which the user can press to increase or decrease the `value'.
			Feature `increment' and `decrement' must be redefined to change
			`value', but call the Precursors to make the buttons repeat.
		]"
	date: "23 Aug 04"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/interface/controls/spin_control.e $"
	date:		"$Date: 2012-03-16 14:05:07 -0400 (Fri, 16 Mar 2012) $"
	revision:	"$Revision: 7 $"

deferred class
	SPIN_CONTROL

inherit

	COMPARABLE_CONTROL
		redefine
			initialize,
			create_interface_objects,
			set_actions,
			build
--			enable_sensitive,
--			disable_sensitive,
--			is_sensitive
		end

feature {NONE} -- Initialization

	initialize
			-- Set up the control
		do
			extend (increment_button)
			extend (decrement_button)
			show_buttons
			Precursor {COMPARABLE_CONTROL}
		end

	create_interface_objects
			-- Create objects to be used by `Current' in `initialize'
			-- Implemented by descendants to create attached objects
			-- in order to adhere to void-safety due to the implementation bridge pattern.
		do
			Precursor {COMPARABLE_CONTROL}
			create timeout
			create increment_button
			create decrement_button
			timeout.set_interval (500)		-- one-half a second?
			increment_button.set_text ("+")
			decrement_button.set_text ("-")
			increment_button.set_minimum_width (10)
			decrement_button.set_minimum_width (10)
			increment_button.set_minimum_height (1)
			decrement_button.set_minimum_height (1)
		end

	set_actions
			-- Add actions to the buttons.
		do
			Precursor {COMPARABLE_CONTROL}
				-- To make the spin function work `increment' and `decrement' actions are
				-- added, not to the buttons, but to a timer which will be started and killed
				-- when the appropriate button is pressed and released.
				-- `Force_extend' was used to bypass the signature for the agents.
			increment_button.pointer_button_press_actions.force_extend (agent start_timeout (agent increment))
			increment_button.pointer_button_release_actions.force_extend (agent kill_timeout)
			decrement_button.pointer_button_press_actions.force_extend (agent start_timeout (agent decrement))
			decrement_button.pointer_button_release_actions.force_extend (agent kill_timeout)
		end

feature -- Status report

	is_buttons_hidden: BOOLEAN
			-- Are the `increment_button' and the `decrement_button'
			-- hidden from view?

--	is_sensitive: BOOLEAN is
--			-- Can the control react to input?
--		do
--			Result := Precursor {COMPARABLE_CONTROL} and then
--				increment_button.is_sensitive and
--				decrement_button.is_sensitive
--		end


feature -- Status setting

	hide_buttons
			-- Make the `increment_button' and the `decrement_button'
			-- not appear in the control.
		do
			increment_button.hide
			decrement_button.hide
		end

	show_buttons
			-- Make the `increment_button' and the `decrement_button'
			-- appear in the control.
		do
			increment_button.show
			decrement_button.show
		end

--	enable_sensitive is
--			-- Make the `display' sensitive to user input.
--		do
--				-- Redefined to take care of the added buttons
--			Precursor {COMPARABLE_CONTROL}
--			increment_button.enable_sensitive
--			decrement_button.enable_sensitive
--		end
--		
--	disable_sensitive is
--			-- Make the `display' unresponsive to user input.
--		do
--				-- Redefined to take care of the added buttons
--			Precursor {COMPARABLE_CONTROL}
--			increment_button.disable_sensitive
--			decrement_button.disable_sensitive
--		end

feature -- Basic operations

	increment
			-- Intended to be redefined to increase the magnitude of `value'.
			-- Default function only sets the `timeout' to a shorter repeat interval.
		do
			timeout.set_interval (100)
		end

	decrement
			-- Intended to be redefined to decrease the magnitude of `value'.
			-- Default function only sets the `timeout' to a shorter repeat interval.
		do
			timeout.set_interval (100)
		end

feature {NONE} -- Implementation

	build
			-- Position the widgets
		local
			x, y: INTEGER
			h: INTEGER
		do
			Precursor {COMPARABLE_CONTROL}
				-- set the size of the buttons
			h := display.height // 2
			x := display.x_position + display.width
			y := display.y_position + (display.y_position // 2)
			if label_position = Label_right then
				x := x + label.x_position + label.width
			end
			set_item_position (increment_button, x, display.y_position)
			set_item_height (increment_button, h.max (increment_button.minimum_height))
			set_item_width (increment_button, h.max (increment_button.minimum_width))
			set_item_height (decrement_button, h.max (decrement_button.minimum_height))
			set_item_width (decrement_button, h.max (decrement_button.minimum_width))
			y := increment_button.y_position + increment_button.height
			set_item_position (decrement_button, x, y)
			set_minimum_width (minimum_width + increment_button.width)
		end

feature {NONE} -- Implementation

	start_timeout (a_procedure: PROCEDURE)
			-- Calls `a_procedure' once and then sets up `timeout' to
			-- execute `a_procedure' repeatedly.
		require
			procedure_exists: a_procedure /= Void
		do
			a_procedure.call ([])
			timeout.set_interval (1000)
			timeout.actions.extend (a_procedure)
		end

	kill_timeout
			-- Remove actions from the `timeout' so it does not
			-- continue to repeat even when the button is released.
		do
			timeout.actions.wipe_out
			timeout.reset_count
		end

	increment_button: EV_BUTTON
			-- Press to increase the `value'

	decrement_button: EV_BUTTON
			-- Press to decrease the `value'

	timeout: EV_TIMEOUT
			-- Used when a button is held down.

invariant

		-- ensure sure buttons are created
	increment_button_exists: increment_button /= Void
	decrement_button_exists: decrement_button /= Void
	timeout_exists: timeout /= Void

		-- ensure buttons are part of current
	increment_button_in_current: has (increment_button)
	decrement_button_in_current: has (decrement_button)

	is_sensitive_definition: is_sensitive implies increment_button.is_sensitive and
												decrement_button.is_sensitive

end

note
	description: "[
		Objects that represent a scrollable area in which the contents are always aligned with the top left while
		smaller than client area.
		
		When using this control, you must be careful of the following things:
		
			An action sequence is connected to the idle_actions of the application from time to time. As it is removed,
			it is the final agent contained, so if you must add to the idle actions, you should not add at the last position.

			An agent is connected to the `resize_actions' of the widget inserted. If you clear this action sequence, `Current'
			will not update as the widget size changes. Removing the widget via `remove_item' removes the final agent from
			`resize_actions'.	
			
			None of the inherited features for addition and removal of widget does not work correctly. Use `add_item'
			and `remove_item' only.
		]"
	author: "Julian Rogers"
	date: "$Date: 2012-03-16 14:05:07 -0400 (Fri, 16 Mar 2012) $"
	revision: "$Revision: 7 $"

class
	LEFT_ALIGNED_SCROLLABLE_AREA
	
inherit
	EV_VERTICAL_BOX
		redefine
			initialize,
			is_in_default_state
		end
		
feature {NONE} -- Creation

	initialize
			-- Initialize `Current'.
		local
			h_box: EV_HORIZONTAL_BOX
		do
			create cell
			create viewport
			create vertical_scroll_bar
			vertical_scroll_bar.change_actions.extend (agent scroll_vertically)
			create horizontal_scroll_bar
			horizontal_scroll_bar.change_actions.extend (agent scroll_horizontally)
			horizontal_scroll_bar.hide
			vertical_scroll_bar.hide
			create horizontal_box
			extend (horizontal_box)
			create main_fixed
			viewport.extend (main_fixed)
			create h_box
			extend (h_box)
			h_box.extend (horizontal_scroll_bar)
			cell.set_minimum_size (vertical_scroll_bar.minimum_width, horizontal_scroll_bar.minimum_height)
			h_box.extend (cell)
			h_box.disable_item_expand (cell)
			cell.hide
			
			disable_item_expand (h_box)
			horizontal_box.extend (viewport)
			horizontal_box.extend (vertical_scroll_bar)
			horizontal_box.disable_item_expand (vertical_scroll_bar)
						
			resize_actions.extend (agent resized)
			
			is_initialized := True
		end
		

feature -- Access

	add_item (an_item: EV_WIDGET)
			-- Add `an_item' to `Current'.
		require
			an_item_not_void: an_item /= Void
		do
			main_fixed.extend (an_item)
			main_fixed.set_item_position (an_item, 0, 0)
			the_item := an_item
			the_item.resize_actions.extend (agent item_resized)
			resized (0, 0, 0, 0)
		ensure
			item_set: the_item = an_item
		end

feature -- Status report

	the_item: EV_WIDGET
		-- Item currently contained.
	
feature -- Status setting

	remove_item
			-- Remove item from `Current'
		do
			if the_item /= Void then
				main_fixed.wipe_out
				the_item := Void
				the_item.resize_actions.go_i_th (the_item.resize_actions.count)
				the_item.resize_actions.remove
			end
		ensure
			no_item_contained: the_item = Void
		end
		

feature {NONE} -- Implementation

	item_resized (an_x, a_y, a_width, a_height: INTEGER)
			-- `the_item' has been resized, respond by updating `Current'.
		do
			resized (0, 0, width, height)
		end

	resized (an_x, a_y, a_width, a_height: INTEGER)
			-- `Current' has been resized. Determine if the scroll bars must be updated, and if necessary
			-- connect an idle action that executes `update_scroll_bars' if their visible status has changed.
			-- The visible status of the scroll bars must not be updated via `show' or `hide' during execution of
			-- this feature as it is called from within the resize. Resizing a Vision2 interface during a resize
			-- event is dangerous in this situation. Hence we must connect `update_scroll_bars' to perform the update
			-- when the resizing is completed from the idle actions.
		do
			clear_visibility_flags
			if the_item /= Void then
				if viewport.width < the_item.width then
					if not horizontal_scroll_bar.is_show_requested then
						show_horizontal := True
					end
					horizontal_scroll_bar.value_range.adapt (create {INTEGER_INTERVAL}.make (0, the_item.width - viewport.width))
					horizontal_scroll_bar.set_leap (viewport.width.max (1))
				elseif horizontal_scroll_bar.is_show_requested then
					hide_horizontal := True
				end
				if viewport.height < the_item.height then
					if not vertical_scroll_bar.is_show_requested then
						show_vertical := True
					end
					
					vertical_scroll_bar.value_range.adapt (create {INTEGER_INTERVAL}.make (0, the_item.height - viewport.height))
					vertical_scroll_bar.set_leap (viewport.height.max (1))
				elseif vertical_scroll_bar.is_show_requested then
					hide_vertical := True
				end
				
					-- Ensure that as `Current' is enlarged, if the scroll positions are non zero, the
					-- item tends towards the zero position.
				if viewport.y_offset > 0 and the_item.height - viewport.y_offset < viewport.height then
					viewport.set_y_offset ((the_item.height - viewport.height).max (0))
				end
				if viewport.x_offset > 0 and the_item.width - viewport.x_offset < viewport.width then
					viewport.set_x_offset ((the_item.width - viewport.width).max (0))
				end
				if show_horizontal or hide_horizontal or show_vertical or hide_vertical and not idle_actions_connected then
					idle_actions_connected := True
					application.idle_actions.extend (agent update_scroll_bars)
				end
			end
		end
		
	update_scroll_bars
			-- Actually perform hiding and showing of scroll bars deferred from `resized'.
			-- Note that we must recompute the scroll bar values, as the widgets may have been resized since we
			-- originally flagged that there must be a change of visibility.
		do
			if show_vertical then
				vertical_scroll_bar.show
			end
			if hide_vertical then
				vertical_scroll_bar.hide				
			end
			if show_horizontal then
				horizontal_scroll_bar.show
			end
			if hide_horizontal then
				horizontal_scroll_bar.hide
			end
			
			if horizontal_scroll_bar.is_show_requested and vertical_scroll_bar.is_show_requested then
				cell.show
			else
				cell.hide
			end
	
			if show_vertical or show_horizontal or hide_horizontal or hide_vertical then
				if vertical_scroll_bar.is_show_requested then
					vertical_scroll_bar.value_range.adapt (create {INTEGER_INTERVAL}.make (0, the_item.height - viewport.height))
					vertical_scroll_bar.set_leap (viewport.height.max (1))
				end

				if horizontal_scroll_bar.is_show_requested then
					horizontal_scroll_bar.value_range.adapt (create {INTEGER_INTERVAL}.make (0, the_item.width - viewport.width))
					horizontal_scroll_bar.set_leap (viewport.width.max (1))
				end
			end


				-- Ensure that as `Current' is enlarged, if the scroll positions are non zero, the
				-- item tends towards the zero position.
			if viewport.y_offset > 0 and the_item.height - viewport.y_offset < viewport.height then
					viewport.set_y_offset ((the_item.height - viewport.height).max (0))
				end
			if viewport.x_offset > 0 and the_item.width - viewport.x_offset < viewport.width then
				viewport.set_x_offset ((the_item.width - viewport.width).max (0))
			end
			
			
				-- Remove the idle action as leaving it hogs the CPU.
			application.idle_actions.go_i_th (application.idle_actions.count)
			application.idle_actions.remove
			idle_actions_connected := False
		end
		
	show_vertical, hide_vertical, show_horizontal, hide_horizontal, show_cell, hide_cell: BOOLEAN
		-- Flags to determine if the visible state of widgets must be updated.
		
	clear_visibility_flags
			-- Clear visibility flags to False.
		do
			show_vertical := False
			show_horizontal := False
			hide_horizontal := False
			hide_vertical := False
		end
		
		
	scroll_vertically (new_value: INTEGER)
			-- Respond to a scrolling of `vertical_scroll_bar'.
		do
			viewport.set_y_offset (new_value)
		end
		
	scroll_horizontally (new_value: INTEGER)
			-- Respond to a scrolling of `horizontal_scroll_bar'.
		do
			viewport.set_x_offset (new_value)
		end

	is_in_default_state: BOOLEAN = True
		-- Is `Current' in its default state.
	
	idle_actions_connected: BOOLEAN
		-- Is the idle event for showing scroll bars already connected?

	vertical_scroll_bar: EV_VERTICAL_SCROLL_BAR
		-- Vertical scroll bar comprising `Current'.
	
	horizontal_scroll_bar: EV_HORIZONTAL_SCROLL_BAR
		-- Horizontal scroll bar comprising `Current'.
	
	horizontal_box: EV_HORIZONTAL_BOX
		-- Horizontal box comprising `Current'.
	
	viewport: EV_VIEWPORT
		-- Viewport comprising `Current'.
	
	main_fixed: EV_FIXED
		-- The Fixed required in `Current'.
	
	cell: EV_CELL
		-- A cell placed betwen the corners of the scroll bars.
	
	application: EV_APPLICATION
			-- Once access to EV_APPLICATION.
		once
			--((create {EV_ENVIRONMENT}).application).idle_actions.extend (agent update_scroll_bars)
			Result := ((create {EV_ENVIRONMENT}).application)
		end

end -- class LEFT_ALIGNED_SCROLLABLE_AREA

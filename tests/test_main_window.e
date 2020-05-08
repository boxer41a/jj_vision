note
	description: "Objects that ..."
	author: ""
	date: "$Date: 2012-05-31 14:05:35 -0400 (Thu, 31 May 2012) $"
	revision: "$Revision: 10 $"

class
	TEST_MAIN_WINDOW

inherit

	JJ_MAIN_WINDOW
		redefine
			create_interface_objects,
			initialize,
			target_imp,
			set_target
		end

create
	default_create

feature {NONE} -- Initialization

	create_interface_objects
			-- Create objects to be used by `Current' in `initialize'
			-- Implemented by descendants to create attached objects
			-- in order to adhere to void-safety due to the implementation bridge pattern.
		do
			Precursor {JJ_MAIN_WINDOW}
			create first_tool
			create second_tool
			create edit_tool
			create third_tool
			create forth_tool
		end

	initialize
			-- Set up the window
		do
			Precursor {JJ_MAIN_WINDOW}
--			split_manager.enable_mode_changes
			split_manager.set_vertical
			split_manager.extend_siblings (first_tool, edit_tool)
			check attached {VERTICAL_SPLIT_VIEW} split_manager.last_view as sa1 then
				split_manager.extend_siblings (third_tool, forth_tool)
				check attached {VERTICAL_SPLIT_VIEW} split_manager.last_view as sa2 then
					split_manager.set_horizontal
					split_manager.extend_siblings (sa1, sa2)
				end
			end
--			split_manager.add_horizontal (split_manager.last_split, create {INTERFACE_TABLE_TOOL})
			split_manager.enable_mode_changes
			split_manager.select_view (first_tool)
		end

feature -- Access

	first_tool: TEXT_TOOL
			-- To place a tool into the window for testing

	edit_tool: EDIT_TOOL
			-- Tool which manages the views for editting a record.

	second_tool: TEST_TOOL
			-- To place a second tool into the window for testing.

	third_tool: TEST_TOOL

	forth_tool: TEST_TOOL

feature -- Element change

	set_target (a_target: like target)
			-- Change the `target' and pass it to the `tree_tool'.
		do
			Precursor {JJ_MAIN_WINDOW} (a_target)
			first_tool.set_target (a_target)
			edit_tool.set_target (a_target)
--			edit_tool.set_schema (target.Default_schema)
			edit_tool.draw
		end


feature -- Status report

	is_editor_tester_main_window_interface_initialized: BOOLEAN_REF
			-- Have the interface items for this class been added to the `interface_table'?
		once
			create Result
-- is this needed?
		end

feature {NONE} -- Implementation

	target_imp: detachable TEST_RECORD
			-- The object being edited

end

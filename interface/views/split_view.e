note
	description: "[
		A {VIEW} that can be split into multiple panes through calls
		to feature `split_manager'.  (See {SPLIT_MANAGER} or {TOOL}
		for example.)
		]"
	author: "Jimmy J. Johnson"
	date: "5/1/19"

deferred class
	SPLIT_VIEW

inherit

--	VIEW
--		redefine
--			create_interface_objects
--		end

--feature {NONE} -- Initialization

--	create_interface_objects
--			-- Create objects to be used by `Current' in `initialize'
--			-- Implemented by descendants to create attached objects
--			-- in order to adhere to void-safety due to the implementation bridge pattern.
--		do
--			create split_manager
--			Precursor {VIEW}
--		end

feature -- Access

	split_manager: SPLIT_MANAGER
			-- Manages the placement of sub-views within current.
		attribute
			create Result
		end

feature -- Element change

	set_split_manager (a_manager: SPLIT_MANAGER)
			-- Change `split_manager'
		require
			manager_exists: a_manager /= Void
		do
			split_manager := a_manager
		ensure
			manager_assigned: split_manager = a_manager
		end


end

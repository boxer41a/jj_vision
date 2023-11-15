note
	description: "Root class for testing jj_vision cluster."
	author: "Jimmy J. Johnson"
	date: "21 Apr 06"

class
	JJ_VISION_TESTER

inherit

	JJ_APPLICATION
		redefine
			window_anchor
--			target_anchor
		end

create
	make_and_launch

--	target: detachable TEST_RECORD
--			-- For testing

feature {NONE} -- Implementation (anchors)

	target_anchor: TEST_RECORD
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		require else
			not_callable: False
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

	window_anchor: TEST_MAIN_WINDOW
			-- Anchor for the type of `first_window'
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		require else
			not_callable: False
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end


end

note
	description: "An error handler class for the CHESS SOLITAIRE game."
	author: "Umar Abdulselam"
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_ERROR_HANDLER

create

	make_empty

feature {NONE} -- Attributes

	error: STRING
	error_flagged: BOOLEAN

feature -- Initialization

	make_empty
			-- Initialize the error handler to
			-- empty and `error_flagged` to false.
		do
			create error.make_empty
			error_flagged := false
		end

feature -- Commands

	set_error(e: STRING)
			-- Set the STRING `error` to
			-- the STRING `e`.
		do
			error := e
			error_flagged := true
		end

feature -- Queries

	is_set: BOOLEAN
			-- Has an error been flagged?
		do
			Result := error_flagged
		end


	get_error: STRING
			-- Return the current state of `error`.
		do
			Result := error
		end

end

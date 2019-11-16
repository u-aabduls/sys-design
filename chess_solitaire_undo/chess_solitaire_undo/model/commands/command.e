note
	description: "A command interface for events in `GAME` that can be undone/redone."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	COMMAND

feature {GAME} -- Initialization

	make
		local
			game_access: GAME_ACCESS
		do
			game := game_access.game
		end

feature {NONE} -- Attributes

	game: GAME

feature -- Interface Features

	execute
			-- Execute the effect of this command.
		deferred
		end

	undo
			-- Undo the effect of this command.
		deferred
		end

	redo
			-- Re-execute this command.
		deferred
		end

end

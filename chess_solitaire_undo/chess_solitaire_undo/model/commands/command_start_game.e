note
	description: "Summary description for {COMMAND_START_GAME}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	COMMAND_START_GAME

inherit
	COMMAND

create
	init

feature {GAME} -- Initialization

	init
		do
			make
		end

feature -- Interface Features

	execute
			-- See COMMAND interface for description.
		do
			game.set_game_started(true)
			game.set_game_report("Game In Progress...")
		end


	undo
			-- See COMMAND interface for description.
		do
				-- set `game_started` back to `false`
			game.set_game_started(false)
				-- set `report` back to `game`s setup state
			game.set_game_report("Game being Setup...")
		end


	redo
			-- See COMMAND interface for description.
		do
			execute
		end

end

note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_START_GAME
inherit
	ETF_START_GAME_INTERFACE
create
	make
feature -- command
	start_game
    	do
			-- perform some update on the GAME state

			if game.game_started then
				game.error_handler.set_error_game_started
			else
				game.start_game
			end

			etf_cmd_container.on_change.notify ([Current])
    	end

end

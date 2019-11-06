note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_RESTART
inherit
	ETF_RESTART_INTERFACE
create
	make
feature -- command
	restart
    	do
			-- perform some update on the GAME state

			if game.game_started_state = false then
				game.get_error_handler.set_error_game_not_started

			elseif game.game_over_state = true then
				game.get_error_handler.set_error_game_already_over

			elseif game.get_move_count = game.get_move_count_for_setup then
				game.get_error_handler.set_error_no_moves_made

			else
				game.restart
			end

			etf_cmd_container.on_change.notify ([Current])
    	end

end

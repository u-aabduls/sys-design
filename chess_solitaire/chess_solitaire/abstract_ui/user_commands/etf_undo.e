note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_UNDO
inherit
	ETF_UNDO_INTERFACE
create
	make
feature -- command
	undo
    	do
			-- perform some update on the GAME state

			if game.game_over_state = true then
				game.get_error_handler.set_error_game_already_over

			elseif game.get_move_count = 0 then
				game.get_error_handler.set_error_no_undo_available

			elseif game.get_move_count <= game.get_move_count_for_setup then
				game.get_error_handler.set_error_cant_undo_past_start

			else
				game.undo
			end

			etf_cmd_container.on_change.notify ([Current])
    	end

end

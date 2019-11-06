note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MOVE_AND_CAPTURE
inherit
	ETF_MOVE_AND_CAPTURE_INTERFACE
create
	make
feature -- command
	move_and_capture(r1: INTEGER_32 ; c1: INTEGER_32 ; r2: INTEGER_32 ; c2: INTEGER_32)
    	do
				-- perform some update on the GAME state

			if game.game_started_state = false then
				game.get_error_handler.set_error_game_not_started

			elseif game.game_over_state = true then
				game.get_error_handler.set_error_game_already_over

			elseif not game.get_helper.is_valid_slot(r1, c1) then
				game.get_error_handler.set_error_invalid_slot(r1, c1)

			elseif not game.get_helper.is_valid_slot(r2, c2) then
				game.get_error_handler.set_error_invalid_slot(r2, c2)

			elseif not game.get_helper.is_slot_occupied(r1, c1) then
				game.get_error_handler.set_error_slot_not_occupied(r1, c1)

			elseif not game.get_helper.is_slot_occupied(r2, c2) then
				game.get_error_handler.set_error_slot_not_occupied(r2, c2)

			elseif game.get_helper.is_possible_move(r1, c1, r2, c2) = false then
				game.get_error_handler.set_error_move_not_possible(r1, c1, r2, c2)

			elseif game.get_helper.is_blocked(r1, c1, r2, c2) then
				game.get_error_handler.set_error_block_exists(r1, c1, r2, c2)

			else
				game.move_and_capture(r1, c1, r2, c2)

			end

			etf_cmd_container.on_change.notify ([Current])
    	end

end

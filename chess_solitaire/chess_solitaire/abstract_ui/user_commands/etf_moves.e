note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MOVES
inherit
	ETF_MOVES_INTERFACE
create
	make
feature -- command
	moves(row: INTEGER_32 ; col: INTEGER_32)
		local
			dormant: ARRAY2[STRING]
    	do
				-- perform some update on the model state

			if not model.game_started then
				model.error_handler.set_error_game_not_started

			elseif model.game_over then
				model.error_handler.set_error_game_already_over

			elseif not model.is_valid_slot(row, col) then
				model.error_handler.set_error_invalid_slot(row, col)

			elseif not model.is_slot_occupied(row, col) then
				model.error_handler.set_error_slot_not_occupied(row, col)
			else
				dormant := model.moves(row, col, true)

			end

			etf_cmd_container.on_change.notify ([Current])
    	end

end

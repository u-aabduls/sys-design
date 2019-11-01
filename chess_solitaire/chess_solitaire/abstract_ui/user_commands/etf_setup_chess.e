note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_SETUP_CHESS
inherit
	ETF_SETUP_CHESS_INTERFACE
create
	make
feature -- command
	setup_chess(c: INTEGER_32 ; row: INTEGER_32 ; col: INTEGER_32)
		require else
			setup_chess_precond(c, row, col)
    	do
				-- perform some update on the model state

			if model.game_started then
				model.error_handler.set_error_game_started

			elseif not model.is_valid_slot(row, col) then
				model.error_handler.set_error_invalid_slot(row, col)

			elseif model.is_slot_occupied(row, col) then
				model.error_handler.set_error_slot_occupied(row, col)

			else
				model.setup_chess(c, row, col)
			end

			etf_cmd_container.on_change.notify ([Current])
    	end

end

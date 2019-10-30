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
				model.error_handler.set_error(
					"Error: Game not yet started")

			elseif model.game_over then
				model.error_handler.set_error(
					"Error: Game already over")

			elseif not model.is_valid_slot(row, col) then
				model.error_handler.set_error (
					"Error: (" + row.out + ", " + col.out + ") not a valid slot")

			elseif not model.is_slot_occupied(row, col) then
				model.error_handler.set_error (
					"Error: Slot @ (" + row.out + ", " + col.out + ") not occupied")

			else
				dormant := model.moves(row, col, true)

			end

			etf_cmd_container.on_change.notify ([Current])
    	end

end

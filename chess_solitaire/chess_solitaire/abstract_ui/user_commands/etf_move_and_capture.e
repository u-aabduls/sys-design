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
			-- perform some update on the model state
			if not model.game_started then
				model.error_handler.set_error(
					"Error: Game not yet started")

			elseif model.game_over then
				model.error_handler.set_error(
					"Error: Game already over")

			elseif not model.is_valid_slot(r1, c1) then
				model.error_handler.set_error(
					"Error: (" + r1.out + ", " + c1.out + ") not a valid slot")

			elseif not model.is_valid_slot(r2, c2) then
				model.error_handler.set_error(
					"Error: (" + r2.out + ", " + c2.out + ") not a valid slot")

			elseif not model.is_slot_occupied(r1, c1) then
				model.error_handler.set_error(
					"Error: Slot @ (" + r1.out + ", " + c1.out + ") not occupied")

			elseif not model.is_slot_occupied(r2, c2) then
				model.error_handler.set_error(
					"Error: Slot @ (" + r2.out + ", " + c2.out + ") not occupied")

			elseif not model.is_possible_move (r1, c1, r2, c2) then
				model.error_handler.set_error(
					"Error: Invalid move from (" + r1.out + ", " + c1.out + ") to (" + r2.out + ", " + c2.out + ")")

			elseif model.is_blocked(r1, c1, r2, c2) then
				model.error_handler.set_error(
					"Error: Block exists between (" + r1.out + ", " + c1.out + ") and (" + r2.out + ", " + c2.out + ")")

			else
				model.move_and_capture(r1, c1, r2, c2)

			end

			etf_cmd_container.on_change.notify ([Current])
    	end

end

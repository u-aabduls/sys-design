note
	description: "An error handler class for the CHESS SOLITAIRE game."
	author: "Umar Abdulselam"
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_ERROR_HANDLER

create

	init


feature {NONE} -- Attributes

	error: STRING
	error_flagged: BOOLEAN
	game: GAME


feature {GAME} -- Initialization

	init
			-- Initialize the error handler to
			-- its default state.
		local
			game_access: GAME_ACCESS
		do
			create error.make_empty
			error_flagged := false
			game := game_access.game
		end


feature -- Commands

	set_error(e: STRING)
			-- Set `error` to `e`.
		do
			error := e
			error_flagged := true
		end


	set_error_game_started
			-- Set `game_already_started` error.
		do
			error := "Error: Game already started"
			error_flagged := true
		end


	set_error_game_not_started
			-- Set `game_not_started` error.
		do
			error := "Error: Game not yet started"
			error_flagged := true
		end


	set_error_game_already_over
			-- Set `game_already_over` error.
		do
			error := "Error: Game already over"
			error_flagged := true
		end


	set_error_invalid_slot(row: INTEGER; col: INTEGER)
			-- Set `invalid_slot` error.
		do
			error := "Error: (" + row.out + ", "
					 + col.out + ") not a valid slot"
			error_flagged := true
		end


	set_error_slot_occupied(row: INTEGER; col: INTEGER)
			-- Set `slot_occupied` error.
		do
			error := "Error: Slot @ (" + row.out
					 + ", " + col.out + ") already occupied"
			error_flagged := true
		end


	set_error_slot_not_occupied(row: INTEGER; col: INTEGER)
			-- Set `slot_not_occupied` error.
		do
			error := "Error: Slot @ (" + row.out + ", "
					 + col.out + ") not occupied"
			error_flagged := true
		end


	set_error_move_not_possible(from_r: INTEGER; from_c: INTEGER; to_r: INTEGER; to_c: INTEGER)
			-- Set `move_not_possible` error.
		local
			game_access: GAME_ACCESS
		do
			game := game_access.game
			error := "Error: Invalid move of " + game.get_game_board[from_r, from_c].get_type
					 + " from (" + from_r.out + ", " + from_c.out + ") to ("
					 + to_r.out + ", " + to_c.out + ")"
			error_flagged := true
		end


	set_error_block_exists(from_r: INTEGER; from_c: INTEGER; to_r: INTEGER; to_c: INTEGER)
			-- Set `block_exists` error.
		do
			error := "Error: Block exists between (" + from_r.out + ", "
					 + from_c.out + ") and (" + to_r.out + ", " + to_c.out + ")"
			error_flagged := true
		end

	set_error_no_undo_available
			-- Set `no_undo_available` error.
		do
			error := "Error: No game state to revert to."
			error_flagged := true
		end

	set_error_no_moves_made
			-- Set `no_moves_made` error.
		do
			error := "Error: No moves made yet."
			error_flagged := true
		end

	set_error_cant_undo_past_start
			-- Set `no_undo_past_restart_available` error.
		do
			error := "Error: Can't undo past the start of the game."
			error_flagged := true
		end

feature -- Queries

	is_set: BOOLEAN
			-- Has an error been flagged?
		do
			Result := error_flagged
		end


	get_error: STRING
			-- Return the current state of `error`.
		do
			Result := error
		end

end

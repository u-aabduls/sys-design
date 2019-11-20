note
	description: "Summary description for {COMMAND_MOVE_AND_CAPTURE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	COMMAND_MOVE_AND_CAPTURE

inherit
	COMMAND

create
	init

feature {GAME} -- Initialization

	init(data_1: INTEGER; data_2: INTEGER; data_3: INTEGER; data_4: INTEGER)
		local
			piece: PIECE
		do
				-- initialize singleton access to GAME
			make
				-- store the information about this command
			from_r := data_1
			from_c := data_2
			to_r := data_3
			to_c := data_4
				-- set default piece as placeholder
			create piece.make
			moving_piece := piece
			captured_piece := piece

		end

feature {NONE} -- Attributes

	from_r, from_c, to_r, to_c: INTEGER
	moving_piece, captured_piece: PIECE

feature -- Interface Features

	execute
			-- Invoke `move_and_capture` and store the
			-- pre-state information.
		local
			chess_piece: PIECE
		do
				-- Save information about the affected `PIECE`s
			moving_piece := game.get_game_board[from_r, from_c]
			captured_piece := game.get_game_board[to_r, to_c]
				-- Create a default `PIECE`
			create chess_piece.make
			game.get_game_board[to_r, to_c] := game.get_game_board[from_r, from_c]
				-- Set `game_board[from_r, from_c]` to "."
				-- (i.e. the default `PIECE`
			game.get_game_board[from_r, from_c] := chess_piece
			game.set_piece_count(game.get_piece_count - 1)
			game.set_game_report ("Game In Progress...")

		end


	undo
			-- See COMMAND interface for description.
		do
				-- put `moving_piece` back at the position
				-- it came from
			game.get_game_board[from_r, from_c] := moving_piece
				-- put `captured_piece` back in its position
			game.get_game_board[to_r, to_c] := captured_piece
				-- increment `pieces_count`
			game.set_piece_count(game.get_piece_count + 1)
				-- restore `game_over` state in case the game
				-- ended due to this command
			game.set_game_over(false)
				-- restore `report`, in case it was changed
				-- to a different state (i.e. Game Over:...)
			game.set_game_report("Game In Progress...")
		end


	redo
			-- See COMMAND interface for description.
		do
			execute
		end

end

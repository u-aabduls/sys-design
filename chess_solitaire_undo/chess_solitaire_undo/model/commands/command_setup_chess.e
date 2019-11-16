note
	description: "Summary description for {COMMAND_SETUP_CHESS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	COMMAND_SETUP_CHESS

inherit
	COMMAND

create
	init

feature {GAME} -- Initialization

	init (data_1: INTEGER; data_2: INTEGER; data_3: INTEGER)
		local
			piece: PIECE
		do
				-- initialize singleton access to GAME
			make
				-- store the information about this command
			chess := data_1
			row := data_2
			col := data_3
			create piece.make
				-- set default piece as placeholder
			context_piece := piece

		end


feature {NONE} -- Attributes

	chess: INTEGER
	row, col: INTEGER
	context_piece: PIECE


feature -- Interface Features

	execute
			-- Place a chess piece `chess` at the position
			-- `game_board[row, col]` and store information
			-- about the pre-state.
		local
			type: STRING
			chess_piece: PIECE
			mapped_pieces: HASH_TABLE[STRING, INTEGER]

		do
			game.set_game_report("Game being Setup...")

				-- Map integers to chess PIECES
			mapped_pieces := game.get_helper.integer_to_chess
				-- Get the PIECE type from `chess`
			type := mapped_pieces.at(chess)

			if     type ~ "K" then
				create {KING} chess_piece.make
			elseif type ~ "Q" then
				create {QUEEN} chess_piece.make
			elseif type ~ "N" then
				create {KNIGHT} chess_piece.make
			elseif type ~ "B" then
				create {BISHOP} chess_piece.make
			elseif type ~ "R" then
				create {ROOK} chess_piece.make
			elseif type ~ "P" then
				create {PAWN} chess_piece.make
			end

			check attached chess_piece AS piece then
				game.get_game_board[row, col] := piece
					-- save information about the `PIECE`
				context_piece := piece
			end
				-- Increment the total number of pieces
			game.set_piece_count(game.get_piece_count + 1)

		end


	undo
			-- Undo the effect of `Current`s invocation of
			-- `execute`.	
		local
			piece: PIECE
		do
			create piece.make
				-- Reset the affected position to empty
				-- NOTE: `PIECE` by default is of type "." (empty)
			game.get_game_board[row, col] := piece
				-- Decrement the total number of pieces
			game.set_piece_count(game.get_piece_count - 1)
		end


	redo
			-- See COMMAND interface for description.
		do
			execute
		end

end

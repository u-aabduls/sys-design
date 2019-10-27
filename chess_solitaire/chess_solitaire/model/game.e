note
	description: "A default business model."
	author: "Umar Abdulselam"
	date: "$Date$"
	revision: "$Revision$"

class
	GAME

inherit
	ANY
		redefine
			out
		end

create {GAME_ACCESS}
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			create chess_pieces.make_filled(" ", 1, 6)
			chess_pieces := << "K", "Q", "N", "B", "R", "P" >>
			create game_board.make_filled (".", 4, 4)
			create moves_board.make_filled (".", 4, 4)
			game_started := false
			game_over := false
			is_move_report := false
			pieces_count := 0
			report := "Game being Setup..."
		end

feature -- GAME attributes

	chess_pieces: ARRAY[STRING]
	game_board, moves_board: ARRAY2[STRING]
	pieces_count: INTEGER
	game_started, game_over, is_move_report: BOOLEAN
	report: STRING

feature -- GAME operations

	start_game
	
		require
			game_not_started:
				not game_started
		do
			report := "Game In Progress..."
			game_started := true
		end


	reset_game

		require
			is_game_started:
				game_started
		do
			make
		end


	setup_chess(chess: INTEGER; row: INTEGER; col: INTEGER)

		require
			game_not_started:
				not game_started

			valid_slot:
					row > 0
				and row < 5
				and col > 0
				and col < 5

			slot_not_occupied:
				game_board[row, col] ~ "."
		do
			report := "Game being Setup..."
			pieces_count := pieces_count + 1
			game_board[row, col] := chess_pieces[chess]
		end


	moves(row: INTEGER; col: INTEGER; set: BOOLEAN): ARRAY2[STRING]

		require
			is_game_started:
				game_started

			game_not_over:
				not game_over

			valid_slot:
					row > 0
				and row < 5
				and col > 0
				and col < 5

			slot_occupied:
				game_board[row, col] /~ "."

		local
			chess: STRING

		do
			report := "Game In Progress..."
			if not set then
				is_move_report := true
			end
			chess := game_board[row, col]

			across 1 |..| 4 is i loop
		 	  across 1 |..| 4  is j loop
		 		if chess ~ "K" then
		 		  if (i-row).abs <= 1 and
		 		  	 (j-col).abs <= 1
		 		  then
		 			 moves_board[i, j] := "+"
		 		  end

		 		elseif chess ~ "Q" then
				  if (row-i).abs = (col-j).abs
		 			 or -1*(row-i) = (col-j)
		 		   	 or (row-i) = -1*(col-j)
		 			 or i = row
		 			 or j = col
		 		  then
		 			 moves_board[i, j] := "+"
		 		  end

		 		elseif chess ~ "N" then
		 		  if (i-row).abs = 1 and (j-col).abs = 2 or
		 			 (i-row).abs = 2 and (j-col).abs = 1
		 	      then
			 	    moves_board[i, j] := "+"
		 		  end

		 		elseif chess ~ "B" then
		 	   	  if (row-i).abs = (col-j).abs
		 			or -(row-i) = (col-j)
		 			or (row-i) = -(col-j)
		 		  then
		 			moves_board[i, j] := "+"
		 		  end

		 		elseif chess ~ "R" then
				  if i = row or j = col then
					moves_board[i, j] := "+"
				  end

		 		elseif chess ~ "P" then
	 			  if (i = row-1)  and
	 			  	 ((j = col-1) or (j = col+1))
	 			  then
	 			  	moves_board[i, j] := "+"
	 			  end
		 		end
			  end
			end
			moves_board[row, col] := chess
			Result := moves_board.deep_twin
		end


	move_and_capture(r1: INTEGER; c1: INTEGER; r2: INTEGER; c2: INTEGER)

		require
			is_game_started:
				game_started

			game_not_over:
				not game_over

			is_valid_slot_1:
					r1 > 0
				and r1 < 5
			    and c1 > 0
			    and c1 < 5

			is_valid_slot_2:
					r2 > 0
				and r2 < 5
				and c2 > 0
				and c2 < 5

			slot_1_occupied:
				game_board[r1, c1] /~ "."

			slot_2_occupied:
				game_board[r2, c2] /~ "."

			is_valid_move:
				moves(r1, c1, true)[r2, c2] ~ "+"

			is_not_blocked:
				true

		do
			game_board[r2, c2] := game_board[r1, c1]
			game_board[r1, c1] := "."
			pieces_count := pieces_count - 1
		end


	board_to_string(board: ARRAY2[STRING]): STRING

		do
			create Result.make_empty
			across 1 |..| 4 is i loop
				Result.append ("  ")
				across 1 |..| 4 is j loop
					Result.append (board[i,j])
				end
				if i < 4 then
					Result.append("%N")
				end
			end
			if board = moves_board then
				moves_board.make_filled (".", 4, 4)
				is_move_report := false
			end
		end


	reset
			-- Reset model state.
		do
			make
		end

feature -- queries

	out : STRING
		do
			Result := "  # of chess pieces on game_board: "
			Result.append(pieces_count.out)
			Result.append("%N")
			if game_started and pieces_count <= 1 then
				report := "Game Over: You Win!"
				game_over := true
				game_started := false
			end
			Result := Result + "  " + report + "%N"
			if is_move_report then
				Result.append(board_to_string(moves_board))
			else
				Result.append(board_to_string(game_board))
			end
		end

end





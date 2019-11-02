class
 	 ETF_TYPE_CONSTRAINTS

feature -- type queries 

	is_chess(etf_v: INTEGER_32): BOOLEAN 
		require
			comment("etf_v: CHESS = {K, Q, N, B, R, P}")
		do
			 Result := 
				(( etf_v ~ K ) or else ( etf_v ~ Q ) or else ( etf_v ~ N ) or else ( etf_v ~ B ) or else ( etf_v ~ R ) or else ( etf_v ~ P ))
		ensure
			 Result = 
				(( etf_v ~ K ) or else ( etf_v ~ Q ) or else ( etf_v ~ N ) or else ( etf_v ~ B ) or else ( etf_v ~ R ) or else ( etf_v ~ P ))
		end

feature -- constants for enumerated items 
	K: INTEGER =1
	Q: INTEGER =2
	N: INTEGER =3
	B: INTEGER =4
	R: INTEGER =5
	P: INTEGER =6

feature -- list of enumeratd constants
	enum_items : HASH_TABLE[INTEGER, STRING]
		do
			create Result.make (10)
			Result.extend(1, "K")
			Result.extend(2, "Q")
			Result.extend(3, "N")
			Result.extend(4, "B")
			Result.extend(5, "R")
			Result.extend(6, "P")
		end

	enum_items_inverse : HASH_TABLE[STRING, INTEGER_32]
		do
			create Result.make (10)
			Result.extend("K", 1)
			Result.extend("Q", 2)
			Result.extend("N", 3)
			Result.extend("B", 4)
			Result.extend("R", 5)
			Result.extend("P", 6)
		end
feature -- query on declarations of event parameters
	evt_param_types_table : HASH_TABLE[HASH_TABLE[ETF_PARAM_TYPE, STRING], STRING]
		local
			setup_chess_param_types: HASH_TABLE[ETF_PARAM_TYPE, STRING]
			start_game_param_types: HASH_TABLE[ETF_PARAM_TYPE, STRING]
			reset_game_param_types: HASH_TABLE[ETF_PARAM_TYPE, STRING]
			move_and_capture_param_types: HASH_TABLE[ETF_PARAM_TYPE, STRING]
			moves_param_types: HASH_TABLE[ETF_PARAM_TYPE, STRING]
		do
			create Result.make (10)
			Result.compare_objects
			create setup_chess_param_types.make (10)
			setup_chess_param_types.compare_objects
			setup_chess_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("CHESS", create {ETF_ENUM_PARAM}.make(<<"K", "Q", "N", "B", "R", "P">>)), "c")
			setup_chess_param_types.extend (create {ETF_INT_PARAM}, "row")
			setup_chess_param_types.extend (create {ETF_INT_PARAM}, "col")
			Result.extend (setup_chess_param_types, "setup_chess")
			create start_game_param_types.make (10)
			start_game_param_types.compare_objects
			Result.extend (start_game_param_types, "start_game")
			create reset_game_param_types.make (10)
			reset_game_param_types.compare_objects
			Result.extend (reset_game_param_types, "reset_game")
			create move_and_capture_param_types.make (10)
			move_and_capture_param_types.compare_objects
			move_and_capture_param_types.extend (create {ETF_INT_PARAM}, "r1")
			move_and_capture_param_types.extend (create {ETF_INT_PARAM}, "c1")
			move_and_capture_param_types.extend (create {ETF_INT_PARAM}, "r2")
			move_and_capture_param_types.extend (create {ETF_INT_PARAM}, "c2")
			Result.extend (move_and_capture_param_types, "move_and_capture")
			create moves_param_types.make (10)
			moves_param_types.compare_objects
			moves_param_types.extend (create {ETF_INT_PARAM}, "row")
			moves_param_types.extend (create {ETF_INT_PARAM}, "col")
			Result.extend (moves_param_types, "moves")
		end
feature -- query on declarations of event parameters
	evt_param_types_list : HASH_TABLE[LINKED_LIST[ETF_PARAM_TYPE], STRING]
		local
			setup_chess_param_types: LINKED_LIST[ETF_PARAM_TYPE]
			start_game_param_types: LINKED_LIST[ETF_PARAM_TYPE]
			reset_game_param_types: LINKED_LIST[ETF_PARAM_TYPE]
			move_and_capture_param_types: LINKED_LIST[ETF_PARAM_TYPE]
			moves_param_types: LINKED_LIST[ETF_PARAM_TYPE]
		do
			create Result.make (10)
			Result.compare_objects
			create setup_chess_param_types.make
			setup_chess_param_types.compare_objects
			setup_chess_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("CHESS", create {ETF_ENUM_PARAM}.make(<<"K", "Q", "N", "B", "R", "P">>)))
			setup_chess_param_types.extend (create {ETF_INT_PARAM})
			setup_chess_param_types.extend (create {ETF_INT_PARAM})
			Result.extend (setup_chess_param_types, "setup_chess")
			create start_game_param_types.make
			start_game_param_types.compare_objects
			Result.extend (start_game_param_types, "start_game")
			create reset_game_param_types.make
			reset_game_param_types.compare_objects
			Result.extend (reset_game_param_types, "reset_game")
			create move_and_capture_param_types.make
			move_and_capture_param_types.compare_objects
			move_and_capture_param_types.extend (create {ETF_INT_PARAM})
			move_and_capture_param_types.extend (create {ETF_INT_PARAM})
			move_and_capture_param_types.extend (create {ETF_INT_PARAM})
			move_and_capture_param_types.extend (create {ETF_INT_PARAM})
			Result.extend (move_and_capture_param_types, "move_and_capture")
			create moves_param_types.make
			moves_param_types.compare_objects
			moves_param_types.extend (create {ETF_INT_PARAM})
			moves_param_types.extend (create {ETF_INT_PARAM})
			Result.extend (moves_param_types, "moves")
		end
feature -- comments for contracts
	comment(etf_s: STRING): BOOLEAN
		do
			Result := TRUE
		end
end

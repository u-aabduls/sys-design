note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ETF_SETUP_CHESS_INTERFACE
inherit
	ETF_COMMAND
		redefine 
			make 
		end

feature {NONE} -- Initialization

	make(an_etf_cmd_name: STRING; etf_cmd_args: TUPLE; an_etf_cmd_container: ETF_ABSTRACT_UI_INTERFACE)
		do
			Precursor(an_etf_cmd_name,etf_cmd_args,an_etf_cmd_container)
			etf_cmd_routine := agent setup_chess(? , ? , ?)
			etf_cmd_routine.set_operands (etf_cmd_args)
			if
				attached {INTEGER_32} etf_cmd_args[1] as c and then attached {INTEGER_32} etf_cmd_args[2] as row and then attached {INTEGER_32} etf_cmd_args[3] as col
			then
				out := "setup_chess(" + etf_event_argument_out("setup_chess", "c", c) + "," + etf_event_argument_out("setup_chess", "row", row) + "," + etf_event_argument_out("setup_chess", "col", col) + ")"
			else
				etf_cmd_error := True
			end
		end

feature -- command precondition 
	setup_chess_precond(c: INTEGER_32 ; row: INTEGER_32 ; col: INTEGER_32): BOOLEAN
		do  
			Result := 
				         is_chess(c)
					-- (( c ~ K ) or else ( c ~ Q ) or else ( c ~ N ) or else ( c ~ B ) or else ( c ~ R ) or else ( c ~ P ))
		ensure then  
			Result = 
				         is_chess(c)
					-- (( c ~ K ) or else ( c ~ Q ) or else ( c ~ N ) or else ( c ~ B ) or else ( c ~ R ) or else ( c ~ P ))
		end 
feature -- command 
	setup_chess(c: INTEGER_32 ; row: INTEGER_32 ; col: INTEGER_32)
		require 
			setup_chess_precond(c, row, col)
    	deferred
    	end
end

note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ETF_MOVES_INTERFACE
inherit
	ETF_COMMAND
		redefine 
			make 
		end

feature {NONE} -- Initialization

	make(an_etf_cmd_name: STRING; etf_cmd_args: TUPLE; an_etf_cmd_container: ETF_ABSTRACT_UI_INTERFACE)
		do
			Precursor(an_etf_cmd_name,etf_cmd_args,an_etf_cmd_container)
			etf_cmd_routine := agent moves(? , ?)
			etf_cmd_routine.set_operands (etf_cmd_args)
			if
				attached {INTEGER_32} etf_cmd_args[1] as row and then attached {INTEGER_32} etf_cmd_args[2] as col
			then
				out := "moves(" + etf_event_argument_out("moves", "row", row) + "," + etf_event_argument_out("moves", "col", col) + ")"
			else
				etf_cmd_error := True
			end
		end

feature -- command 
	moves(row: INTEGER_32 ; col: INTEGER_32)
    	deferred
    	end
end

note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ETF_MOVE_AND_CAPTURE_INTERFACE
inherit
	ETF_COMMAND
		redefine 
			make 
		end

feature {NONE} -- Initialization

	make(an_etf_cmd_name: STRING; etf_cmd_args: TUPLE; an_etf_cmd_container: ETF_ABSTRACT_UI_INTERFACE)
		do
			Precursor(an_etf_cmd_name,etf_cmd_args,an_etf_cmd_container)
			etf_cmd_routine := agent move_and_capture(? , ? , ? , ?)
			etf_cmd_routine.set_operands (etf_cmd_args)
			if
				attached {INTEGER_32} etf_cmd_args[1] as r1 and then attached {INTEGER_32} etf_cmd_args[2] as c1 and then attached {INTEGER_32} etf_cmd_args[3] as r2 and then attached {INTEGER_32} etf_cmd_args[4] as c2
			then
				out := "move_and_capture(" + etf_event_argument_out("move_and_capture", "r1", r1) + "," + etf_event_argument_out("move_and_capture", "c1", c1) + "," + etf_event_argument_out("move_and_capture", "r2", r2) + "," + etf_event_argument_out("move_and_capture", "c2", c2) + ")"
			else
				etf_cmd_error := True
			end
		end

feature -- command 
	move_and_capture(r1: INTEGER_32 ; c1: INTEGER_32 ; r2: INTEGER_32 ; c2: INTEGER_32)
    	deferred
    	end
end

note
	description: "Test the ACCOUNT class."
	author: "Umar Abdulselam"
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_ACCOUNT

inherit
	ES_TEST

create
	make

feature -- Collect all tests for ACCOUNT

	make
			-- Add test cases for ACCOUNT
		do
			add_boolean_case (agent test_account_creation)
			add_boolean_case (agent test_account_withdraw)

			-- preconditions for withdrawal
			add_violation_case_with_tag ("not_too_large", agent test_account_withdraw_precond_not_too_weak)
			add_boolean_case (agent test_account_withdraw_precond_not_too_strong)

			-- postconditions for withdrawal
			add_boolean_case (agent test_account_withdraw_postcond_not_too_weak)

			-- specification test
			add_boolean_case (agent test_transaction_value_and_date)
		end

feature -- Test cases for ACCOUNT

	test_account_creation: BOOLEAN
			-- Test the creation of an account.
		local
			acc1, acc2: ACCOUNT
		do
			comment ("t0: test the creation of an ACCOUNT")
			-- instantiate a new ACCOUNT object using a creation instruction
			-- initial credit 10 for the new account credit
			create acc1.make (10) -- initialize a new object
			Result := acc1.credit = 10 and acc1.balance = 0
			check Result end

			create acc2.make (1000) -- initialize an object
			Result := acc2.credit = 1000 and acc2.balance = 0
			check Result end
		end

	test_account_withdraw: BOOLEAN
			-- Test the withdrawal of an account
		local
			acc: ACCOUNT
		do
			comment ("t1: test the withdrawal of an ACCOUNT")
			create acc.make (10)
			Result := acc.balance = 0 and acc.credit = 10
			check Result end

			acc.withdraw (5)
			Result := acc.balance = -5 and acc.credit = 10
			check Result end
		end

	test_account_withdraw_precond_not_too_weak
			-- Test to see if the precondition of withdrawal is too weak,
			-- such that it allows values that can cause the violation
			-- of the invariant

		local
			acc: ACCOUNT
		do
			comment ("t2: test to check if precondition for withdraw is too weak")
			create acc.make (10)
			check acc.balance = 0 and acc.credit = 10 end

			acc.withdraw (5)
			check acc.balance = -5 and acc.credit = 10 end

			acc.withdraw (15)
			check acc.balance = -15 and acc.credit = 10 end
		end

	test_account_withdraw_precond_not_too_strong: BOOLEAN
			-- Test to see if the precondition of withdrawal is too strong,
			-- such that it disallows values that would not break an invariant

		local
			acc: ACCOUNT
		do
			comment ("t3: test to check if precondition for withdraw is too strong")
			create acc.make (10)
			Result := acc.balance = 0 and acc.credit = 10
			check Result end

			acc.withdraw (10)
			Result := acc.balance = -10 and acc.credit = 10
			check Result end

		end

	test_account_withdraw_postcond_not_too_weak: BOOLEAN
			-- Test to see if the postcondition of withdrawal is too weak,
			-- such that it disallows values that would not break an invariant

		local
			acc: ACCOUNT
		do
			comment ("t4: test to check if postcondition for withdraw is too weak")
			create acc.make (10)
			Result := acc.balance = 0 and acc.credit = 10
			check Result end

			acc.withdraw (6)
			Result := acc.balance = -6 and acc.credit = 10
			check Result end

		end

feature -- Specification Test

	test_transaction_value_and_date: BOOLEAN
			-- Test deposit and withdraw transactions on dates.
		local
			a: ACCOUNT
			today, tomorrow: DATE
			w1, w2, w3: TRANSACTION
			today_withdrawals: ARRAY[TRANSACTION]
		do
			comment ("t5: test transaction value and date")
			-- create today
			create today.make_now

			-- create tomorrow
			create tomorrow.make_now
			tomorrow.day_forth

			-- initialize an account of 0 credit
			create a.make (0)
			a.deposit (5500)
			a.withdraw_on_date (400, tomorrow)
			a.withdraw (1000)
			a.withdraw (4000)

			Result := a.balance = 100 and a.withdrawals_today = 5000
			check Result end

			today_withdrawals := a.withdrawals_on (today)
			Result := today_withdrawals.count = 2
			check Result end

			create w1.make (1000, today)
			create w2.make (4000, today)
			create w3.make (400, tomorrow)
			Result :=
				today_withdrawals.has (w1) and
				today_withdrawals.has (w2) and
				not today_withdrawals.has (w3)
			check Result end

		end


end

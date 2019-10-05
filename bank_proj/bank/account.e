note
	description: "[
		A class that respresents a bank account that allows customers to deposit and withdraw.
			R1: Account balances never exceed the credit limit
			R2: Clients can deposit and withdraw dollars
			R3: Tellers (but not clients) can date a dollar deposit or withdrawal differently than 'today' (e.g. as 'tomorrow')
			R4: Tellers (but not clients) can access withdrawals on a given date
			R5: Maximum total withdrawal per day is $5000
			R6: Clients can access the total amount of dollars deposited and dollars withdrawn from their account
		]"
	author: "Umar Abdulselam"
	date: "$Date$"
	revision: "$Revision$"

class
	ACCOUNT

create -- Declare the list of possible features that can be invoked as constructors
	make

feature -- Attributes

	balance: INTEGER
	credit: INTEGER
		-- history of deposits
	deposits: LIST[TRANSACTION]
		-- history of withdrawals
	withdrawals: LIST[TRANSACTION]

feature -- Constructor

	make (a_credit: INTEGER)
			-- Initialize an account with credit 'a_credit' and zero balance
		do
			balance := 0
			credit := a_credit
			create {LINKED_LIST[TRANSACTION]} deposits.make
			create {LINKED_LIST[TRANSACTION]} withdrawals.make
		ensure
			zero_balance:
				balance = 0
			credit_properly_set:
				credit = a_credit
			empty_deposits:
				deposits.is_empty
			empty_withdrawals:
				withdrawals.count = 0
		end

feature -- Commands (mutator methods)

	withdraw (a: INTEGER)
			-- Withdraw an amount 'a' from current account
		require
			not_too_small:
				a > 0
			not_too_large:
				a <= balance + credit
		local
			t: TRANSACTION
			d: DATE
		do
			balance := balance - a
			create d.make_now
			create t.make (a, d)
			withdrawals.extend (t)
		ensure
			balance_set:
				balance = old balance - a
			credit_not_changed:
				credit = old credit
			withdrawals_extended:
				withdrawals.count = old withdrawals.count + 1
			deposits_unchanged:
				deposits.count = old deposits.count
		end

	withdraw_on_date (a: INTEGER; d: DATE)
		-- Withdraw an amount 'a' from current account on date 'd'
			require
				not_too_small:
					a > 0
				not_too_large:
					a <= balance + credit
			local
				t: TRANSACTION
			do
				balance := balance - a
				create t.make (a, d)
				withdrawals.extend (t)
			ensure
				balance_set:
					balance = old balance - a
				credit_not_changed:
					credit = old credit
				withdrawals_extended:
					withdrawals.count = old withdrawals.count + 1
				deposits_unchanged:
					deposits.count = old deposits.count
			end

	deposit (a: INTEGER)
			-- Deposit an amount 'a' from current account
		require
			not_too_small:
				a > 0
		local
			t: TRANSACTION
			d: DATE
		do
			balance := balance + a
			create d.make_now
			create t.make (a, d)
			deposits.extend (t)
		ensure
			balance_set:
				balance = old balance + a
			credit_not_changed:
				credit = old credit
			withdrawals_unchanged:
				withdrawals.count = old withdrawals.count
			deposits_extended:
				deposits.count = old deposits.count + 1
		end

	deposit_on_date (a: INTEGER; d: DATE)
		-- deposit an amount 'a' from current account on date 'd'
			require
				not_too_small:
					a > 0
			local
				t: TRANSACTION
			do
				balance := balance + a
				create t.make (a, d)
				deposits.extend (t)
			ensure
				balance_set:
					balance = old balance + a
				credit_not_changed:
					credit = old credit
				withdrawals_unchanged:
					withdrawals.count = old withdrawals.count
				deposits_extended:
					deposits.count = old deposits.count + 1
			end

feature -- Queries

	withdrawals_on (d: DATE): ARRAY[TRANSACTION]
			-- Return the list of withdrawals in the history done on date 'd'.
		local
			t: TRANSACTION
			i: INTEGER
		do
			create Result.make_empty

			-- to make sure when, e.g. calling Result.has(t)
			-- 't' is considered as contained in the array iff
			-- the date and value of t match any of the stored transactions
			-- in Result
			Result.compare_objects
			check Result.object_comparison end
			from
				i := 1
				withdrawals.start
			until
				withdrawals.after
			loop
				t := withdrawals.item
				if t.date ~ d then -- note: ~ is a check for object equality
					Result.force(t, i)
					i := i + 1
				end
				withdrawals.forth
			end
		ensure
			-- forall transactions: withdrawals @ tr.date = d iff Result.has(transaction)

		end

	withdrawals_today: INTEGER
			-- Return the amount withdrawn today
		local
			today: DATE
			today_withdrawals: ARRAY[TRANSACTION]
			i: INTEGER
			t: TRANSACTION
		do
			create today.make_now
			today_withdrawals := withdrawals_on (today)
			Result := 0
			from
				i := today_withdrawals.lower
			until
				i > today_withdrawals.upper
			loop
				t := today_withdrawals[i]
				Result := Result + t.value
				i := i + 1
			end
		ensure
			state_unchanged:
				balance = old balance and credit = old credit
		end

invariant
	credit_non_negative:
		credit >= 0

	balance_not_exceeding_credit:
		balance + credit >= 0

end

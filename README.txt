The problem: 

you have a holding account with deposits from different bank
accounts. The holding account can invest (effectively spend) money, or money
can be withdrawn to a bank account. The bank account must be maintained in a 
state such that it is possible to attribute each dollar of investment to a 
particular account (in a way that is historically possible), without ever 
having the withdrawls plus investments for an account exceed the deposits.

For example:
Deposit A 100
Deposit B 100
Invest 160
Deposit A 100

Now only 40 can be withdrawn from B, since at least $60 of the investment must
be  attributed to $B, leaving 40 left over of B's funds.

What about returns from investment?

As I understand it, returns are completely unrestricted. If so, returns may be 
kept in a slush fund that can be used to fill withdraws or investments whenever
restricted money is unavailable. So dealing with the restricted money is the 
harder part of the problem. I left this part out, since this code is 
really just for proof of concept for the algorithm, I wanted make it as simple
as possible while still solving the core of the problem.

Approach: maintain a constraint for each subset of the set of accounts. These
constraints represent the total amount that can be withdrawn to a subset of 
accounts. Each operation updates all constraints. 

The key propertis of the constraints are that at each step, 

a set of withdrawls is possible if and only if it meets all the constraints. 

For instance, if you want to withdraw 50 from A and 100 from B, this is 
possible if and only if @withdraw_constraints[["A"]] >=50, 
@withdraw_constraints[["B"]] >= 100, and @withdraw_constraints[["A","B"]] 
>=150. 


If you wanted to show the algorithm does work, you would do it by showing that this key property of the constraints
is preserved by each account operation (deposit, invest, withdraw).

Hazards: this requires 2**(number of accounts) constraints, and so this can
only be done for a fairly small number of accounts. With optimization of the 
renormalize_constraints method, I would think that 10 accounts could be
maintained, which seems like a fairly reasonable number. Deleting accounts (or
dealing with the possiblility that a customer closes their bank account) is a
little problematic, in that it leaves money in the account that cannot be
 withdrawn.

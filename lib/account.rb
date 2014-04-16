
class Account
  
  def initialize
    #contains constraints of the form ["A", "B", "C"] => 100, which represents
    #a constraint X_A + X_B + X_C <= 100, where X_A is an amount of restricted 
    #funds to be withdrawn to account A. This particular constraint,
    # means that 100 dollars is the maximum amount that can be withdrawn to 
    #these accounts without violating the laundering rule.
    @withdraw_constraints = {[] => 0}
    #the set of accounts is expected to be small so it is stored as an array
    @accounts = []
  end

  def deposit(account, amount)
    update_constraints(account, amount)
  end
  
  def balance
    @withdraw_constraints[@accounts]
  end
  
  #invests money from an account
  def invest(amount)
    if amount > balance
      raise "overcharge"
    else
      @withdraw_constraints[@accounts] -= amount
      normalize_constraints
    end
  end

  def withdraw(account, amount)
    if amount > balance
      raise "overcharge"
    elsif amount > @withdraw_constraints[[account]] 
      raise "withdrawl violates anti-laundering constraint"
    else
      update_constraints(account, -1 * amount)
      normalize_constraints
    end
  end
  
  private
  
  
  #fixes constraints so that the constraint for a subset takes into account 
  #constraints on its supersets 
  def normalize_constraints
    account_subsets.each do |subset|
      @withdraw_constraints[subset] = normalized_constraint(subset)
    end
  end
  
  #returns the largest total amount that can currently be withdrawn
  #to accounts in subset without touching unrestricted funds
  def normalized_constraint(subset = @accounts)
    smallest = Float::INFINITY 
    account_subsets(subset).each do |accounts|
      smallest = [smallest, @withdraw_constraints[accounts]].min
    end
    smallest
  end
  

  #deposits (for positive amount) or withdraws (for negative amount)
  #from account's funds, updating all laundering constraints containing
  #account
  def update_constraints(account, amount)
    add_account(account) unless @accounts.include?(account)
    account_subsets([account]).each do |subset|
      @withdraw_constraints[subset] += amount
    end
  end

  #returns array of all subsets containing all accounts in accounts. 
  #if accounts is not given, returns all subsets.
  def account_subsets(accounts = [])
    other_accounts = @accounts - accounts
    (0..other_accounts.length).flat_map do |size|
      other_accounts.combination(size).map do |others|
        (others + accounts).sort
      end
    end
  end
  
  #adds account with no deposit
  def add_account(account)
    @accounts << account
    @accounts.sort!
    account_subsets([account]).each do |subset|
      #the new limit for each subset containing the new account is the same as 
      #the previous limit for subset excluding the new account
      subset_limit = @withdraw_constraints[subset - [account]]
      @withdraw_constraints[subset] = subset_limit
    end
  end

end





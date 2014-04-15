
class Account
  attr_reader :balance
  
  def initialize
    @balance = 0
    @withdraw_constraints = Hash.new(0)
    @unrestricted_amount = 0
  end

  def credit(account, amount)
    @balance += amount
    @withdraw_constraints[account] += amount
  end
  
  #invests money from an account
  def invest(amount)
    if amount > @balance
      raise "overcharge"
    else
      @balance -= amount
    end
  end

  def withdraw(account, amount)
    if amount > @balance
      raise "overcharge"
    elsif amount > @withdraw_constraints[account] + @unrestricted_amount
      raise "charge violates anti-laundering contraint"
    else
      leftover_constraint = @withdraw_constraints[account] - amount
      @withdraw_constraints[account] = [leftover_constraint, 0].max
      @unrestricted_amount += leftover_constraint if leftover_constraint < 0
      @balance -= amount
    end
  end
  
  #returns money to an account from an investment
  def return(amount)
    @balance += amount
    @unrestricted_amount += amount
  end

end





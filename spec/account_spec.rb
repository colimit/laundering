require "account"

LAUNDERING = "withdrawl violates anti-laundering constraint"

describe Account do
  
  before(:each) do 
    @account = Account.new
  end
  
  describe "basic functionality" do
  
    it "starts with a balance of 0" do
      expect(@account.balance).to eq(0)
    end
  
    it "credits the account" do
      @account.deposit("A", 100)
      expect(@account.balance).to eq(100)
    end
  

    it "reduces balance when withdrawing" do
      @account.deposit("A", 100)
      @account.withdraw("A", 50)
      expect(@account.balance).to eq(50)
    end
    
    it "reduces balance when investing" do
      @account.deposit("A", 100)
      @account.invest(50)
      expect(@account.balance).to eq(50)
    end
    
    it "overcharging results in an overcharge error" do
      @account.deposit("A", 100)
      expect { @account.withdraw("A", 200) }.to raise_error("overcharge")
    end
    
  end
  
  describe "anti-laundering protection" do
    
    it "raises error for a simple violation" do
      @account.deposit("A", 100)
      @account.deposit("B", 100)
      expect { @account.withdraw("A", 120) }.to raise_error(LAUNDERING)
    end
    
    it "raises error for a more complex example where order matters" do
      @account.deposit("A", 100)
      @account.deposit("B", 100)
      @account.invest(150)
      @account.deposit("C", 50)
      
      expect { @account.withdraw("A", 75) }.to raise_error(LAUNDERING)
    end
    
    it "does not raise error in a simple case with multiple accounts" do
      @account.deposit("A", 100)
      @account.deposit("B", 100)
      @account.invest(150)
      @account.withdraw("A",50)
      expect(@account.balance).to eq(0)
    end
    
    it "does not raise error in a more complex case with multiple accounts" do
      @account.deposit("A", 100)
      @account.deposit("B", 100)
      @account.invest(150)
      @account.deposit("C", 100)
      @account.invest(100)
      @account.withdraw("A", 25)
      expect(@account.balance).to eq(25)
    end
    
    it "raises error in a more complex case with multiple accounts" do
      @account.deposit("A", 100)
      @account.deposit("B", 100)
      @account.invest(150)
      @account.deposit("C", 100)
      @account.invest(100)
      @account.deposit("D", 100)
      @account.withdraw("B", 50)
      expect { @account.withdraw("C", 5) }.to raise_error(LAUNDERING)
    end
    
    
    it "handles an example with repeated investing" do
      @account.deposit("A", 100)
      @account.deposit("B", 100)
      19.times do
        @account.invest(10)
      end
      @account.deposit("C", 100)
      9.times do
        @account.invest(10)
      end
      expect { @account.withdraw("B",20) }.to raise_error(LAUNDERING)
    end
    
    
    
    
  end
  
  
end
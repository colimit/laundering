require "account"

describe Account do
  
  before(:each) do 
    @account = Account.new
  end
  
  describe "basic functionality" do
  
    it "starts with a balance of 0" do
      expect(@account.balance).to eq(0)
    end
  
    it "credits the account" do
      @account.credit("A", 100)
      expect(@account.balance).to eq(100)
    end
  
    it "credits the with investment return" do
      @account.return(100)
      expect(@account.balance).to eq(100)
    end
    
    it "reduces balance when withdrawing" do
      @account.credit("A", 100)
      @account.withdraw("A", 50)
      expect(@account.balance).to eq(50)
    end
    
    it "reduces balance when investing" do
      @account.credit("A", 100)
      @account.invest(50)
      expect(@account.balance).to eq(50)
    end
    
    it "overcharging results in an overcharge error" do
      @account.credit("A", 100)
      expect { @account.withdraw("A", 200) }.to raise_error("overcharge")
    end
    
  end
  
  describe "anti-laundering protection" do
    
  end
  
  
end
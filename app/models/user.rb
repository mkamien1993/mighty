class User < ApplicationRecord
  before_create :assign_balance

  def subtract_balance(price)
    new_balance = self.balance - price
    self.update(balance: new_balance)
  end

  def add_balance(price)
    new_balance = self.balance + price
    self.update(balance: new_balance)
  end

  def has_enough_balance(price)
    self.balance >= price
  end

  private

  def assign_balance
    self.balance = 100
  end
end

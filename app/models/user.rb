class User < ApplicationRecord
  before_create :assign_balance

  private

  def assign_balance
    self.balance = 100
  end
end

class Nft < ApplicationRecord
  validates_presence_of :description
  validates_presence_of :owner_id

  has_one_attached :image, :dependent => :destroy
  before_create :add_owner_id_to_co_creators

  def co_creators
    creators_ids
  end

  private

  def add_owner_id_to_co_creators
    creators_ids << owner_id
  end
end
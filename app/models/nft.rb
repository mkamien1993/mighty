class Nft < ApplicationRecord
  validates_presence_of :description
  validates_presence_of :owner_id
  validates_presence_of :image

  has_one_attached :image, :dependent => :destroy
  before_create :add_owner_id_as_co_creator

  def co_creators
    creators_ids
  end

  private

  def add_owner_id_as_co_creator
    co_creators << owner_id unless co_creators.include?(owner_id)
  end
end
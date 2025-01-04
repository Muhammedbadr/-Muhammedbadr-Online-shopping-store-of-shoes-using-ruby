class Invoice < ApplicationRecord
  belongs_to :user
  belongs_to :product
  has_many :reviews

end

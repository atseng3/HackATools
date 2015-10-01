class Review < ActiveRecord::Base
  before_save :calc_overall_rating
	belongs_to :user
	belongs_to :product
	
	validates :ease_of_use_rating, :speed_of_dev_rating, :comment, presence: true
  validates :ease_of_use_rating, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 5,
    message: "can only be a whole number between 1 and 5"
  }
  validates :speed_of_dev_rating, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 5,
    message: "can only be a whole number between 1 and 5"
  }

  private 
    def calc_overall_rating
      self.rating = (self.ease_of_use_rating + self.speed_of_dev_rating) / 2
    end
end

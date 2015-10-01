class AddEaseRatingToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :ease_of_use_rating, :integer
    add_column :reviews, :speed_of_dev_rating, :integer
  end
end

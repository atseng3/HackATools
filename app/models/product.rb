class Product < ActiveRecord::Base
	mount_uploader :image, ImageUploader
	acts_as_ordered_taggable # Alias for acts_as_taggable_on :tags


	searchkick word_start: [:name]

	has_many :reviews
	validates :name, :website, presence: true
	validates :website, format: { with: /\Ahttps?:\/\/.*\z/,
	  message: "must start with http:// or https://" }

	def avg_rating
		reviews = Review.where(product_id: self.id).order('created_at DESC')
    if reviews.blank?
      rating = 0
    else
      rating = reviews.average(:rating).round(2)
    end
    rating
	end
end

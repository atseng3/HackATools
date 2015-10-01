class PagesController < ApplicationController
  def about
  end

  def contact
  end

  def profile
  	@reviews = current_user.reviews
  end
end

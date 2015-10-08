class PagesController < ApplicationController
  before_action :authenticate_user!
  def about
  end

  def contact
  end

  def profile
  	@reviews = current_user.reviews
  end
end

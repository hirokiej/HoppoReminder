class HomeController < ApplicationController
  skip_before_action :check_logged_in, only: %i[index privacy term]
  def index
  end

  def privacy; end
  def term; end
end

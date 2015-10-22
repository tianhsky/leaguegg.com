class HomeController < BaseController

  def show
    if is_crawler?
      @featured = GameService::Service.find_current_featured_games('NA')
    else
      render 'angular/wrapper'
    end
  end

end

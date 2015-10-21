class AppsController < BaseController

  def show
    if is_crawler?
      # default page
    else
      render 'angular/wrapper'
    end
  end

end

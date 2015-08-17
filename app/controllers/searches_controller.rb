class SearchesController < ApplicationController

  skip_before_filter :set_nav

  def show
    if search_type == 'game'
      if search_region.blank? || search_summoner_name.blank?
        redirect_to :back and return
      end
      # redirect_to game_path({
      #   'region' => search_region,
      #   'summoner_name' => search_summoner_name
      # })
    elsif search_type == 'summoner'
      if search_region.blank? || search_summoner_name.blank?
        redirect_to :back and return
      end
      # redirect_to summoner_path({
      #   'region' => search_region,
      #   'summoner_name' => search_summoner_name
      # })
    end
  end

  protected

  def search_type
    @search_type ||= params['type'].try(:downcase)
  end

  def search_region
    @search_region ||= params['region'].try(:downcase)
  end

  def search_summoner_name
    @search_summoner_name ||= params['summoner_name']
  end

end

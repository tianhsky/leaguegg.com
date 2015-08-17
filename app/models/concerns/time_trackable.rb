module TimeTrackable
  extend ActiveSupport::Concern
  included do
    field :created_at, type: Integer
    field :updated_at, type: Integer
    field :synced_at, type: Integer

    before_create :touch_created_at
    before_create :touch_updated_at
    before_update :touch_updated_at
  end

  def touch_synced_at
    self.synced_at = epunix_now
  end

  def created_at_time
    Time.at(created_at/1000)
  end

  def updated_at_time
    Time.at(updated_at/1000)
  end

  private

  def touch_updated_at
    self.updated_at = epunix_now
  end

  def touch_created_at
    self.created_at = epunix_now
  end

  def epunix_now
    Utils::Time.time_to_epunix(Time.now)
  end

end
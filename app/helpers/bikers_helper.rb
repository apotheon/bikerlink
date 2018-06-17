module BikersHelper
  def alert_not_active username
    %Q{No Active Biker: "#{username}"}
  end
end

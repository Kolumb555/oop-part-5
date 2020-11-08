class Route

  attr_reader :route_stations
  
  def initialize(start_station, end_station)
    @route_stations = [start_station, end_station]
  end

  def add_intermediate_station(station)
    @route_stations.insert(1, station)
  end

  def exclude_intermediate_station(station)
    @route_stations.delete(station)
  end
end
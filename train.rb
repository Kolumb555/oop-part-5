class Train

  attr_reader :speed, :route, :number, :cars, :station_number

  def initialize(number)
    @number = number
    @speed = 0
    @station_number = 0
    @cars = []
  end

  def accelerate(speed)
    @speed = speed
  end

  def brake
    @speed = 0
  end

  def detach_car(car)
    @cars.delete(car) if @speed==0
  end

  def get_route(route)
    @route = route
    @station_number = 0
  end

  def move_forward

    if (@station_number + 1) >= @route.route_stations.size
      puts 'Нельзя переместить поезд дальше конечной станции'
    else
      @station_number += 1
    end
  end
  
  def move_back

    if @station_number == 0
      puts 'Нельзя переместить поезд дальше начальной станции'
    else
      @station_number -= 1
    end
  end

  def previous_station
    @route.route_stations[@station_number - 1] if @station_number >= 1
  end

  def current_station
    @route.route_stations[@station_number]
  end

  def next_station
    @route.route_stations[@station_number + 1] if @station_number < @route.route_stations.size
  end
end


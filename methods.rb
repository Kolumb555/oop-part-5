def trains?(trains)
  if trains.size == 0
    puts 'Отсутствует информация о поездах'
  end
end

def routes?(routes)
  if routes.size == 0
    puts 'Отсутствует информация о маршрутах'
  end
end

def stations?(stations)
  if stations.size == 0
    puts 'Отсутствует информация о станциях. Вначале необходимо добавить станции'
  end
end

def request_for_train_number(trains) #выводит список поездов и запрашивает номер
  puts 'Выберите порядковый номер поезда'
  trains.each_with_index do |train, i|
    puts "#{i + 1}. #{train.number}"
  end
end

def request_for_route_number(routes) #выводит список маршрутов и запрашивает выбор
  puts 'Выберите порядковый номер маршрута' 
  routes.each_with_index do |route, i|
    puts "#{i + 1}. #{route.route_stations[0].name} - #{route.route_stations[-1].name}"
  end
end

def request_for_station_number(stations) #выводит список станций и запрашивает номер
  puts 'Выберите порядковый номер станции для добавления в маршрут. Для создания маршрута необходимо добавить как минимум 2 станции.'
  stations.each_with_index do |station, i|
    puts "#{i + 1}. #{station.name}"
  end
end

def trains_number_with_routes_arr(trains) #возвращает массив номеров поездов с присвоенными маршрутами
  trains_with_routes = []
  trains.each_with_index do |train, i|
    if train.route
      trains_with_routes << i
    end
  end
  trains_with_routes
end

def trains_with_routes(trains) #выводит список поездов с присвоенными маршрутами и запрашивает номер поезда
  puts 'Выберите порядковый номер поезда'
  trains.each_with_index do |train, i|
    if train.route
      puts "#{i + 1}. #{train.number} #{train.route.route_stations[1, -1]}"
    end
  end
end

def is_included?(array, number)
  (1..array.size).include?(number)
end

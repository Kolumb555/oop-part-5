require_relative 'route.rb'
require_relative 'station.rb'
require_relative 'train.rb'
require_relative 'cargo_car.rb'
require_relative 'cargo_train.rb'
require_relative 'passenger_car.rb'
require_relative 'passenger_train.rb'
require_relative 'methods.rb'

stations = []
trains = []
routes = []

loop do
  puts "\n Для выбора необходимого действия введите, пожалуйста, соответствующую цифру:

  1 - Создать станцию
  2 - Создать поезд
  3 - Создать маршрут и управлять станциями в нем (добавлять, удалять)
  4 - Назначить маршрут поезду
  5 - Добавить вагоны к поезду
  6 - Отцепить вагоны от поезда
  7 - Перемещать поезд по маршруту вперед и назад
  8 - Просмотреть список станций и список поездов на станциях
  0 - Выход из программы"

  choice = gets.to_i

  case choice
  when 1 #Создавать станции
    puts 'Введите название станции'
    name = gets.chomp

    if stations.count { |s| s.name.match(name) } == 0
      stations << Station.new(name)
      puts "\n Станция #{name} добавлена"
    else
      puts "\n Такая станция уже существует"
    end

  when 2 #Создавать поезда
    puts 'Введите номер поезда'
    number = gets.chomp

    if trains.count { |t| t.number.match(number) } == 0

      loop do
        puts 'Выберите тип поезда: 1 - пассажирский, 2 - грузовой'
        type = gets.to_i
        if type == 1
          trains << PassengerTrain.new(number)
          break
        elsif type == 2
          trains << CargoTrain.new(number)
          break
        else
          puts 'Для выбора типа поезда необходимо ввести цифру: 1 - пассажирский, 2 - грузовой'
        end
      end

    else
      puts "\n Поезд с таким номером уже существует"
    end

  when 3 #Создавать маршруты и управлять станциями в нем (добавлять, удалять)

    stations?(stations)
    next if stations.size == 0

    route_to_add = []

    while route_to_add.size < 2

      request_for_station_number(stations)
      station = gets.to_i #номер станции в списке

      if is_included?(stations, station)
        route_to_add << stations[station - 1]
      else
        puts 'Необходимо указать порядковый номер станции из списка'
      end
    end

    routes << Route.new(route_to_add[0], route_to_add[1])

    loop do

      puts 'Хотите внести изменения в маршрут?
      1 - да, добавить станцию'
      if routes[-1].route_stations.size >= 1
        puts '      2 - да, удалить станцию'
      end
      puts '      нет - любое другое значение'
      choice = gets.to_i

      if choice == 1
        stations.each { |s| puts s.name }
          puts 'Введите название промежуточной станции маршрута'

        station = gets.chomp
        unless routes[-1].route_stations.include?(station)
          routes[-1].add_intermediate_station(station)
        else
          puts 'Такая станция уже есть в данном маршруте'
        end

      elsif choice == 2
        if routes[-1].route_stations.size >= 1
          puts 'Введите название станции маршрута, которую необходимо удалить:'
          routes[-1].route_stations.each { |s| puts s }
          station = gets.chomp

          if routes[-1].route_stations.include?(station)
            puts "Станция #{station} удалена"
            routes[-1].exclude_intermediate_station(station)
          else
            puts 'Такая станция отсутствует в маршруте'
          end
        else
          break
        end

      else
        break
      end
    end

  when 4 #Назначать маршрут поезду

    trains?(trains)
    routes?(routes)
    next if (routes.size == 0 || trains.size == 0)

    request_for_route_number(routes)

    route_num = gets.to_i

    request_for_train_number(trains)

    train_num = gets.to_i

    if is_included?(routes, route_num) && is_included?(trains, train_num) #проверка выбора поезда и маршрута
      trains[train_num - 1].get_route(routes[route_num - 1])
      puts "Поезду #{trains[train_num - 1].number} назначен маршрут #{routes[route_num - 1].route_stations[0].name} - #{routes[route_num - 1].route_stations[-1].name}"
    else
      puts 'Необходимо указать порядковый номер поезда и маршрута из списка'
    end
    
  when 5 #Добавлять вагоны к поезду

    trains?(trains)
    next if trains.size == 0

    request_for_train_number(trains)
    train_num = gets.to_i

    if trains[train_num-1].class == PassengerTrain
      trains[train_num-1].attach_car(PassengerCar.new)
      puts "Поезду #{trains[train_num - 1].number} добавлен вагон.
      Количество вагонов в поезде: #{trains[train_num - 1].cars.size}."
    elsif trains[train_num-1].class == CargoTrain
      trains[train_num-1].attach_car(CargoCar.new)
      puts "Поезду #{trains[train_num - 1].number} добавлен вагон.
      Количество вагонов в поезде: #{trains[train_num - 1].cars.size}."
    else
      puts 'Поезд с таким порядковым номером отсутствует'
    end

  when 6 #Отцеплять вагоны от поезда

    trains?(trains)
    next if trains.size == 0

    request_for_train_number(trains)
    train_num = gets.to_i
      
    if is_included?(trains, train_num)
      if trains[train_num - 1].cars.size > 0
        trains[train_num - 1].cars.delete_at(-1)
        puts "От поезда #{trains[train_num - 1].number} отцеплен вагон.
        Количество вагонов в поезде: #{trains[train_num - 1].cars.size}."
      else
        puts 'Отцеплять вагоны возможно только от поезда, количество вагонов которого не менее одного.'
      end
    else
      puts 'Необходимо указать порядковый номер поезда из списка'
    end

  when 7 #Перемещать поезд по маршруту вперед и назад

    trains_with_routes_qty = (trains.size - trains.count { |t| t.route.nil? })

    if trains_with_routes_qty == 0
      puts 'Ни одному поезду не присвоен маршрут'
    end

    next if trains_with_routes_qty == 0

    if trains_with_routes_qty == 1
      train_to_move = trains.select { |t| t.route }
      train_to_move = train_to_move[0]
      puts "Единственный поезд с присвоенным маршрутом: #{train_to_move.number}"
    else
      loop do
        trains_with_routes(trains) #запрос номера поезда, который перемещаем
        train_num = gets.to_i
        if trains[train_num - 1].route
          train_to_move = trains[train_num - 1]
          break
        else
          puts 'Необходимо указать порядковый номер поезда из списка, которому присвоен маршрут'
        end
      end
    end

    loop do
      puts 'Куда переместить поезд?
      1. Вперед
      2. Назад
      0. Выход в главное меню'

    direction = gets.to_i

    case direction
    when 1
      train_to_move.move_forward
    when 2
      train_to_move.move_back
    when 0
      break
    end
  end

when 8 #Просматривать список станций и список поездов на станции

  if stations.size == 0
    puts 'Список станций пуст'
  else
    puts 'Список станций:'
    stations.each { |station| puts station.name }
  end

  if trains.size == 0
    puts 'Список поездов пуст'
  else
    trains.each do |train|
      if train.route
        puts "\n Поезд #{train.number} находится на станции #{train.route.route_stations[train.station_number].name}"
      end
    end
  end

  when 0
    break
  end

end

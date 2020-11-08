require_relative 'train.rb'

class PassengerTrain < Train

  def attach_car(car)
    @cars << car if (@speed == 0 && car.class == PassengerCar)
  end
end
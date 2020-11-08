require_relative 'train.rb'

class CargoTrain < Train

  def attach_car(car)
    @cars << car if (@speed == 0 && car.class == CargoCar)
  end
end
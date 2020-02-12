# frozen_string_literal: true

class Ticket
  attr_accessor :origin, :destination, :name

  def initialize(origin, destination, name)
    @origin = origin
    @destination = destination
    @name = name
  end
end

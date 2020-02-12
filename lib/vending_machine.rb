# frozen_string_literal: true

require 'pry'

class VendingMachine
  attr_accessor :tickets, :route

  def initialize(path, location)
    @path = path
    @route = load_json_file(path)
    @stationed_at = location
    @tickets = []
  end

  def find_index(station)
    @route.find_index do |r|
      r["station name"] == station
    end
  end



  def purchase_tickets(destination, tickets_needed, name)

    starting_place = self.stationed_at
    starting_index = find_index(starting_place)
    ending_index = find_index(destination)
    @tickets_needed = tickets_needed

    if ending_index > starting_index

      chosen_route_south = @route[starting_index...ending_index]
      @answer = chosen_route_south.none? { |r| r["remaining seats"] < tickets_needed }

      if @answer == true
        adjust_tickets
        get_tickets(starting_place, destination, name, tickets_needed)
        "Transaction completed, thank you for choosing Amtrak."
      else
        "Tickets can't be purchased because there are not enough seats. We aplogize for the inconvenience."
      end

    else ending_index < starting_index
      chosen_route_north = @route[ending_index...starting_index]

      @answer = chosen_route_north.none? { |r| r["remaining seats"] < tickets_needed }

      if @answer == true
        adjust_tickets
        get_tickets(starting_place, destination, name, tickets_needed)
        "Transaction completed, thank you for choosing Amtrak."
      else
        "Tickets can't be purchased because there are not enough seats. We aplogize for the inconvenience."
      end
    end
  end

  def get_tickets(starting_place, destination, name, tickets_needed)
    tickets_needed.times do
      self.tickets << Ticket.new(starting_place, destination, name)
    end
  end

  def adjust_tickets
    self.route.each_with_index do |r, i|
      r["remaining seats"] -= @tickets_needed
    end
  end

  def load_json_file(file_path)
    file = File.read(file_path)
    data_hash = JSON.parse(file)
    data_hash
  end

  def stationed_at
    @stationed_at
  end
end

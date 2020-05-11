require "byebug"

class VendingMachine

  attr_reader :path, :stationed_at, :tickets
  attr_accessor :route

  def initialize(path, location)
    @path=path
    @stationed_at=location
    @tickets = []
    @route = load_json_file(path)
  end

  def load_json_file(path)
    file = File.open(path)
    data = JSON.load file
    data
  end

  def purchase_tickets(destination, number_of_tickets, name)
    index_stationed_at = route.index { |r| r["station name"] == stationed_at }
    index_destination = route.index { |r| r["station name"] == destination }

    if route[index_stationed_at...index_destination].any? { |r| r["remaining seats"] < number_of_tickets } || route[index_destination...index_stationed_at].any? { |r| r["remaining seats"] < number_of_tickets }

    "Tickets can't be purchased because there are not enough seats. We aplogize for the inconvenience." 

    elsif route[index_stationed_at...index_destination].any? { |r| r["remaining seats"] >= number_of_tickets }
      
      adjust_num_of_remaining_seats(index_stationed_at, index_destination, number_of_tickets)
      
      while number_of_tickets > 0
        ticket = Ticket.new(stationed_at, destination, name)
        @tickets << ticket 
        number_of_tickets -= 1
      end

      "Transaction completed, thank you for choosing Amtrak."
    
    else route[index_destination...index_stationed_at].any? {|r| r["remaining seats"] >= number_of_tickets }

      adjust_num_of_remaining_seats(index_stationed_at, index_destination, number_of_tickets)

      while number_of_tickets > 0
        ticket = Ticket.new(stationed_at, destination, name)
        @tickets << ticket 
        number_of_tickets -= 1
      end

        "Transaction completed, thank you for choosing Amtrak."

    end
  end

  def adjust_num_of_remaining_seats(index_stationed_at, index_destination, number_of_tickets)
    self.route.each_with_index do |station, i|
      if index_stationed_at <= i && i <= index_destination
        station["remaining seats"] -= number_of_tickets
      else
        station["remaining seats"] -= number_of_tickets
      end
    end
  end
end
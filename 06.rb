require 'set'

module Day06
  class << self
    START_OF_PACKET_SIZE = 4
    START_OF_MESSAGE_SIZE = 14

    def uniq_window_index(string, window_size:)
      string.chars.each_cons(window_size).find_index do |cs|
        cs.uniq.size == window_size
      end + window_size
    end

    def part_one(input)
      input.map do |line|
        uniq_window_index(line, window_size: START_OF_PACKET_SIZE)
      end
    end

    def part_two(input)
      input.map do |line|
        uniq_window_index(line, window_size: START_OF_MESSAGE_SIZE)
      end
    end
  end
end

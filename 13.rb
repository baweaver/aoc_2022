module Day13
  class << self
    Packet = Struct.new(:value) do
      include Comparable

      def <=>(other)
        Day13.compare(self.value, other.value)
      end
    end

    def compare(left, right)
      case [left, right]
      in [Integer, Integer] then left <=> right
      in [Integer, Array]   then compare([left], right)
      in [Array, Integer]   then compare(left, [right])
      in [Array, Array]
        left.each_with_index do |left_item, i|
          compare(left_item, right[i]).then { return _1 unless _1.zero? }
        end

        left.size <=> right.size
      else
        1
      end
    end

    def part_one(input)
      input
        .each_slice(3)
        .map { [eval(_1), eval(_2)] }
        .filter_map.with_index(1) { |(a, b), i| i if compare(a, b) <= 0 }
        .sum
    end

    def part_two(input)
      dividers = [Packet.new([[2]]), Packet.new([[6]])] => a, b

      input
        .reject(&:empty?)
        .map { Packet[eval(_1)] }
        .concat(dividers)
        .sort
        .then { (_1.find_index(a) + 1) * (_1.find_index(b) + 1) }
    end
  end
end

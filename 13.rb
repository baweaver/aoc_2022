module Day13
  class << self
    Packet = Struct.new(:value) do
      include Comparable

      def <=>(other) = compare(self.value, other.value)

      private def compare(a, b)
        case [a, b]
        in [Integer, Integer] then a <=> b
        in [Integer, Array] | [Array, Integer] then compare(Array(a), Array(b))
        in [Array, Array]
          a.zip(b).each { |x, y| compare(x, y).then { return _1 if _1 != 0 } }
          a.size <=> b.size
        else
          1
        end
      end
    end

    DIVIDERS = [Packet.new([[2]]), Packet.new([[6]])]

    def part_one(input)
      input
        .each_slice(3)
        .map { [Packet[eval(_1)], Packet[eval(_2)]] }
        .filter_map.with_index(1) { |(a, b), i| i if a <= b }
        .sum
    end

    def part_two(input)
      input
        .reject(&:empty?)
        .map { Packet[eval(_1)] }
        .concat(DIVIDERS)
        .sort
        .then { |vs| DIVIDERS.reduce(1) { _1 * vs.find_index(_2) } }
    end
  end
end

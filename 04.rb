module Day04
  class << self
    def range_covers?(a, b)
      a.cover?(b.begin) && a.cover?(b.end) ||
      b.cover?(a.begin) && b.cover?(a.end)
    end

    def range_overlaps?(a, b)
      a.cover?(b.begin) || a.cover?(b.end) ||
      b.cover?(a.begin) || b.cover?(a.end)
    end

    def part_one(input)
      input.count do |line|
        a, b = line
          .split(',')
          .map { Range.new(*_1.split('-').map(&:to_i)) }

        range_covers?(a, b)
      end
    end

    def part_two(input)
      input.count do |line|
        a, b = line
          .split(',')
          .map { Range.new(*_1.split('-').map(&:to_i)) }

        range_overlaps?(a, b)
      end
    end
  end
end

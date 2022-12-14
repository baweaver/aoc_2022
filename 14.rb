module Day14
  class << self
    ARROW = '->'
    SAND_SOURCE = [500, 0]

    class Grid
      WALL = '#'
      SAND = 'o'

      attr_reader :sand_count

      def initialize(wall_coordinates, infinite_floor: false)
        @collection = wall_coordinates.to_h { [_1, WALL] }
        @infinite_floor = infinite_floor
        @sand_count = 0

        @vertical_max = wall_coordinates.map(&:last).max
        @horizontal_max = wall_coordinates.map(&:first).max
      end

      def item_at(x, y) = @collection[[x, y]]

      def fall_distribution_from(x, y)
        [[x, y + 1], [x - 1, y + 1], [x + 1, y + 1]]
      end

      def adjusted_coordinates(x, y)
        fall_distribution_from(x, y).find { @collection[_1].nil? }
      end

      def settled?(x, y)
        fall_distribution_from(x, y).none? { @collection[_1].nil? }
      end

      def sand_at?(x, y) = item_at(x, y) == SAND
      def wall_at?(x, y) = item_at(x, y) == WALL
      def empty_at?(x, y) = item_at(x, y).nil?

      def floor?(x, y) = y == @vertical_max + 1
      def void?(x, y) = y > @vertical_max

      def fill_with_sand(x, y)
        @sand_count += 1
        @collection[[x, y]] = SAND
      end
    end

    def zip_range(a, b)
      a.flat_map { |x| b.map { |y| [x, y] } }
    end

    def get_wall_coordinates(input)
      input.flat_map do |line|
        line
          .split(ARROW)
          .map { _1.split(',').map(&:to_i) }
          .each_cons(2)
          .map { _1.zip(_2).map(&:sort) }
          .flat_map { zip_range(Range.new(*_1), Range.new(*_2))  }
      end
    end

    def part_one(input)
      grid = Grid.new(get_wall_coordinates(input))

      loop do
        x, y = SAND_SOURCE

        loop do
          break if grid.settled?(x, y) || grid.void?(x, y)

          x, y = grid.adjusted_coordinates(x, y)
        end

        break if grid.void?(x, y)

        grid.fill_with_sand(x, y)
      end

      grid.sand_count
    end

    def part_two(input)
      grid = Grid.new(get_wall_coordinates(input))

      loop do
        x, y = SAND_SOURCE
        break if grid.sand_at?(x, y)

        loop do
          grid.fill_with_sand(x, y) and break if grid.settled?(x, y) || grid.floor?(x, y)

          x, y = grid.adjusted_coordinates(x, y)
        end
      end

      grid.sand_count
    end
  end
end

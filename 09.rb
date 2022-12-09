require 'set'

module Day09
  class << self
    DIRECTION_MAP = {
      'U' => [0, 1],
      'D' => [0, -1],
      'L' => [-1, 0],
      'R' => [1, 0],
    }

    class Point
      attr_reader :x, :y, :visited

      def initialize(x:, y:)
        @x, @y = x, y
        @visited = Set.new([[@x, @y]])
      end

      def step!(direction:, steps:, &trail_fn)
        dx, dy = DIRECTION_MAP[direction]

        steps.times do
          move!(dx:, dy:)
          trail_fn.call(self)
        end
      end

      def move!(dx:, dy:)
        @x += dx
        @y += dy

        @visited.add([@x, @y])
      end

      def delta(other)      = [@x - other.x, @y - other.y]
      def tail_delta(other) = [other.x - @x, other.y - @y]

      def clamp_delta(original_delta)
        case original_delta
        when 1..  then 1
        when 0    then 0
        when ..-1 then -1
        end
      end

      def trail!(other)
        dx, dy = tail_delta(other)

        return self unless [dx, dy].map(&:abs).any? { _1 > 1 }

        trail_x = clamp_delta(dx)
        trail_y = clamp_delta(dy)

        move!(dx: trail_x, dy: trail_y)
        self
      end

      def to_s
        "(x: #{self.x}, y: #{self.y})"
      end
    end

    def part_one(input)
      head = Point.new(x: 0, y: 0)
      tail = Point.new(x: 0, y: 0)

      input.each do |line|
        direction, steps = line.split.then { [_1, _2.to_i] }

        head.step!(direction:, steps:) { tail.trail!(_1) }
      end

      tail.visited.size
    end

    def part_two(input)
      head = Point.new(x: 0, y: 0)

      tail_points = {
        one: Point.new(x: 0, y: 0),
        two: Point.new(x: 0, y: 0),
        three: Point.new(x: 0, y: 0),
        four: Point.new(x: 0, y: 0),
        five: Point.new(x: 0, y: 0),
        six: Point.new(x: 0, y: 0),
        seven: Point.new(x: 0, y: 0),
        eight: Point.new(x: 0, y: 0),
        tail: Point.new(x: 0, y: 0),
      }

      input.each do |line|
        direction, steps = line.split.then { [_1, _2.to_i] }

        head.step!(direction:, steps:) do |current_head|
          tail_points.reduce(current_head) do |consumed_head, (name, trailing_point)|
            trailing_point.trail!(consumed_head)
          end
        end
      end

      tail_points[:tail].visited.size
    end
  end
end

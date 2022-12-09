require 'set'

module Day09
  class << self
    DIRECTION_MAP = { 'U' => [0, 1], 'D' => [0, -1], 'L' => [-1, 0], 'R' => [1, 0] }

    class Point
      attr_reader :x, :y, :visited

      def initialize(x:, y:)
        @x, @y = x, y
        @visited = Set.new([[@x, @y]])
      end

      def step!(direction:, steps:, &trail_fn)
        dx, dy = DIRECTION_MAP[direction]
        steps.times { move!(dx:, dy:).then { trail_fn.call(self) } }
      end

      def move!(dx:, dy:)
        @x += dx
        @y += dy

        @visited.add([@x, @y])
      end

      def trail!(head)
        [head.x - @x, head.y - @y]
          .then { |ds| ds.any? { _1.abs > 1 } ? ds : [0, 0] }
          .map { _1.clamp(-1, 1) }
          .then { move!(dx: _1, dy: _2) }

        self
      end

      def to_s = "(x: #{self.x}, y: #{self.y})"
    end

    def actions(input) = input.map { |v| v.split.then { [_1, _2.to_i] } }

    def part_one(input)
      head, tail = Point.new(x: 0, y: 0), Point.new(x: 0, y: 0)

      actions(input).each do |direction, steps|
        head.step!(direction:, steps:) { tail.trail!(_1) }
      end

      tail.visited.size
    end

    def part_two(input)
      head, *tail_points = 10.times.map { Point.new(x: 0, y: 0) }

      actions(input).each do |direction, steps|
        head.step!(direction:, steps:) do |current_head|
          tail_points.reduce(current_head) do |consumed_head, trailing_point|
            trailing_point.trail!(consumed_head)
          end
        end
      end

      tail_points.last.visited.size
    end
  end
end

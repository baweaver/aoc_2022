module Day08
  class << self
    def traveling_paths(x:, y:, row_count:, col_count:)
      up_coords     = [*0...y].map { [x, _1] }.reverse
      down_coords   = [*y+1...col_count].map { [x, _1] }
      left_coords   = [*0...x].map { [_1, y] }.reverse
      right_coords  = [*x+1...row_count].map { [_1, y] }

      { left_coords:, right_coords:, up_coords:, down_coords: }
    end

    def edge?(x:, y:, row_count:, col_count:)
      is_edge_row = x.zero? || x == row_count - 1
      is_edge_col = y.zero? || y == col_count - 1

      is_edge_row || is_edge_col
    end

    def part_one(input)
      row_count, col_count = input.size, input.first.size

      col_count.times.sum do |y|
        row_count.times.count do |x|
          next 1 if edge?(x:, y:, row_count:, col_count:)

          value = input[y][x].to_i

          traveling_paths(
            x:, y:, row_count:, col_count:
          ).any? do |direction, coords|
            coords.none? { |x2, y2| input[y2][x2].to_i >= value }
          end
        end
      end
    end

    def part_two(input)
      row_count, col_count = input.size, input.first.size
      best_score = -999

      col_count.times.each do |y|
        row_count.times.each do |x|
          next if edge?(x:, y:, row_count:, col_count:)

          value = input[y][x].to_i

          scenic_score = traveling_paths(
            x:, y:, row_count:, col_count:
          ).map do |direction, coords|
            sum = 0

            coords.each do |x2, y2|
              sum += 1
              break if input[y2][x2].to_i >= value
            end

            sum
          end.reduce(1, :*)

          best_score = [best_score, scenic_score].max
        end
      end

      best_score
    end
  end
end

module Day05
  class << self
    def get_stacks_and_moves(input)
      input
        .slice_when { _1.match?(/^ \d /) }
        .to_a => [
          [*raw_crates, raw_columns],
          [_, *raw_moves]
        ]

      column_indexes = raw_columns
        .chars
        .each_with_index
        .select { |c, i| c.match?(/\d/) }
        .map(&:last)

      stacks = column_indexes.map { |i|
        raw_crates.map { _1[i] || ' ' }.reject { _1 == ' ' }.reverse
      }

      moves = raw_moves.map { _1.scan(/\d+/).map(&:to_i) }

      [stacks, moves]
    end

    def part_one(input)
      stacks, moves = get_stacks_and_moves(input)

      moves.each_with_index do |(n, from_col, to_col), i|
        n.times do
          moved_item = stacks[from_col - 1].pop
          stacks[to_col - 1].push(moved_item)
        end
      end

      stacks.map(&:last).join
    end

    def part_two(input)
      stacks, moves = get_stacks_and_moves(input)

      moves.each_with_index do |(n, from_col, to_col), i|
        moved_item = stacks[from_col - 1].pop(n)
        stacks[to_col - 1].concat(moved_item)
      end

      stacks.map(&:last).join
    end
  end
end

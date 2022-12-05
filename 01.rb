module Day01
  class << self
    def part_one(input)
      input
        .slice_before(&:empty?)
        .map { |vs| vs.sum(&:to_i) }
        .max
    end

    def part_two(input)
      input
        .slice_before(&:empty?)
        .map { |vs| vs.sum(&:to_i) }
        .max(3)
        .sum
    end
  end
end

module Day03
  class << self
    LOWER_ALPHA_TO_INDEX = ('a'..'z').each.with_index(1).to_h
    LOWER_INDEX_TO_ALPHA = LOWER_ALPHA_TO_INDEX.invert

    UPPER_ALPHA_TO_INDEX = ('A'..'Z').each.with_index(27).to_h
    UPPER_INDEX_TO_ALPHA = UPPER_ALPHA_TO_INDEX.invert

    ALPHA_TO_INDEX = LOWER_ALPHA_TO_INDEX.merge(UPPER_ALPHA_TO_INDEX)
    INDEX_TO_ALPHA = LOWER_INDEX_TO_ALPHA.merge(UPPER_INDEX_TO_ALPHA)

    def part_one(input)
      input.sum do |line|
        half_size   = line.size / 2
        first_half  = line[0...half_size].chars
        second_half = line[half_size..-1].chars
        shared = first_half & second_half

        shared.map(&ALPHA_TO_INDEX).sum
      end
    end

    def part_two(input)
      input.each_slice(3).sum do |a, b, c|
        a_chars = a.chars
        b_chars = b.chars
        c_chars = c.chars

        shared = a_chars & b_chars & c_chars
        shared.map(&ALPHA_TO_INDEX).sum
      end
    end
  end
end

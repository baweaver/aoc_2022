module Day10
  class << self
    ON = '#'
    OFF = ' '
    FEED_SIZE = 40

    def relevant_cycle?(n)
      n % FEED_SIZE == 20
    end

    def part_one(input)
      cycle = 0
      x_register = 1
      signals = []

      up_cycle = -> v { cycle += 1 and v }
      register = -> v { x_register += v }

      measure_signal = proc { signals.push(x_register * cycle) if relevant_cycle?(cycle) }
      process = proc { x_register } >> up_cycle >> measure_signal

      input.each do |line|
        command, value = line.split.then { [_1, _2.to_i] }

        case command
        when 'noop' then 1.times(&process)
        when 'addx' then 2.times(&process).then { register[value] }
        end
      end

      signals.sum
    end

    def part_two(input)
      cycle = 0
      x_register = 1
      image = []

      up_cycle = -> v { cycle += 1 and v }
      register = -> v { x_register += v }

      in_range = -> v { (cycle % FEED_SIZE).then { ((_1 - 1)..(_1 + 1)) }.cover?(v) }
      push_image = -> v { image.push(in_range[v] ? ON : OFF) }

      print_pixel = proc { x_register } >> push_image >> up_cycle

      input.each do |line|
        command, value = line.split.then { [_1, _2.to_i] }

        case command
        when 'noop' then 1.times(&print_pixel)
        when 'addx' then 2.times(&print_pixel).then { register[value] }
        end
      end

      puts image.each_slice(FEED_SIZE).map(&:join).join("\n")
    end
  end
end

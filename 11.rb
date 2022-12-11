$DEBUG = true

module Day11
  class << self
    MONKEY_MATCH = / *Monkey (?<number>\d+):/
    ITEMS_MATCH = / *Starting items: (?<list>.*)/
    OPERATION_MATCH = / *Operation: (?<a>new) = (?<b>old) (?<operation>.) (?<target>\d+|old)/
    CONDITION_MATCH = / *Test: (?<operation>divisible) by (?<n>\d+)/
    IF_MATCH = / *If (?<boolean>true|false): throw to monkey (?<monkey_number>\d+)/

    class Monkey
      attr_reader :number, :items, :operation, :condition, :items_inspected

      Operation = Struct.new(:a, :b, :operation, :target, keyword_init: true) do
        def actual_target(current_worry) = self.target == 'old' ? current_worry : self.target
        def call(current_worry) = current_worry.public_send(self.operation, actual_target(current_worry))
      end

      Condition = Struct.new(:condition, :if_true, :if_false, keyword_init: true) do
        def result(current_worry) = current_worry % condition == 0
        def call(current_worry) = result(current_worry) ? self.if_true : self.if_false
      end

      def initialize(number:)
        @number = number
        @items = []

        @items_inspected = 0
      end

      def to_s
        "🐒 #{@number} [#{items.join(', ')}]\n" +
        "  operation: #{operation}\n" +
        "  action:    #{condition}\n" +
        "  inspected: #{items_inspected}"
      end

      def dump_items!
        current_items = @items.dup
        @items = []
        current_items
      end

      def worry_impact(current_worry) = @operation.call(current_worry)
      def target_monkey(current_worry) = @condition.call(current_worry)
      def catch_item(item) = @items.push(item)

      def update_inspection_count
        @items_inspected += @items.size
      end

      def set_starting_items(list_string)
        @items.concat(list_string.split(/, */).map(&:to_i))
      end

      def set_operation(data)
        captures = data
          .named_captures
          .transform_keys(&:to_sym)

        captures[:target] = captures[:target].to_i unless captures[:target] == 'old'

        @operation = Operation.new(captures)
      end

      def set_condition(data)
        @condition = Condition.new(condition: data[:n].to_i)
      end

      def set_condition_branch(data)
        if data[:boolean] == 'true'
          @condition.if_true = data[:monkey_number].to_i
        else
          @condition.if_false = data[:monkey_number].to_i
        end
      end
    end

    def get_monkeys(input)
      monkeys = []
      current_monkey = nil

      input.each do |line|
        case line
        when MONKEY_MATCH
          current_monkey = Monkey.new(number: Regexp.last_match[:number].to_i)
          monkeys[current_monkey.number] = current_monkey
        when ITEMS_MATCH
          current_monkey.set_starting_items(Regexp.last_match[:list])
        when OPERATION_MATCH
          current_monkey.set_operation(Regexp.last_match)
        when CONDITION_MATCH
          current_monkey.set_condition(Regexp.last_match)
        when IF_MATCH
          current_monkey.set_condition_branch(Regexp.last_match)
        end
      end

      monkeys
    end

    def part_one(input)
      monkeys = get_monkeys(input)

      20.times do |i|
        monkeys.each do |monkey|
          monkey.update_inspection_count
          items = monkey.dump_items!

          items.each do |item_worry_level|
            current_worry = monkey.worry_impact(item_worry_level)
            current_worry /= 3

            target_monkey = monkey.target_monkey(current_worry)
            monkeys[target_monkey].catch_item(current_worry)
          end
        end
      end

      monkeys.map(&:items_inspected).max(2).reduce(1, :*)
    end

    def part_two(input)
      monkeys = get_monkeys(input)

      common_multiplier = monkeys.map { _1.condition.condition }.reduce(1, :lcm)

      10_000.times do |i|
        monkeys.each do |monkey|
          monkey.update_inspection_count
          items = monkey.dump_items!

          items.each do |item_worry_level|
            current_worry = monkey.operation.call(item_worry_level)
            current_worry %= common_multiplier

            target_monkey = monkey.condition.call(current_worry)
            monkeys[target_monkey].catch_item(current_worry)
          end
        end
      end

      monkeys.map(&:items_inspected).max(2).reduce(1, :*)
    end
  end
end

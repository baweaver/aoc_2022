module Day07
  class << self
    TOTAL_AVAIL = 70_000_000
    TARGET_UNUSED = 30_000_000

    COMMAND = /^\$ /
    DIR = /^dir (?<name>.+)/
    FILE = /^(?<size>\d+) (?<name>.+)/

    def readable_number(n)
      n.digits.map(&:to_s).each_slice(3).map(&:join).join('_').reverse
    end

    FileItem = Struct.new(:name, :size, :parent, keyword_init: true) do
      def to_s
        relative_depth = (self.parent&.depth.to_i + 1) * 2
        indent = '-' * relative_depth

        "#{indent}FILE(#{self.name}, size: #{Day07.readable_number(self.size)})\n"
      end
    end

    DirectoryItem = Struct.new(:name, :contents, :parent, :depth, keyword_init: true) do
      include Enumerable

      def size
        self.contents.map(&:size).sum
      end

      def each(&fn)
        yield(self)

        self.contents.each { |v| v.is_a?(DirectoryItem) ? v.each(&fn) : yield(v) }
      end

      def to_s
        indent = '-' * (self.depth.to_i * 2)
        "#{indent}Dir(#{self.name})\n#{self.contents.map(&:to_s).join}"
      end

      def add_file(name, size)
        self.contents << FileItem.new(name:, size: size.to_i, parent: self)
      end

      def add_dir(name)
        self.contents << DirectoryItem.new(
          name:, contents: [], parent: self, depth: self.depth.to_i + 1
        )
      end

      def cd(name)
        self.contents.find { _1.name == name } || add_dir(name)
      end
    end

    def populate_directories(input)
      root = DirectoryItem.new(name: '/', contents: [])
      current_dir = root
      is_listing = true

      input.each do |line|
        if is_listing
          case line
          when DIR
            current_dir.add_dir(Regexp.last_match[:name])
          when FILE
            current_dir.add_file(Regexp.last_match[:name], Regexp.last_match[:size].to_i)
          else
            is_listing = false
          end

          next if is_listing
        end

        case line
        when /\$ cd (?<dir_name>.+)/
          dir_name = Regexp.last_match[:dir_name]

          current_dir =
            case dir_name
            when current_dir&.name then current_dir
            when '..' then current_dir.parent
            when '/' then root
            else current_dir.cd(dir_name)
            end
        when /\$ ls/
          is_listing = true
        else
          raise "WARN: #{line}"
        end
      end

      root
    end

    def part_one(input)
      root = populate_directories(input)
      root
        .grep(DirectoryItem)
        .map(&:size)
        .select { _1 <= 100_000 }
        .sum
        .then { "#{_1}, or readable: #{readable_number(_1)}" }
    end

    def part_two(input)
      root = populate_directories(input)

      # puts root

      unused_space = TOTAL_AVAIL - root.size
      needed_space = TARGET_UNUSED - unused_space

      pp(
        total_space: readable_number(TOTAL_AVAIL),
        target: readable_number(TARGET_UNUSED),
        unused_space: readable_number(unused_space),
        needed_space: readable_number(needed_space)
      )

      root
        .grep(DirectoryItem)
        .map(&:size)
        .select { _1 >= needed_space }
        .min
        .then { "#{_1}, or readable: #{readable_number(_1)}" }
    end
  end
end

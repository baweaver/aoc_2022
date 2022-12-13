require 'set'

module Day12
  STARTING = 'S'
  ENDING = 'E'

  HEIGHT_MAPPING = [*'a'..'z'].each.with_index(1).to_h.merge(
    STARTING => 0,
    ENDING => 26
  )

  class Node
    attr_reader :x, :y, :height, :value, :visited
    attr_accessor :distance

    def initialize(x:, y:, value:)
      @x = x
      @y = y

      @value = value
      @height = HEIGHT_MAPPING[value]

      @visited = false

      @starting_node = STARTING == value
      @ending_node = ENDING == value

      @distance = nil
    end

    def deconstruct_keys(keys = nil)
      { x:, y:, value:, height:, visited:, distance: }
    end

    def visit!
      @visited = true
    end

    def set_distance_from(other_node)
      @distance = [@distance, other_node.distance + 1].compact.min
    end


    def neighbor_coordinates
      [[x + 1, y], [x - 1, y], [x, y + 1], [x, y - 1],]
    end

    def start? = @starting_node
    def end? = @ending_node
    def climbable?(previous_node) = @height - previous_node.height <= 1
    def visited? = @visited
  end

  class Graph
    def initialize
      @nodes = {}
    end

    def shortest_path_to_end
      current_visit = Set.new

      nodes = @nodes.dup
      current_node = nodes.values.find(&:start?)

      until current_node.end?
        current_node.visit!

        current_node.neighbor_coordinates.filter_map(&nodes).each do |neighbor|
          next if neighbor.visited? || !neighbor.climbable?(current_node)

          neighbor.set_distance_from(current_node)
          current_visit.add(neighbor)
        end

        current_node = current_visit.min_by(&:distance)
        current_visit.delete(current_node)
      end

      current_node.distance
    end

    def add_node(x:, y:, value:)
      @nodes[[x, y]] = Node.new(x:, y:, value:)
    end

    def set_starting_distances(&fn)
      @nodes.values.select(&fn).each { _1.distance = 0 }
    end
  end

  class << self
    def get_graph(input)
      graph = Graph.new

      input.each_with_index do |line, y|
        line.chars.each_with_index do |char, x|
          graph.add_node(x:, y:, value: char)
        end
      end

      graph
    end

    def part_one(input)
      graph = get_graph(input)
      graph.set_starting_distances { _1 in { value: 'S' } }

      graph.shortest_path_to_end
    end

    def part_two(input)
      graph = get_graph(input)
      graph.set_starting_distances { _1 in { value: /[aS]/ } }

      graph.shortest_path_to_end
    end
  end
end

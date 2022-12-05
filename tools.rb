module Tools
  class << self
    def load_part(n)
      part_number = n.to_s.rjust(2, '0')
      File.readlines("inputs/#{part_number}.txt", chomp: true)
    end
  end
end

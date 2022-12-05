module Day02
  class << self
    WIN_SCORE = 6
    TIE_SCORE = 3
    LOSE_SCORE = 0

    LETTER_TO_RPS = {
      'A' => 'Rock',
      'B' => 'Paper',
      'C' => 'Scissors'
    }

    YOU_TO_RPS = {
      'X' => 'Rock',
      'Y' => 'Paper',
      'Z' => 'Scissors'
    }

    RESULT_TO_SCORE = {
      'X' => LOSE_SCORE,
      'Y' => TIE_SCORE,
      'Z' => WIN_SCORE
    }

    WINS_AGAINST = {
      'Rock' => 'Scissors',
      'Scissors' => 'Paper',
      'Paper' => 'Rock'
    }

    LOSES_TO = WINS_AGAINST.invert

    RPS_TO_SCORE = {
      'Rock' => 1,
      'Paper' => 2,
      'Scissors' => 3
    }

    def to_rps(v)
      LETTER_TO_RPS[v] || YOU_TO_RPS[v]
    end

    def score_rps(a, b)
      return TIE_SCORE if a == b

      WINS_AGAINST[a] == b ? WIN_SCORE : LOSE_SCORE
    end

    def score_to_rps(opponent, result)
      case result
      when 'X' then WINS_AGAINST[opponent]
      when 'Z' then LOSES_TO[opponent]
      else opponent
      end
    end

    def part_one(input)
      input.map do |line|
        line
          .split
          .map { to_rps(_1) }
          .then { score_rps(_1, _2) + RPS_TO_SCORE[_2] }
      end.sum
    end

    def part_two(input)
      input.map do |line|
        opponent, result, you =
          line
            .split
            .then { [to_rps(_1), _2, result_to_rps(_1, _2)] }

        RPS_TO_SCORE[you] + RESULT_TO_SCORE[result]
      end.sum
    end
  end
end

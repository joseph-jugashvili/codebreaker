require_relative 'validation/errors'
require_relative 'validation/validatable'

module Codebreaker
  class Game
    include Validatable

    attr_reader :secret_code, :difficulty, :attempts, :hints, :name

    RANGE_SECRET_CODE = (1..6).to_a.freeze
    LENGTH_SECRET_CODE = 4

    DIFFICULTIES = {
      easy: { attempts: 15, hints: 2 },
      medium: { attempts: 10, hints: 1 },
      hell: { attempts: 5, hints: 1 }
    }.freeze

    def initialize
      @secret_code = ''
      @name = ''
      @attempts = 0
      @hints = 0
      @difficulty = 0
    end

    def start
      @secret_code = RANGE_SECRET_CODE.sample(LENGTH_SECRET_CODE).join
      @available_hints = @secret_code.dup
    end

    def generate_matrix(inputted_guess)
      validate_guess!(inputted_guess)
      @attempts += 1
      matrix(inputted_guess)
    end

    def use_hint
      return if @available_hints.empty?

      hint = @available_hints.chars.sample
      @available_hints.sub!(hint, '')
      @hints += 1
      hint
    end

    def difficulty=(difficulty)
      @difficulty = DIFFICULTIES.keys.index(difficulty)
    end

    def name=(name)
      validate_name!(name)
      @name = name
    end

    def present_hints?
      @hints < DIFFICULTIES.values[difficulty][:hints]
    end

    def present_attempts?
      @attempts < DIFFICULTIES.values[difficulty][:attempts]
    end

    def available_difficulties
      DIFFICULTIES
    end

    private

    def matrix(inputted_guess)
      check_for_inclusion_in_matrix(*check_position_in_matrix(inputted_guess.split('')))
    end

    def check_position_in_matrix(inputted_guess)
      copy_of_the_code = @secret_code.split('')
      matrix = ''
      inputted_guess.each_index do |index|
        next unless copy_of_the_code[index] == inputted_guess[index]

        copy_of_the_code[index] = false
        inputted_guess[index] = nil
        matrix << '+'
      end
      [matrix, copy_of_the_code, inputted_guess]
    end

    def check_for_inclusion_in_matrix(matrix, copy_of_the_code, inputted_guess)
      inputted_guess.each_index do |index|
        copy_of_the_code.each_index do |i|
          next unless inputted_guess[index] == copy_of_the_code[i]

          copy_of_the_code.delete_at(i)
          inputted_guess[index] = nil
          matrix << '-'
        end
      end
      matrix
    end
  end
end

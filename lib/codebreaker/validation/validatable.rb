# frozen_string_literal: true

module Validatable
  include Errors

  def validate_name!(name)
    raise LengthError unless (3..20).cover?(name.length)
  end

  def validate_guess!(guess)
    raise InputError unless /^[1-6]{4}$/.match?(guess)
  end
end

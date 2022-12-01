# frozen_string_literal: true

# Part 1: …}.max
puts File.foreach('input.txt', '').map { _1.lines.sum(&:to_i) }.max(3).sum

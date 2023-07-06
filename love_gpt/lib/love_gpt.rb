# frozen_string_literal: true

require_relative "love_gpt/version"

module LoveGpt
  class Error < StandardError; end
  # Your code goes here...

  # require 'love_gpt'
  # string = 'A hates B, A loves D while B loves C and D hates A but C loves A'
  # LoveGpt::Parser.new(string).parse
  class Parser
    attr_reader :input, :output
    private :input, :output

    DELIMITER_0 = ','.freeze
    DELIMITER_1 = 'and'.freeze
    DELIMITER_2 = 'but'.freeze
    DELIMITER_3 = 'while'.freeze
    
    ACTION_1 = 'loves'.freeze
    ACTION_2 = 'hates'.freeze

    def initialize(input)
      @input = input
      @output = {}
    end

    def parse
      rez = input.split(DELIMITER_0)
      rez = split_by_delimiter(rez, DELIMITER_1)
      rez = split_by_delimiter(rez, DELIMITER_2)
      rez = split_by_delimiter(rez, DELIMITER_3)

      rez.each do |phrase|
        split_by_action(phrase, ACTION_1) if phrase.include?(ACTION_1)
        split_by_action(phrase, ACTION_2) if phrase.include?(ACTION_2)
      end

      output
    end

    private

    def split_by_delimiter(rez, delimiter)
      rez.map { _1.split(delimiter) }.flatten.map(&:strip)
    end
    
    def split_by_action(string, action)
      pair = string.split(action).map(&:strip)

      root_value = output[pair.first]
      root_value = {} if root_value.nil?

      child_value = root_value[action]
      child_value = [] if child_value.nil?

      root_value[action] = child_value << pair.last

      output.merge!(pair.first => root_value)
    end
  end
end

#!/bin/env ruby

require "./mars"
require "test/unit"

# mars testcase
class TestMars < Test::Unit::TestCase
  def test_rover_creation
    assert_equal([1, 2, "N"], Rover.new(1, 2, 'N').position)
    assert_equal([3, 4, "E"], Rover.new(3, 4, 'E').position)
    assert_equal([5, 6, "S"], Rover.new(5, 6, 'S').position)
    assert_equal([7, 8, "W"], Rover.new(7, 8, 'W').position)
  end

  def test_rover_navigation_LR
    Rover::DIRECTIONS.each do |d|
      rover = Rover.new(0, 0, d)
      initial = rover.position

      rover.next('L')
      rover.next('R')
      assert_equal(initial, rover.position)
    end
  end

  def test_rover_navigation_M
    Rover::DIRECTIONS.each do |d|
      rover = Rover.new(3, 3, d)
      initial = rover.position

      4.times do
        rover.next('M') 
        rover.next('L')
      end
      
      assert_equal(initial, rover.position)

      4.times do
        rover.next('M') 
        rover.next('R')
      end

      assert_equal(initial, rover.position)
    end
  end
end

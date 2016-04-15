#!/bin/env ruby

# rover
class Rover
  DIRECTIONS = ['N','E','S','W']

  def initialize(x, y, d, xmax, ymax)
    @x = x.to_i
    @y = y.to_i
    @d = DIRECTIONS.index(d)
    @xmax = xmax
    @ymax = ymax
  end

  def next(p)
    case p
    when 'L'
      @d = (4 + @d - 1) % 4
    when 'R'
      @d = (@d + 1) % 4
    when 'M'
      case @d
      when 0
        @y += 1
        raise "Y Out of boundary" unless @y <= @ymax
      when 1
        @x += 1
        raise "X Out of boundary" unless @x <= @xmax
      when 2
        @y -= 1
        raise "Y Out of boundary" unless @y >= 0
      when 3
        @x -= 1
        raise "X Out of boundary" unless @x >= 0
      end
    end
  end

  def position
    [@x, @y, DIRECTIONS[@d]]
  end
end


# mars program
def mars
  xmax, ymax = gets.chomp.split

  while rover = gets
    x, y, d = rover.chomp.split
    path = gets.chomp

    rover = Rover.new(x,y,d,xmax.to_i,ymax.to_i) 
    path.each_char do |c| 
      rover.next(c) 
    end

    p = rover.position
    puts "#{p[0]} #{p[1]} #{p[2]}" 
  end
end


if __FILE__ == $0
  mars()
end



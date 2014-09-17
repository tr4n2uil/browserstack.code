#!/bin/env ruby

# rover
class Rover
  DIRECTIONS = ['N','E','S','W']

  def initialize(x, y, d)
    @x = x.to_i
    @y = y.to_i
    @d = DIRECTIONS.index(d)
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
      when 1
        @x += 1
      when 2
        @y -= 1
      when 3
        @x -= 1
      end
    end
  end

  def position
    [@x, @y, DIRECTIONS[@d]]
  end
end


# mars program
def mars
  x_max, y_max = gets.chomp.split

  while rover = gets
    x, y, d = rover.chomp.split
    path = gets.chomp

    rover = Rover.new(x,y,d) 
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



class World
  attr_accessor :height, :width, :cells, :next_cells

  ALIVE = "\u2588"
  DEAD = "\u2591"
  TICK_TIME = 0.09

  def initialize
    @height = 50
    @width = 90
    @cells = Array.new(@height) { Array.new(@width, DEAD) }
    @next_cells = Array.new(@height) { Array.new(@width, DEAD) }
  end

  def populate!
    @cells.each_with_index do |y,yi|
      y.each_with_index do |x,xi|
        random = rand(-9..1)
        @cells[yi][xi] = random >= 0 ? ALIVE : DEAD
      end
    end
  end

  def live!
    sleep TICK_TIME
    @next_cells = Array.new(@height) { Array.new(@width, DEAD) }
    @cells.each_with_index do |y,yi|
      y.each_with_index do |x,xi|
        apply_world_rules!(xi, yi)
      end
    end
    display
    @cells = @next_cells
  end

  # Aplica leyes standard de Conway
  def apply_world_rules!(x, y)
    alive = alive?(x,y)
    neighbors = alive_neighbors(x,y)
    if alive && [2,3].include?(neighbors)
      @next_cells[y][x] = ALIVE
    elsif !alive && neighbors == 3
      @next_cells[y][x] = ALIVE
    else
      @next_cells[y][x] = DEAD
    end
  end

  def alive_neighbors(x,y)
    c = @cells
    neighbors = []
    neighbors << c[y][x+1] if x + 1 < @width
    neighbors << c[y][x-1] if x - 1 >= 0
    neighbors << c[y+1][x] if y + 1 < @height
    neighbors << c[y+1][x+1] if (y + 1) < @height && (x + 1) < @width
    neighbors << c[y+1][x-1] if (y + 1) < @height && (x - 1) >= 0
    neighbors << c[y-1][x] if y - 1 >= 0
    neighbors << c[y-1][x+1] if (y - 1) >= 0 && (x + 1) < @width
    neighbors << c[y-1][x-1] if (y - 1) >= 0 && (x - 1) >= 0

    neighbors.count { |n| n == ALIVE }
  end

  def alive?(x,y)
    @cells[y][x] == ALIVE
  end

  def display
    puts `clear` 
    puts @next_cells.map { |x| x.join(" ") }
  end

end

# EXEC
world = World.new
world.populate!
world.display

while true
  world.live!
end

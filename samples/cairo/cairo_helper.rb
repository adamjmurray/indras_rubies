require 'rubygems'
require 'cairo'
$: << File.dirname(__FILE__) + '/../../lib'
require 'indras_rubies'

@scale = 1
@stroke_weight = 2

# Initialize a new drawing context with the given width and heigth.
# Call this first.
def size(width,height)
  @surface = Cairo::ImageSurface.new(width,height)
  @canvas = Cairo::Context.new(@surface)
  background(1,1,1,1)
  no_stroke
  fill_color(0,0,0,1)
end  

# Set the background color.
def background(r,g,b,a)
  #@canvas.set_source_color(color)
  @canvas.set_source_rgba(r,g,b,a)
  @canvas.paint
end

# translate by the specified amount
def translate(x,y)
  @canvas.translate(x,y)
end

# scale by the specified amount
def scale(scaling_factor)
  @scale = scaling_factor
  @canvas.scale(scaling_factor,scaling_factor)
  stroke_weight(@stroke_weight)
end

def stroke_weight(weight)
  @stroke_weight = weight
  @canvas.set_line_width(weight.to_f/@scale)
end

# Set the stroke color
def stroke_color(r,g,b,a)
  @stroke_color = [r,g,b,a]
  @canvas.set_source_rgba(r,g,b,a)
end

def no_stroke
  @stroke_color = nil
end

def fill_color(r,g,b,a)
  @fill_color = [r,g,b,a]
end

def no_fill
  @fill_color = nil
end

def stroke_and_fill_shape
  if @fill_color
    @canvas.set_source_rgba *@fill_color
    yield
    @canvas.fill
  end
  if @stroke_color
    @canvas.set_source_rgba *@stroke_color
    yield
    @canvas.stroke
  end
end

# Draw a circle
def circle(x,y,radius)
  stroke_and_fill_shape{ @canvas.arc(x, y, radius, -Math::PI, Math::PI) }  
end

def draw(*shape)
  shape = shape[0] if shape.length==1
  case shape
  when Indra::Circle
    circle(shape.x, shape.y, shape.radius)
  when Array
    shape.each{|s| draw s }
  else
    raise ArgumentError
  end
end

# Save the current drawing context as a png file
def write_png(file)
  @canvas.target.write_to_png(file)
end
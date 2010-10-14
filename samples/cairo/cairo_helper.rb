require 'rubygems'
require 'cairo'
$: << File.dirname(__FILE__) + '/../../lib'
require 'indras_rubies'

# Initialize a new drawing context with the given width and heigth.
# Call this first.
def size(width,height)
  @surface = Cairo::ImageSurface.new(width,height)
  @canvas = Cairo::Context.new(@surface)
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
  @canvas.scale(scaling_factor,scaling_factor)
  @canvas.set_line_width(1.0/scaling_factor)
end

# Set the stroke color
def stroke(r,g,b,a)
  @canvas.set_source_rgba(r,g,b,a)
end

# Draw a circle
def circle(x,y,radius)
  @canvas.arc(x, y, radius, -Math::PI, Math::PI)
  @canvas.stroke
end

# Save the current drawing context as a png file
def write_png(file)
  @canvas.target.write_to_png(file)
end
# Example of repeatedly applying a MobiusTransformation to a circle

require_relative 'cairo_helper'
include Indra

size 500,500
translate 170,100
stroke 0,0,0,0.2 # semi-transparent black

c = Circle.new( Point(-490,-360), 200 )
t = MobiusTransformation.new( 1.18+0.125*I, 5+3*I, 0, 1.199 )

600.times do
  draw c
  c = t[c]
end

write_png File.basename(__FILE__,'.rb')+'.png'
  
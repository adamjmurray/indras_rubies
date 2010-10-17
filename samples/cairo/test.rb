# As a test run I ported the code from http://www.photo-mark.com/notes/2008/dec/20/weekend-nerd-diversions/

require_relative 'cairo_helper'
include Indra

WIDTH = 800
HEIGHT = 500
size WIDTH,HEIGHT
background 1,1,1,1 # white
translate WIDTH/2, HEIGHT/2
scale 95

no_fill
stroke_weight 1
stroke_color 0,0,0,0.1 # semi-transparent black

a,b,c,d = 1-5*I, 0.04, 0.39, 0.99-5*I
center = Point(1.16,0.91)
c1 = Circle.new(center,1)
t1 = MobiusTransformation.new(a,b,c,d)
c2 = Circle.new(-center, 1)
t2 = MobiusTransformation.new(a,-b,-c,d)

600.times do
  draw c1, c2
  c1 = t1[c1]
  c2 = t2[c2]
end

write_png File.basename(__FILE__,'.rb')+'.png'

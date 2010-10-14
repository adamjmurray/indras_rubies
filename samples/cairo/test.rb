$: << File.dirname(__FILE__)
require 'cairo_helper'

# As a test run I ported the code from http://www.photo-mark.com/notes/2008/dec/20/weekend-nerd-diversions/

WIDTH = 800
HEIGHT = 500

size WIDTH,HEIGHT
background 1,1,1,1 # white

translate WIDTH/2, HEIGHT/2
scale 95

stroke 0,0,0,0.2 # mostly transparent black

a,b,c,d = Complex(1,-5), 0.04, 0.39, Complex(0.99,-5)
center = Complex(1.16,0.91)

c1 = Indra::Circle.new(center,1)
t1 = Indra::MobiusTransformation.new(a,b,c,d)

c2 = Indra::Circle.new(-center, 1)
t2 = Indra::MobiusTransformation.new(a,-b,-c,d)

600.times do
  circle(c1.center.real, c1.center.imag, c1.radius)
  circle(c2.center.real, c2.center.imag, c2.radius)
  c1 = t1.transform_circle(c1)
  c2 = t2.transform_circle(c2)
end

write_png 'test.png'

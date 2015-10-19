repr(self)
l1 = Layer('metal1')
b1 = Box(0,0, 1,0.2)
repr(l1); repr(b1)
r1 = Rect(l1, b1)
# help(Rect); help(Shape)
r2 = r1.clone()
# moved up by w + 0.18
r2.fgPlace(Direction.NORTH, r1)
r3 = r1.clone()
r2.fgPlace(Direction.EAST, r1)
group1 = self.makeGrouping(); # ??

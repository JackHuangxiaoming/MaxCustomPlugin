rcmenu RCmenuRenderable
(
   fn onlyOneSelected = selection.count == 1 -- define filter function
	   
   menuItem mi_r "Renderable" filter: onlyOneSelected -- display if only 1 object selected
   separator sep1 filter:onlyOneSelected
   menuItem mi_ "Renderable________"
   
   on RCmenuRenderable open do -- perform following on rcmenu open
   (
	   if selection.count == 1 then -- if only one object selected...
	   (
		   mi_r.text = $.name + " | " + "Renderable" -- change text of menu item
		   if isKindOf $ Shape then -- if shape set renderable property to
		   $.renderable=$.renderable -- itself to get shape and node renderable
		   -- properties the same
		   mi_r.checked=$.renderable -- turn on menu item check if renderable
		)
	)
	on mi_r picked do$.renderable = not $.renderable -- when menu item picked, flip renderable value
)
registerRightClickMenu RcmenuRenderable -- register the rcmenu
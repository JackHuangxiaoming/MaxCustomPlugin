utility MyUtil "My Utility"
(
   local pot
   rollout bout "About My Utility"
   (
	   button aboutMU "About" width:45 height:20
	   on aboutMU pressed do
	   messagebox "My First Utility\nby ME\nVersion .1"\
	   title:"About My Utility"	   
   ) -- end rollout bout
   rollout creator "The Teapot"
   (
	   group "Object Creator"
	   (
		   button tea "Teapot"
		   spinner rad "Radius" range:[10,50,20] type:#integer
		   spinner seg "Segments" range:[4,32,12] type:#integer scale:1
		)	
	   on tea pressed do
	   (
			pot=teapot radius:rad.value
			pot.name="TestPot"
			pot.segs=seg.value
	   ) -- end on tea pressed
		on rad changed value do
			pot.radius=value
		on seg changed value do
			pot.segs=seg.value
	) -- end rollout creator
   on MyUtil open do
   (
	   addRollout bout
	   addRollout creator
   ) -- end on MyUtil open
   on MyUtil close do
   (
	   removeRollout bout
	   removeRollout creator
   ) -- end on MyUtil close
) -- end utility MyUtil
 rollout a "Rollout A"
   (
   button a1 "a1"
   on a resized val do (format "A: %\n" val)
   )
   --
   rollout b "Rollout B"
   (
   button b1 "b1"
   on b resized val do (format "B: %\n" val)
   )
   --
	rollout grin "Grin Control"
   (
   slider happy "Happy" orient:#vertical across:5
   slider sad "Sad" orient:#vertical
   slider oo "OO" orient:#vertical
   slider ee "EE" orient:#vertical
   slider oh "OH" orient:#vertical
   /*
   on happy changed val do object.xform1.center = ...
   on sad changed val do object.xform2.gizmo.rotation = ...
   ...
   */
   )
   --
	rof = newRolloutFloater "TestNewRollout" 500 500
	addrollout a rof
	addrollout b rof
   addrollout grin rof
	rof.size=[300,300]
	--rof.title = "!!!!!!!!!!!!!!!!"
   rof.rollouts  
   cui.RegisterDialogBar rof
   cui.DockDialogBar rof #cui_dock_bottom
   
--CreateDialog resNormPlugin
--cui.RegisterDialogBar resNormPlugin
--cui.DockDialogBar resNormPlugin #cui_dock_bottom
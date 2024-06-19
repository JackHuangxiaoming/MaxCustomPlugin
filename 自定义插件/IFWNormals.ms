--Improved Face Weighted Normals - iiidea.cn
--By iiidea.cn
--arturo@cattomic.com
--V1.0, 12/2017


global threshold = 0.1 --default angle tolerance
global thspinner -- threshold spinner value
global opcoplanarweight = true --coplanarweight checkbox value
global splitbysg = true

fn anglebetweenvectors v1 v2 = 
(
 return (acos (dot v1 v2) )
)

--get coplanar faces to face (continuity sensitive)
fn getcoface obj face =
	(
		if (opcoplanarweight==false) then return #{face}
		local mysurface = #{}
		local facenormal = polyop.getfacenormal obj face
		local sg = polyop.getfacesmoothgroup obj face
		append mysurface face
		
		do
		(
			local a = polyop.getedgesusingface obj mysurface
			local b = polyop.getfacesusingedge obj a
			local c = b-mysurface
			for i in c do
			(
				if((anglebetweenvectors (polyop.getfacenormal obj i) facenormal)>threshold) then 
				(
					deleteitem c i
				)
				else (
					if splitbysg do
					(
						sgint = bit.and (polyop.getfacesmoothgroup obj i)  sg
						if (sgint==0) do
						(
							deleteitem c i
						)
					)
				)
			)
			mysurface+=c
		) while c.isempty==false
		return mysurface
	)
	
	--get total area
	fn getarea obj faces =
	(
		local tarea = 0
		for i in faces do
		(
			tarea += polyop.getfacearea obj i
		)
		return tarea
	)
	
	--main 
	fn fwnormals obj cmdprogress =
	(
	local mf
		select obj
		max modify mode
		if (superclassof obj) != geometryclass do return false
			try (
				polyop.getnumfaces obj
				polyop.getfacenormal obj 1
			)
			catch
			(
				addmodifier obj (edit_poly())
			)
			
			local faceweight = #()
			faceweight.count = obj.numfaces
			local progress = 0
			undo off
			(
				for face=1 to obj.numfaces do
				(
					--update progress bar
					progress = ((face *100)/obj.numfaces)
					cmdprogress.value = progress
					if (keyboard.escpressed) do ( return false ) --help to break loop if heacy processing
					faceweight[face] = getarea obj (getcoface obj face)
				)
			)
			mf = obj.modifiers[1]
			if (mf==undefined or mf.name != "FW Normals") then
			(
				mf = edit_normals()
				mf.name = "FW Normals"
				addmodifier obj mf
			)
			undo off 
			(				
				 -- get number of normals

				local normnum = mf.getnumnormals()
				 
				 local normals = #()
				 normals.count = normnum
				 for i=1 to normnum do
				 (
				  normals[i] = [0,0,0]
				 )
				 
				 -- loop faces
				 for i=1 to obj.numfaces do
				 (
					  -- get face normal
					  in coordsys local n = polyop.getfacenormal obj i
					  --get normal count for this poly = vertex count
					  nvertex = polyop.getvertsusingface obj i
					
					  -- set normals  
					  for j=1 to nvertex.count do
					  (
						   local id = mf.getnormalid i j
						   if id==0 then exit
						   normals[id] = normals[id] + ( n * faceweight[i])
					  )
				 )
				 
				 
					--normalize and make explicit
				 for i=1 to normnum do
				 (
				   mf.setnormalexplicit i explicit:true
				   mf.setnormal i (normalize normals[i])
				 )
				 
				subobjectlevel = 0 --exit modifier
			)
	)
	
	--ui	
	rollout cmdoptions "Options"
	(
		checkbox cmdcoplanar "Coplanar weight" checked:true
		spinner cmdthreshold "Threshold" range:[0,90,threshold]
		on cmdcoplanar changed cbvalue do 
		(	cmdthreshold.enabled = cbvalue			
			opcoplanarweight=cbvalue
		)
		on cmdthreshold changed spvalue do
		(
			threshold = spvalue
		)
	)
	rollout cmdmain "IFW Normals"
	(
		button cmdgenerate "Generate" width:160
		
		progressbar cmdprogress color:blue width:160 height:8
		label status "" 
		on cmdgenerate pressed do
		(
		-- copy selection
		  local sel = #()
		  for i=1 to selection.count do
		  (
			sel[i] = selection[i]
		  )
		  
		  -- init success / error counters
		  local doneok = 0
		  local doneerror = 0
		  
		  --evaluate each node
		  for i=1 to sel.count do
			(
			try (
				status.text = ("Building weightmap for " + sel[i].name) -- update status
				
				--main process
				fwnormals sel[i] cmdprogress 
				--if success
				doneok+=1
				) 
			catch (
				--else
				doneerror+=1
				)
			cmdprogress.value = 0 --reset progressbar
			)
		  --show result
		  status.text = (doneok as string +" Done, "+ doneerror as string + " Failed")
		  -- restore selection
		  select sel
		)
	)
	
global IFWNormals_Run = (
	fn Run =(
		try
		(
			closerolloutfloater fwnfloater --close if exist
		)
		catch()	
		fwnfloater = newrolloutfloater "IFWN" 200 162
		addrollout cmdmain fwnfloater
		addrollout cmdoptions fwnfloater		
	)
)
	

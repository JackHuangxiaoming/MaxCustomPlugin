   utility ResCheckUtility "自动创建Box" -- define the utility name and description string
   (
	   local last_amt = 0 -- define and initialize local variable
	   button 'BoxBtn' "Box" width:150 height:43 toolTip:"点击选择资源配置文件" align:#left
	   
	   on BoxBtn pressed do
		(
			mybox = box length:20 width:30 height:40							
			select mybox
			mybox.wirecolor = (color 255 0 255)
			mybox.height = 15
		)	
   ) -- end of utility definition
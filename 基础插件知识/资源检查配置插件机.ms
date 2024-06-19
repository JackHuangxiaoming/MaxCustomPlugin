try(DestroyDialog resCheck001) catch()
rollout resCheck001 "配置器" width:400 height:630
(
	button 'Config' "配置文件" pos:[61,11] width:300 height:43 toolTip:"点击选择资源配置文件" align:#left
	on Config pressed do
	(
		mybox = $Box001		
		if mybox == undefined then
		(
			mybox = box length:20 width:30 height:40		
			mybox.name = "Box001"
		)
		select mybox
		mybox.wirecolor = (color 255 0 255)
		mybox.height = 15
	)	
	button 'Close' "关闭窗口" pos:[61,64] width:300 height:43 toolTip:"点击关闭资源配置窗口" align:#left
	on Close pressed do	
		DestroyDialog resCheck
)
--CreateDialog resCheck001
newRolloutFloater resCheck001
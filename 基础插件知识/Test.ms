fn TestResTrans = (
	local tempObj = $
	if	tempObj == undefined do
	(
		messageBox "重置对象需要选中一个对象" title:"规范检查脚本" 
		return	false
	)	
	CenterObject tempObj
	tempObj.pos =[0,0,0]				
	tempObj.scale =[1,1,1]
	tempObj.rotation =EulerAngles 0 0 0
	bounds = nodeLocalBoundingBox tempObj
	tempObj.pivot = [0,0,(bounds[1].z)]	
	tempObj.pos =[0,0,0]
	max modify mode	
)

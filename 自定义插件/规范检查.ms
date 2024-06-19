include "IFWNormals.ms" --法线锁定

-- 引入DotNet的正则表达式库
dotNet.loadAssembly "System"
dotNet.loadAssembly "System.Text.RegularExpressions"


---------------------------------------------------逻辑----------------------------------------------------------

--检查Pos,Scale,Rotate,Axis
global norm_Transform =(
	fn norm_Transform_local = (
		allObjects = objects as Array	
		local normPos = [0,0,0]
		local normScale = [1.0,1.0,1.0]
		local normRot = Quat 0.707107 0 0 0.707107
		local errorObj = undefined
		local errorMsg = undefined
		for obj in allObjects do(	
			errorObj = obj		
			if obj.pos != normPos do
			(
				errorMsg = ("检查到对象坐标信息异常："+ (obj.pos as string))
				exit
			)
			if obj.scale != normScale do
			(			
				print obj.scale
				errorMsg = ("检查到对象缩放信息异常："+ (obj.scale as string))
				exit
			)		
			if obj.rotation != normRot do
			(			
				print obj.rotation
				errorMsg = ("检查到对象旋转信息异常："+ ((obj.rotation as EulerAngles) as string))
				exit
			)	
			errorObj = undefined		
		)
		if errorObj != undefined do
		(
			select errorObj
			messageBox errorMsg title:"规范检查脚本" 
			return false
		)
		print "检查通过：Transform"
		return true
	)
)

--检查文件名字材质球名字
global norm_ResName =(
	fn norm_ResName_local = (
		local errorMsg = undefined
		local currentMaterial = undefined
		local errorObj = undefined
		allObjects = objects as Array	
		-- 定义正则表达式模式
		patternObj = @"^(Sm_|SM_).+(_LOD\d*|_collider)$"
		patternMat = @"^(Mat_).+(_LOD\d*|\d+)$"
		for obj in allObjects do(					
			if isKindOf obj Dummy do
				continue		
			errorObj = obj
			if not (dotNetClass "System.Text.RegularExpressions.Regex").isMatch obj.name patternObj do
			(
				errorMsg = ("检查到对象命名异常："+ obj.name)
				exit
			)	
			currentMaterial = obj.material
			if currentMaterial == undefined do
			(
				errorMsg = ("检查到对象没有材质球："+ obj.name)
				exit
			)
			if (getNumsubMtls currentMaterial) > 0 then 
			(
				local isItemError = undefined
				for item in currentMaterial do
				(
					if not (dotNetClass "System.Text.RegularExpressions.Regex").isMatch item.name patternMat do
					(	
						errorMsg = ("检查到对象材质球命名异常："+ item.name)
						isItemError = true
						exit
					)
				)
				if isItemError != undefined do
					exit
			)
			else if not (dotNetClass "System.Text.RegularExpressions.Regex").isMatch currentMaterial.name patternMat do
			(
				errorMsg = ("检查到对象材质球命名异常："+ currentMaterial.name)
				exit
			)		
			
			errorObj = undefined		
		)
		if errorObj != undefined do
		(
			select errorObj
			messageBox errorMsg title:"规范检查脚本" 
			return false
		)	
		print "检查通过：文件名字和材质球名字"
		return true
	)		
)

--检查文件平滑组检查
global norm_Smoothness =(
	fn norm_Smoothness_local = (
		allObjects = objects as Array		
		local errorObj = undefined
		local errorMsg = undefined
		local faceIndex = 0
		for obj in allObjects do(	
			if isKindOf obj Dummy do
				continue	
			if not isKindOf obj Editable_Poly do
				continue
			errorObj = obj				
			
			-- 获取对象面的数量
			faceCount = polyOp.getNumFaces obj
			allFacesHaveSmoothGroups = true
			-- 遍历所有的面
			for i = 1 to faceCount do
			(
				-- 获取面的平滑组
				smoothGroup = polyOp.getFaceSmoothGroup obj i
				
				-- 检查是否有平滑组
				if smoothGroup == 0 then
				(
					errorMsg = ("检查到对象平滑组异常："+ obj.name)			
					allFacesHaveSmoothGroups = false	
					faceIndex = i
					exit
				)
			)	
			if not allFacesHaveSmoothGroups do
				exit
			
			errorObj = undefined		
		)
		if errorObj != undefined do
		(	
			select errorObj		
			setCommandPanelTaskMode #modify
			subObjectLevel = 4
			polyop.setFaceSelection errorObj faceIndex			
			messageBox errorMsg title:"规范检查脚本" 
			return false
		)
		print "检查通过：平滑组检查"
		return true	
	)	
)

--检查文件法线检查
global norm_Normal =(
	fn norm_Normal_local = (
		IFWNormals_Run()	
	)	
)

--检查场景单位
global norm_Units =(
	fn norm_Units_local = (
		
		local errorMsg = undefined
		if units.DisplayType != #metric do
			errorMsg = "当前编辑器单位设置异常 请设置为 Metric （公制） "
		if units.MetricType != #meters do
			errorMsg = "当前编辑器单位设置异常 请设置为 Metrics （米） "
		if units.SystemType != #centimeters do
			errorMsg = "当前编辑器系统单位异常 请设置为 Centimeters （厘米） "
		if units.SystemScale != 1.0 do
			errorMsg = "当前编辑器系统单位数值异常 请设置为 1.0 "		
		if errorMsg != undefined do
		(	
			messageBox errorMsg title:"规范检查脚本" 
			return false	
		)		
		print "检查通过：单位"
		return true
	)	
)	

--点线面孤立检查
global norm_Isolate = (	
	fn norm_Isolate_local = (
		allObjects = objects as Array	
		for obj in allObjects do(	
			if isKindOf obj Dummy do
				continue	
			if not isKindOf obj Editable_Poly do
				continue		
			-- 检查孤立顶点 线 面		
			vertexCount = polyop.GetHasDeadStructs obj
			if vertexCount > 0 do
			(
				select errorObj
				messageBox "检查到被选中模型有孤立点/线/面 请选择线框模式查看" title:"规范检查脚本" 
				return false	
			)		
		)
		print "检查通过：点线面"
		return true	
	)
)

--多边面检查
global norm_PolyToolsSelect = (	
	fn norm_PolyToolsSelect_local = (
		local errorObj = undefined	
		allObjects = objects as Array	
		for obj in allObjects do(				
			if isKindOf obj Dummy do
				continue	
			if not isKindOf obj Editable_Poly do
				continue
			select obj
			max modify mode --switch to modify panel			
			subObjectLevel = 4 --switch to Face level						
			if not (PolyToolsSelect.NumericFace  4 3 false) do
				continue										
			errorObj = obj
			faceCount =(PolyOp.GetFaceSelection obj).numberset			
			if faceCount > 0 do			
				exit			
			errorObj = undefined			
		)
		if errorObj != undefined do
		(	
			messageBox "当前被选中对象存在大于4边的多边面" title:"规范检查脚本" 
			return false
		)
		
		print "检查通过：多边面"
		return true	
	)
)

--全部检查
global norm_All =(
	fn norm_All = (
		state = norm_Units()
		if not state do
			return false
		state = norm_ResName()	
		if not state do
			return false	
		state = norm_Transform()
		if not state do
			return false
		state = norm_Smoothness()
		if not state do
			return false
		state = norm_Isolate()
		if state do
			messageBox "全部检查通过 请使用法线检查工具" title:"规范检查脚本" 		
		norm_Normal()	
	)
)

--重置对象 pos scale rotation axis
global resetTransformAndAxis =(	
	fn resetTransformAndAxis_local = (
		local tempObj = $
		if	tempObj == undefined do
		(
			messageBox "重置对象需要选中一个对象" title:"规范检查脚本" 
			return	false
		)
		if isKindOf tempObj ObjectSet do
			tempObj = tempObj[1]
		select tempObj
		CenterObject tempObj
		tempObj.pos =[0,0,0]				
		tempObj.scale =[1,1,1]
		tempObj.rotation =EulerAngles 0 0 0
		bounds = nodeLocalBoundingBox tempObj
		tempObj.pivot = [0,0,(bounds[1].z)]	
		tempObj.pos =[0,0,0]
		max modify mode	
	)
)


---------------------------------------------------界面----------------------------------------------------------
rollout resNormPlugin "规范检查" width:1125 height:29
(
	button 'standardBtn' "标准规范检查" pos:[0,0] width:115 height:29 toolTip:"执行RoomUGC的标准检查" align:#left
	button 'unitsBtn' "单位检查" pos:[125,0] width:115 height:29 toolTip:"场景单位检查" align:#left	
	button 'nameBtn' "资源名字检查" pos:[250,0] width:115 height:29 toolTip:"文件名字材质球名字检查" align:#left
	button 'polyToolsSelectBtn' "多边面检查" pos:[375,0] width:115 height:29 toolTip:"场景中文件大于4条边面检查" align:#left	
	button 'transformBtn' "Transform检查" pos:[500,0] width:115 height:29 toolTip:"检查Pos,Scale,Rotate,Axis" align:#left	
	button 'smoothnessBtn' "平滑组检查" pos:[625,0] width:115 height:29 toolTip:"文件平滑组检查" align:#left		
	button 'IsolateBtn' "点线面检查" pos:[750,0] width:115 height:29 toolTip:"文件点线面是否是孤立检查" align:#left
	button 'normalBtn' "法线检查" pos:[875,0] width:115 height:29 toolTip:"文件法线检查" align:#left	
	button 'resetTransBtn' "重置Transform" pos:[1000,0] width:115 height:29 toolTip:"重置对象坐标 旋转 缩放 并且轴居中到对象" align:#left
	on standardBtn pressed  do
	(
		norm_All()
	)
	on transformBtn pressed  do
	(
		norm_Transform()	
	)
	on nameBtn pressed  do
	(
		norm_ResName()	
	)
	on polyToolsSelectBtn pressed  do
	(
		norm_PolyToolsSelect()	
	)
	on smoothnessBtn pressed  do
	(
		norm_Smoothness()	
	)
	on normalBtn pressed  do
	(
		norm_Normal()	
	)
	on unitsBtn pressed do
	(		
		norm_Units()
	)
	on resNormPlugin close do
	(		
	)	
	
	on IsolateBtn pressed do
	(
		norm_Isolate()
	)
	on resetTransBtn pressed do
	(
		resetTransformAndAxis()
	)
)


---------------------------------------------------执行----------------------------------------------------------

--文件存在判断
fn existFile fname = (getfiles fname).count != 0

fileName =toLower(getSourceFileName() as string)
fileShortName = filenameFromPath fileName		
startUp = pathConfig.appendPath scriptspath "Startup"
fileName2 =toLower(pathConfig.appendPath startUp fileShortName) 
if (fileName != fileName2) then(		
	try
	(
		closerolloutfloater resNormFloater --close if exist
		DestroyDialog resNormPlugin
	)
	catch()	
	resNormFloater = newrolloutfloater "规范检查" 150 340
	addrollout resNormPlugin resNormFloater

	resNormPlugin.width = 150
	resNormPlugin.height = 310		
	resNormPlugin.standardBtn.pos = [0,0]
	resNormPlugin.unitsBtn.pos = [0,35]
	resNormPlugin.nameBtn.pos = [0,70]
	resNormPlugin.polyToolsSelectBtn.pos = [0,105]
	resNormPlugin.transformBtn.pos = [0,140]
	resNormPlugin.smoothnessBtn.pos = [0,175]
	resNormPlugin.IsolateBtn.pos = [0,210]
	resNormPlugin.normalBtn.pos = [0,245]
	resNormPlugin.resetTransBtn.pos = [0,280]	
)
else (	
	try
	(
		cui.UnRegisterDialogBar resNormPlugin
		DestroyDialog resNormPlugin	
	)
	catch()				
	CreateDialog resNormPlugin 1125 31
	cui.RegisterDialogBar resNormPlugin
	cui.DockDialogBar resNormPlugin #cui_dock_bottom
)	
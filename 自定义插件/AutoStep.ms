--文件拷贝 Max拷贝 Shell拷贝
fn copyFileWithPowerShell sourcePath destinationPath =
(    	
	result = copyFile sourcePath destinationPath	
	if result == undefined or (not result) do(
		command = "copy \"" + sourcePath + "\" \"" + (pathConfig.removePathLeaf destinationPath)+"\""			
		result = DOSCommand command	
		result = result == 0
	)
	return result
)

--文件存在判断
fn existFile fname = (getfiles fname).count != 0

--获取自动启动文件存放路径
fn getAutoStartupFilePath isFile:true fileName:undefined = (
	if fileName == undefined do
	(
		fileName = getSourceFileName() as string
		fileName = filenameFromPath fileName	
	)	
	startUp = pathConfig.appendPath scriptspath "Startup"
	if isFile then		
		fileName = pathConfig.appendPath startUp fileName 
	else
	
		return startUp
	return fileName
)

--设置自动启动
fn autoStartup targetPath sourcePath:undefined = (	
	if sourcePath == undefined do
		sourcePath = (getSourceFileName() as string)
	try(
		result = copyFileWithPowerShell sourcePath targetPath
		if result then
		(
			print "设置自动启动脚本成功:"+sourcePath
			return ok
		)	
		else(
			messageBox ("设置自动启动脚本失败 请手动复文件 \n"+sourcePath+"\n至目录：\n"+ ((getAutoStartupFilePath isFile:false) as string)) title:"规范检查脚本" beep:true
			return undefined
		)		
	)catch(
		messageBox ("设置自动启动脚本失败 请手动复文件 \n"+sourcePath+"\n至目录：\n"+ ((getAutoStartupFilePath isFile:false) as string)) title:"规范检查脚本" beep:true
		return undefined
	)	
)

--插件自启动
fn checkAutoStartup = (
	fileName_Startup = getAutoStartupFilePath fileName:"规范检查.ms"
	local sourcePath = (getSourceFileName() as string)
	sourcePath = (pathConfig.removePathLeaf sourcePath +"\\规范检查.ms")
	autoStartup fileName_Startup sourcePath:sourcePath
)	
	
--其他配合插件自启动
fn checkConfigStartup = (
	fileName_Startup = getAutoStartupFilePath fileName:"IFWNormals.ms"
	local sourcePath = (getSourceFileName() as string)
	sourcePath = (pathConfig.removePathLeaf sourcePath +"\\IFWNormals.ms")
	return (autoStartup fileName_Startup sourcePath:sourcePath)
)

checkAutoStartup() /* 检查并自动添加的Max自动启动脚本 */
checkConfigStartup() /* 检查并自动添加的Max自动启动脚本 */
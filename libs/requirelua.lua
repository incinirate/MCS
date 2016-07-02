local _G = _G or _ENV --Backwards compatability

local loadedDependencies = {}

local workingDirectory = ({...})[1] or "/"

local beingLoaded = {}

local function resolvePath(localPath, localDir)
  local startChar = localPath:sub(1, 1)
  if startChar == "/" or startChar == "\\" then
    return fs.combine( "", localPath )
  end
  return fs.combine( localDir, localPath )
end

local workingStack = {workingDirectory}
local function trackedLoad(file)
  if beingLoaded[file] then
    error("Circular reference between "..file.." and last call", 3)
  end
  beingLoaded[file] = true
  table.insert(workingStack, file)
  local val = loadfile(file)
  return function(...)
    local value = val(...)
    table.remove(workingStack, file)
    beingLoaded[file] = false
    return value
  end
end

_G.require = function(dependencies, callback)
  local objectList = {}
  for i=1,#dependencies do
    local resolved = resolvePath(dependencies[i], workingStack[#workingStack])
    if not loadedDependencies[resolved] then
      loadedDependencies[resolved] = trackedLoad(resolved)()
    end
    objectList[i] = loadedDependencies[resolved]
  end
  callback(unpack(objectList))
end

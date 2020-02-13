local open = io.open

local function readFile(path)
    local file = open(path, 'rb')
    if not file then return nil end
    local content = file:read '*a'
    file:close()
    return content
end

local output = '--[[\n' ..

[[
Easy UI. Build v0.0.4
@Author Sergey Eponeshnikov (https://github.com/eponesh)
]]

.. ']]\n\n__EUI_SCOPED_MODULES = {}\n'

local modulesList = {}

local function extractModule(moduleName)
    if (modulesList[moduleName] ~= nil) then return end
    modulesList[moduleName] = true

    print('Building module: ' .. moduleName)

    local fileName = moduleName:gsub('%.', '/') .. '.lua'
    local fileContent = readFile(fileName)

    for requiredModule in string.gmatch(fileContent, "require%('(%S+)'%)") do
        fileContent = fileContent:gsub(
            "require%('" .. requiredModule .. "'%)",
            "__EUI_SCOPED_MODULES['" .. requiredModule .. "']"
        )
        extractModule(requiredModule)
    end

    fileContent = fileContent:gsub('\nreturn', "\n__EUI_SCOPED_MODULES['" .. moduleName .. "'] =")

    output = output ..
        '\n-- ModuleName: "' .. moduleName .. '"\n' ..
        'do\n' ..
        fileContent ..
        'end\n'
end

local moduleName = 'main'
extractModule(moduleName)

output = output .. "\nEUI = __EUI_SCOPED_MODULES['".. moduleName .."']\n"

local exportingFileName = 'dist/eui.lua'
local exportingFile = open(exportingFileName, 'w+')
exportingFile:write(output)

print('\nbuild finished in ' .. os.clock() .. 's! Output: ' .. exportingFileName)

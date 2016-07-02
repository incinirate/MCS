require("../libs/sha-256.lua","config.lua",function(CONFIG,sha256)
    local tokenGenerator = {}
    local generator = {initialized=false}
    do
        tokenGenerator.generateToken = function(value)
            if not generator.initialized then
                tokenGenerator.initializeGenerator()
            end
            sha256.digest()
        end
        tokenGenerator.initializeGenerator = function()
            if fs.exists("/.")
        end
    end
    return tokenGenerator
end)

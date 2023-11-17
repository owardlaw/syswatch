local lfs = require "lfs"

local opento = {}

function opento.open_file(path)
    local command = "open -R " .. path
    
    local exit_code = os.execute(command)
    
    if exit_code == 0 then
        print("Finder opened to the file successfully.")
    else
        print("Failed to open Finder to the file.")
    end
    
end

return opento
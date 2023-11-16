local search = require "search"

print("s: Scan, e: Exit")
local input = io.read() 

if input == "s" then
    print("Enter path to scan:")
    local path = io.read()
    search.display_files_from_path(path)
end



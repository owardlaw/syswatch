local search = require "search"
local delete = require "delete"
local opento = require "opento"

while true do
    -- Print the menu options separated in line
    print("")
    print("-o:   Open finder to file")
    print("-d:   Delete file")
    print("-s:   Scan")
    print("-pwd: Quick Scan PWD")
    print("-q:   Quit")
    print("")
    -- Get user input
    local input = io.read()

    if input == "s" then
        io.write("Enter path to scan: ")
        local path = io.read()
        search.display_files_from_path(path)
        io.write("\nEnter any key to continue ")
        io.read()
    elseif input == "pwd" then
        local path = lfs.currentdir()
        search.display_files_from_path(path)
    elseif input == "q" then
        print("Exiting...")
        break
    elseif input == "d" then
        io.write("Enter file path to delete: ")
        local path = io.read()
        delete.del_by_path(path)
    elseif input == "o" then
        io.write("Enter file to open to: ")
        local path = io.read()
        opento.open_file(path)
    else
        print("Invalid input.")
    end
end


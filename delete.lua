local lfs = require "lfs"

local delete = {}

function delete.del_by_path(path)
    if os.remove(path) then
        print("\n" .. path)
        print("File deleted successfully.")
    else
        print("\n" .. path)
        print("Failed to delete the file or the file does not exist.")
    end
end

return delete
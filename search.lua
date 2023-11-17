local lfs = require "lfs"

local search = {}

function getFileSizeBytes(filePath)
    local attr = lfs.attributes(filePath)
    if attr and attr.mode == "file" then
        return attr.size 
    else
        return nil, "The path is not a file or does not exist."
    end
end

function normalizeBytes(bytes)
    local units = {"B", "KB", "MB", "GB", "TB"}
    local unit = 1
    while bytes >= 1024 and unit < #units do
        bytes = bytes / 1024
        unit = unit + 1
    end
    return string.format("%.2f", bytes) .. " " .. units[unit]
end

function crawl(path)
    local files = {}
    local cwd = lfs.currentdir()

    local function recursiveSearch(absPath)
        for file in lfs.dir(absPath) do
            if file ~= "." and file ~= ".." then
                local fullPath = absPath..'/'..file
                local attr = lfs.attributes(fullPath)
                assert (type(attr) == "table")
                if attr.mode == "directory" then
                    recursiveSearch(fullPath)
                else
                    local size = attr.size or 0
                    table.insert(files, {path = fullPath, size = size})
                end
            end
        end
    end 

    if not path:match("^/") then
        path = cwd..'/'..path
    end

    path = path:gsub("/%./", "/"):gsub("//", "/"):gsub("/%.$", "/")
    local function normalizeDir(dir)
        local parts = {}
        for part in dir:gmatch("[^/]+") do
            if part == ".." then
                parts[#parts] = nil
            else
                parts[#parts + 1] = part
            end
        end
        return '/' .. table.concat(parts, '/')
    end

    path = normalizeDir(path)

    local status, result_or_error = pcall(function() return recursiveSearch(path) end)
    table.sort(files, function(a, b) return a.size < b.size end)
    return files, status
end

function isDir(name)
    if type(name)~="string" then return false end
    local cd = lfs.currentdir()
    local is = lfs.chdir(name) and true or false
    lfs.chdir(cd)
    return is
end

function search.display_files_from_path(path)

    if not isDir(path) then
        print("Error: the path you entered is not a directory.")
        return
    end

    local files, status = crawl(path)
    for _, file in ipairs(files) do
        local normalizedSize = normalizeBytes(file.size)
        print(normalizedSize .. " - " .. file.path)
    end

    local largest_file = files[#files]
    local largest_file_size = normalizeBytes(largest_file.size)
    print("\nLargest file: " .. largest_file_size .. " - " .. largest_file.path .. "\n")

    if not status then
        print("Error: some files were not reached due to permission errors, these probably are not files you want to delete.")
    end
end

return search
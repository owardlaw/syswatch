local lfs = require "lfs"

local sysinfo = {}

function sysinfo.cpu_info()
    local handle = io.popen("sysctl -n machdep.cpu.brand_string")
    local cpu_info = handle:read("*a")
    handle:close()
    return cpu_info
end


function sysinfo.ram_info()
    local handle = io.popen("sysctl -n hw.memsize")
    local ram_info = handle:read("*a")
    handle:close()
    return ram_info
end

function sysinfo.gpu_info()
    local handle = io.popen("system_profiler SPDisplaysDataType | grep Chipset")
    local gpu_info = handle:read("*a")
    handle:close()
    return gpu_info
end

function sysinfo.os_info()
    local handle = io.popen("sw_vers -productVersion")
    local os_info = handle:read("*a")
    handle:close()
    return os_info
end

function sysinfo.disk_info()
    local handle = io.popen("df -h /")
    local disk_info = handle:read("*a")
    handle:close()
    return disk_info
end

function sysinfo.all_info()
    local cpu_info = sysinfo.cpu_info()
    local ram_info = sysinfo.ram_info() / 1024 / 1024 / 1024
    local gpu_info = sysinfo.gpu_info()
    local os_info = sysinfo.os_info()
    local disk_info = sysinfo.disk_info()
    local sysinfo = cpu_info  .. gpu_info:gsub("^%s*(.-)%s*$", "%1") ..'\n'.. ram_info..'\n'  .. os_info .. disk_info

    print(sysinfo)
end 
sysinfo.all_info()
return sysinfo


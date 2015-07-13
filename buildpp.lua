
local function write_file(file, str)
    local f = io.open(file, "w")
    f:write(str)
    f:flush()
    f:close()
end

local fmt = [[
#pragma once
#include <windows.h>

#define _Stringizing(v)         #v
#define _VerJoin_4(a, b, c, d)  _Stringizing(a.b.c.d)
#define _VerJoin_3(a, b, c)     _Stringizing(a.b.c)

#define VER_Major               %d
#define VER_Minor               %d
#define VER_Release             %d
#define VER_Build               %d

#define STR_Version             TEXT(_VerJoin_4(VER_Major, VER_Minor, VER_Release, VER_Build))
#define VERSION_STRING          TEXT(_VerJoin_3(VER_Major, VER_Minor, VER_Release))

#define BuildTime               TEXT("%s")
]]

local f = io.open("info.txt", "r")
if f then
    local info = f:read("*all")
    fmt = fmt .. info
    f:close()
else
    fmt = fmt .. [[
#define STR_AppName             TEXT("")
#define STR_Filename            TEXT("")
#define STR_Author              TEXT("Microsoft")
#define STR_Corporation         TEXT("Microsoft Corporation")
#define STR_Description         TEXT("HTML helper dll.")
#define STR_Copyright           TEXT("(C) Microsoft Corporation. All rights reserved.")    
]]
end

local number_fmt = [[
%s=%d
%s=%d
%s=%d
%s=%d]]

local out_fmt = [[
--------------------
building version......
version is:
%s
--------------------]]

function get_number(lines, name, default)
    local number = string.match(lines, name .. "=(%d+)")
    if number then
        return number
    else
        return default
    end
end

local major_name  , major_number  , minor_name, minor_number = "major"  , 0, "minor", 1
local release_name, release_number, build_name, build_number = "release", 1, "build", 0

local f = io.open("number.inc", "r")
if f then
    lines = f:read("*all")
    f:close()
    major_number   = get_number(lines, major_name  , major_number)
    minor_number   = get_number(lines, minor_name  , minor_number)
    release_number = get_number(lines, release_name, release_number)
    build_number   = get_number(lines, build_name  , build_number)
end

if arg[1] == "release" then
    release_number = release_number + 1
end
if arg[1] == "build" then
    build_number = build_number + 1
end

local version = string.format(fmt,
                              major_number  , minor_number,
                              release_number, build_number,
                              os.date("%Y-%m-%d %H:%M:%S"))
write_file("version.h", version);

local number = string.format(number_fmt,
                             major_name  , major_number  , minor_name, minor_number,
                             release_name, release_number, build_name, build_number)
write_file("number.inc", number)

print(string.format(out_fmt, number))

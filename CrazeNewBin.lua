reg_all = {}
reg_path = "S:\\CrazeNewBin_work\\data\\reg\\*.txt"
exec("/hide", [[cmd /c del /q /f out_reg.txt]])

-- 正则匹配获取多行
function string.gfind(stdout, patten)
    local i, j = 0, 0
    return function()
        i, j = string.find(stdout, patten, j + 1)
        if (i == nil) then -- end find
            return nil
        end
        return string.sub(stdout, i, j)
    end
end

function string.splitlines(str)
  local arr = {}
 for line in string.gmatch(str, "([^\n]+)") do
    table.insert(arr, line)
  end
  return arr
end

win = {}
function win.popen(cmd)
  local exitcode, stdout = winapi.execute(cmd)
  stdout = stdout:gsub("\r\n", "\n")
  return stdout
end

dir = {}
function dir.folders(path)
  local folders = win.popen('dir /b /s \"' .. path .. '\"')
  --alert(folders)
  return string.splitlines(folders)
end

function out_txt(out_file, out_text)
io.output('S:\\CrazeNewBin_work\\' .. out_file)
io.write(out_text)
io.close()
end
--文本文件列表
reg_list = {}
reg_list = dir.folders(reg_path)
table.sort(reg_list)


--读文件到内容
function read_txt(file_item)
    local file = io.open(file_item, "r")
    if file == nil then
      print("no")
    else
        local text = file:read("*a")
	   	table.insert(reg_all, text)
		end
end

--读全部文本到写到单文件
for i, file_item in ipairs(reg_list) do
read_txt(file_item)
end
out_item = table.concat(reg_all, "\n")
out_txt("excel.txt", out_item)

--按行读单文件中的文本


--[[
clsid_t = {}
for clsid in string.gfind(out_item, "Classes\\CLSID\\*.-}") do
out_file = "clsid.txt"
table.insert(clsid_t, clsid)
end

clsid_t = table.concat(clsid_t, "\n")
out_txt(out_file, clsid_t)
--alert(out_item)
--]]

ActivatableClassID_pe = {}
Interface_pe = {}
clsid_pe = {}
WOW6432Node_CLSID_pe = {}
WOW6432Node_interface_pe = {}
other_pe = {}
pereg = {}

function add_tb(tbname, reg_line)
local file = io.open("S:\\CrazeNewBin_work\\" .. tbname .. ".txt", "w")
file:write(reg_line)
file:close()
end	


for reg_line in io.lines("S:\\CrazeNewBin_work\\excel.txt") do
if reg_line:find("Classes\\clsid") then
tbname = "clsid_pe"
add_tb(tbname, reg_line)
elseif reg_line:find("Microsoft\\WindowsRuntime\\ActivatableClassID\\") then
tbname = "ActivatableClassID_pe"
add_tb(tbname, reg_line)
elseif reg_line:find("Classes\\Interface\\") then
tbname = "interface_pe"
add_tb(tbname, reg_line)
elseif reg_line:find("Classes\\WOW6432Node\\CLSID\\") then
tbname = "WOW6432Node_clsid_pe"
add_tb(tbname, reg_line)
elseif reg_line:find("Classes\\WOW6432Node\\interface\\") then
tbname = "WOW6432Node_interface_pe"
add_tb(tbname, reg_line)
else 
tbname = "other_pe"
add_tb(tbname, reg_line)
end
end


--pe_clsid = table.concat(clsid_pe, "\n")
--alert(pe_clsid)
--alert(pereg.line)

--out_txt("clsid_pe.txt", line)
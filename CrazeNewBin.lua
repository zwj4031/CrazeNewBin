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
reg_list = {}
reg_list = dir.folders(reg_path)
table.sort(reg_list)

function read_txt(reg_file)
    local file = io.open(reg_file, "r")
    if file == nil then
      print("no")
    else
        local text = file:read("*a")
		 table.insert(reg_all, text)
		end
end

for i, file_item in ipairs(reg_list) do
read_txt(file_item)
end
out_item = table.concat(reg_all, "\n")

function out_txt(out_file, out_text)
io.output('S:\\CrazeNewBin_work\\' .. out_file)
io.write(out_text)
io.close()
end

clsid_t = {}
for clsid in string.gfind(out_item, "Classes\\CLSID\\*.-}") do
out_file = "clsid.txt"
table.insert(clsid_t, clsid)
end

clsid_t = table.concat(clsid_t, "\n")
out_txt(out_file, clsid_t)
--alert(out_item)





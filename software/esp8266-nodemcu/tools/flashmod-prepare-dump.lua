--BASED ON https://gist.github.com/dnc40085/45e3af2fea22003b3ac2
--inside ESP8266 lua program, use "requireModule" in order to load precompiled modules

function writeModule(sourceFile, destDir)
  local moduleName = string.sub(sourceFile, 1, string.len(sourceFile)-4);
  print("Preparing " .. sourceFile .. ". Writing function files to ".. destDir .."...");

  local tbl = dofile(sourceFile);
  for k,v in pairs(tbl) do
    if type(v) == "function" then
      -- print(tostring(k) .. "=" .. tostring(v));
      if(k ~= nil) then
        writeFunction(k, v, moduleName, destDir);
      end
      tbl[k] = nil;
    end
  end
end

function writeFunction(funcName, funcContents, moduleName, destDir)
  local fn = string.format(destDir .. "/#_%s_%s", moduleName, funcName);
  print("Writing file " .. fn .. " f=" .. moduleName .. "." .. funcName);
  if(string.len(fn)>31+string.len(destDir)+1) then
    error("Function '" .. moduleName .. "." .. funcName .. "' name is too long (>31). Shorten it by " .. (string.len(fn)-31) .. " chars");
  end

  local file = io.open(fn, "w+");
  io.output(file);
  --print("Dumping " .. moduleName .. "." .. funcName);
  -- local result = string.dump(funcContents);
  local result = string.dump(funcContents);
  -- print(funcName .. " - " .. result);
  if(string.len(result)<10000) then
    io.write(result);
    print("Function " .. moduleName .. "."  .. funcName .. " written to disk. len=" .. string.len(result) .. ".");
  else
    error("Function " .. moduleName .. "." .. funcName .. " is too large and may not fit esp8266 ram. Break it into two or more methods keeping each function ~2000 bytes.");
  end
  io.close(file);

  -- local file = io.open(fn, "r");
  -- io.input(file);
  -- print("AAAAA" .. tostring(file));
  -- local s = io.read("*a");
  -- print("SSSS " .. moduleName .. "." .. funcName);
  -- local test = assert(loadfile(fn));
  -- -- local test = assert(loadstring(s));
  -- print("BBBB " .. tostring(dofile));
  -- -- local test = assert(loadstring("i = i + 1;"));
  -- error("TOSTRING " .. tostring(test()));

end

if(arg[1] == nil or arg[2] == nil) then
  print("Usage: lua _flashmod_prepare.lua [lua file] [dest dir]");
else
  writeModule(arg[1], arg[2]);
end

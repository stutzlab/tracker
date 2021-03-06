--TIMER 6 - CAPTIVE PORTAL TIMEOUT AND INTERNET SENSOR

print(">>> StutzThings <<<");
print("Enter 'x' to skip booter");

--global variable containing the launched App
_app = nil;

local runboot = true;

uart.setup(0,9600,8,0,1,0);
uart.on("data", 0, function(data)
  if(data == "x" or data == "X") then
    runboot = false;
  end
end);

tmr.register(0, 1000, tmr.ALARM_SINGLE, function()
  --unregister callback
  uart.on("data");

  if(runboot) then
    print("Launching boot...");
    --dofile("!launcher.lua");

  else
    print("Skipping boot");
  end
end)

tmr.start(0);

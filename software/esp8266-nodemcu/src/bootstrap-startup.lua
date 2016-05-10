dofile("bootstrap-log.lua");--2100

local b = {};

function b.startup(callback)

  _b_log.log("");
  _b_log.log("===========================================");
  _b_log.log("**** Starting " .. dofile("bootstrap-config.lua").device_name .. " ****");
  _b_log.log("App URL: " .. dofile("bootstrap-config.lua").app-info_url);
  _b_log.log("Boot reason: " .. node.bootreason());
  _b_log.log("===========================================");
  _b_log.log("");

  local watchdog = dofile("util-watchdog.lua");--5800

  if(dofile("bootstrap-utils.lua").getAppInfoFromFile() == nil) then
      _b_log.log("BOOTSTRAP -- App file not found. Incrementing watchdog to force captive portal.");
      watchdog.increment();
      watchdog.increment();
      watchdog.increment();
  end

  if(watchdog.isTriggered(2)) then
    _b_log.log("BOOTSTRAP -- Watchdog triggered. Activating captive portal. counter=" .. watchdog.getCounter());
    local rebootLoopDetected = watchdog.isTriggered(20);

    local captiveTimeout = 10000;
    if(rebootLoopDetected) then
      _b_log.log("BOOTSTRAP -- Reboot loop detected. Won't start App until internet connection is detected.");
      captiveTimeout = 0;
    end

    _b_log.log("About to load util-captive1. heap=" .. node.heap());
    watchdog = nil;
    collectgarbage();
    _b_log.log("About to load util-captive2. heap=" .. node.heap());

    dofile("bootstrap-captive.lua");

  else
    b.startApp(callback);
  end
end

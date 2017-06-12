local physics = require "physics"
local timer = require "timer"

local _M={};


function _M.newBox(params)
  local n = params.n or 1;
  print (n)
  if (n > 10) then return 'near' end;
  local box = display.newImageRect("crate-"..n..".png",n*15,n*15);
  box.x = params.x or math.random()*display.actualContentWidth-n*10;
  box.y = params.y or math.random()*display.actualContentHeight-n*10;
  box.rotation = math.random()*360;
  
  box.isBullet = true;
  
  physics.addBody(box,{density =1*(n/3), friction = 0.5, bounce= 0.5})
  box.scene = params.scene;
  box.type = 'box'
  box.n = n;
  box.id = math.random()*10000;
  box.kill = false
  --box.scene:insert(box)
  local affected = {};

  function box:collision(event)
    
    if(event.phase == 'began') then
      --print('boop')
      if(event.other.type == 'box') then
      if(not affected[event.other] and box.kill == false and event.other.kill == false) then
        affected[event.other]=true;
        --print(event.target, box.n, event.other.n, event.otherElement)
        -- mergin
        if(box.id <  event.other.id and  box.n == event.other.n and event.other.n ~= nil) then
          
          
          timer.performWithDelay(1, function()
          
          local ox = event.other.x or self.x or 0;
          local oy = event.other.y or self.y or 0;
          local sx = self.x or 0;
          local sy = self.y or 0;
          
          local rq = require('box').newBox
          local nb = rq({scene = box.scene, x = (ox  + sx)/2, y = (oy + sy)/2, n = box.n+1})
          if(box) then
            box:destroy()
          end
          if(event.other) then
            event.other:destroy()
          end
          
          box.kill = true;
          event.other.kill = true;
          nb:addToScene();
          	end)
         -- event.other:removeSelf();
         --[[timer.performWithDelay(2, function()
          box:removeSelf();
          event.other:removeSelf()
          end);]]
        end
        end
      end
    end
  end
  box:addEventListener('collision');

  function box:destroy()
    print ('Bye')
    
    
    self:removeSelf() 
    self = nil;
    
  end
  
  function box:addToScene()
    box.scene:insert(box);
  end
return box;
end

return _M
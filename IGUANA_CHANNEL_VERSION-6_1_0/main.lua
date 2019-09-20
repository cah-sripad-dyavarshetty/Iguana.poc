require 'split'

local function trace(a,b,c,d) return end

function main(Data)
   local PID = Data:sub(Data:find("PID.-\r"))
   local Street = GetStreet(PID)
   trace(Street)
end

function GetStreet(Address)
   local Fields = Address:split('|')
   local Address = Fields[12]
   local Street = Address:split('^')[1]
   return Street
end

function AnotherFunction()
   -- This function is not called and therefore
   -- has no annotations or auto-completion. 
end



require 'split'

function trace(A) return end 

-- Search whole directory = Directory = 'edit\\admin\\other\\Patient'
Directory = 'edit\\admin\\other\\'

function main(Data)
   
   queue.push{data=Data}
   --more than one = local F = io.popen('cd '..Directory .. ' && dir *.csv /B')
   local F = io.popen('cd '..Directory .. ' && dir Patient_List.csv /B')
   --local F = io.popen(Directory)
   
   local R = F:read('*a')
   local Files = R:split('\n')
   trace(Files)
   TT = ''

   for i =1, #Files do 
      if Files[i] and Files[i] ~= '' then
         trace(Files[i])
         TT = TT..'\r'..PullCSV(Directory..Files[i])
         trace(TT)
      end
   end

   net.http.respond{body=TT}
   
end

function PullCSV(F)
   local F = io.open(F)
   if F then 
      local L = F:read('*a')
      local TableComplete = build(L)
      return TableComplete
   end
end

function build(csv)
   if csv ~= nil and csv ~= '' then
      local L = csv:split('\n')
      local newT = {}
    --start html table
      newT[1] = "<TABLE border ='1'><TR>"
   --create inside of html table 
      for i =2, #L do 
         newT[i] = "<TD>"..L[i].."</TD></TR><TR>"
         newT[i] = newT[i]:gsub(',', '</TD><TD>')
      end
 --add one additional line to end html table 
      newT[#L+1] = "</TR></TABLE>"
  --put it all together and return
      Thtml = ''
      for k,v in pairs(newT) do 
         Thtml = Thtml..v
      end
      return Thtml
   end 
end
-- The main function is the first function called from Iguana.
-- The Data argument will contain the message to be processed.
function main()
     local url = "C:\\3PL\\XMLdata.xml"
     function GetFileExtension(url)
        return url:match("^.+(%..+)$")
     end
     c=GetFileExtension(url)
        print(c)
     local a='.xml'
        print(a,c)
     if(c==a) then
     local F = io.open('C:\\3PL\\XMLdata.xml', "r")
     local Content =  F:read('*a')
     F:close()
     local Msg = xml.parse(Content)  
        print(Msg)  
     local conn = db.connect
   {
      api = db.MY_SQL,
      name = 'test',
      user = 'root',
      password = '',
      use_unicode=true,
      live = true
   }
     --[[ local conn = db.connect{   
      api=db.ORACLE_OCI, 
      name='Oracle EZCONNECT string',
      user='your_login', 
      password='secret',
      use_unicode = true,
      live = true
   ]]--
 local SqlInsert =
   [[
   INSERT INTO orders
   (
   
   VAL
 )
   VALUES
   (
  
   ]]..
  
   "'"..Msg.patients.patient.id.."',"..
   "\n   '"..Msg.patients.patient["first-name"][1].."',"..
   "\n   '"..Msg.patients.patient["last-name"][1].."',"..
   "\n   '"..Msg.patients.patient["social-security-no"][1].."'"..
   '\n   )'  
   
  -- "'"..Content.."')"
   -- Insert data into database
   Conn:execute{sql=SqlInsert, live=true} 
    --print(os.date("%x"))
   Conn:query('SELECT * FROM orders')
       end
   
    local SqlInsert =
   [[
   INSERT INTO order_summary
   (
   
   VAL
 )
   VALUES
   (
  
   ]]..
  
   "'"..Msg.patients.patient.id.."',"..
   "\n   '"..Msg.patients.patient["first-name"][1].."',"..
   "\n   '"..Msg.patients.patient["last-name"][1].."',"..
   "\n   '"..Msg.patients.patient["social-security-no"][1].."'"..
   '\n   )'  
   
  -- "'"..Content.."')"
   -- Insert data into database
   Conn:execute{sql=SqlInsert, live=true} 
    --print(os.date("%x"))
   Conn:query('SELECT * FROM order_summary')
   
   


   
       end
end
 

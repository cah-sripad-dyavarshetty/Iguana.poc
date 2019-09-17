-- The main function is the first function called from Iguana.
URL = 'http://team-scale.com/TestData/ng_text_v15/api'
 
function main()
   -- get data from web service
   local R = net.http.get{url=URL,live = true}
 
   -- parse and extract data
   local X = json.parse{data=R}
 
   -- add data processing here
 
   -- push the result to the queue
   
   queue.push(X[1].id)
   
   --queue.push(R)
   
   --[[
    for i=1,10,1 do
      queue.push(X[i].id)
      queue.push(X[i].name)
    end
   --]]
   
   --[[
   for i=1,10,1 do
      queue.push(X[i].id)
      queue.push(X[i].name)
       queue.push(X[i].status)
       queue.push(X[i].countryFullName)
       queue.push(X[i].city)
       queue.push(X[i].mainPhotoUrl)
       queue.push(X[i].ratePerHour)
       queue.push(X[i].currency)
       queue.push(X[i].lat)
       queue.push(X[i].lon)
       queue.push(X[i].maxParticipants)
       queue.push(X[i].ratingAvg)
       queue.push(X[i].distance)
   end 
   --]]  
   
end
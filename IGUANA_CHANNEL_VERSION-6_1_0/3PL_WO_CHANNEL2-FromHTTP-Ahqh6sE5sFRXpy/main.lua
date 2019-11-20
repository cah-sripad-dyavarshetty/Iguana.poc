URL='https://spselitestg.cardinalhealth.net/stage_841/ws/DmsWebService'
function main()

   dbConnection = require("DBConnection")
   
    newFile = io.open( "C:\\3PL_WO\\SOAP\\soapdata.txt", "w+" )
    --local R =net.http.post{url=URL,live=true}
   F=io.open("C:\\3PL_WO\\SOAP\\soaprequest.txt","r")
          Data =  F:read('*a')
         F:close()
    --local R = net.http.post{response_headers_format='raw',body='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wsc="wsclient.dms.tecsys.com"><soapenv:Header/><soapenv:Body><wsc:update><arg0><userName>tecuser</userName><password>supt2013</password><sessionId>0</sessionId><transactions><action>update</action><data><DmsOrd-Update-OrderHoldWebordering><Organization>EP</Organization><Division>01</Division><Order>141302</Order><Customer>EP10023</Customer><DmsOrdHoldWebordering><Line><OrderId>52135534</OrderId><HoldSequence>1</HoldSequence><HoldCode>CSWB</HoldCode><OnHold>N</OnHold><DateAndTimeOrderReleasedFromHold>2019-11-15</DateAndTimeOrderReleasedFromHold><ReleaseComment>validated</ReleaseComment></Line></DmsOrdHoldWebordering></DmsOrd-Update-OrderHoldWebordering></data></transactions></arg0></wsc:update></soapenv:Body></soapenv:Envelope>',url=URL,live=true}
   R = net.http.post{response_headers_format='raw',body=Data,url=URL,live=true}
     X =xml.parse{data=R}


    c=net.http.respond{headers='',body=X["soap:Envelope"]["soap:Body"]["ns2:updateResponse"]["return"].transactions.data["DmsOrd-Update-OrderHoldWebordering"].DmsOrdHoldWebordering.Line.OnHold:nodeText(),persist=false,code=5}
    print(c)

    newFile:write(c)

    newFile:close()



    function remove( filename, starting_line, num_lines )

         fp = io.open( filename, "r" )
        if fp == nil then
            return nil
        end
        content = {}
        i = 1;
        for line in fp:lines() do
            if i < starting_line or i >= starting_line + num_lines then
                content[#content+1] = line
            end
            i = i + 1
        end
        --print(content)
        if i > starting_line and i < starting_line + num_lines then
            print( "Warning: Tried to remove lines after EOF." )
        end
        fp:close()


        fp = io.open("C:\\3PL_WO\\SOAP\\soapdatacopy.txt", "w+" )
        for i = 1, #content do
            fp:write( string.format( "%s\n", content[i] ) )
        end
        fp:close()

    end

    remove('C:\\3PL_WO\\SOAP\\soapdata.txt',1,10)



    fp = io.open("C:\\3PL_WO\\SOAP\\soapdatacopy.txt", "r+" )
     Content =  fp:read('*a')
    print(Content)
   
   
   
   
   
function DBConn()
    dbConnection.connectdb()
end
   
   if pcall(DBConn) then 
   
 CURSOR=conn_dev:query{sql='SELECT PROD_NUM FROM 3pl_sps_ordering.order_detail', live=true};
      print(CURSOR,CURSOR[1].PROD_NUM,#CURSOR)
      
      CURSOR1=conn_dev:query{sql='SELECT * FROM 3pl_sps_ordering.csos_order_header', live=true};

 
      print(CURSOR1,#CURSOR1,CURSOR1[1].PO_NUMBER,CURSOR1[1].PO_DATE,CURSOR1[1].ACTIVE_FLG)
      
      for i=1,#CURSOR1 do
         print(CURSOR1[i].PO_NUMBER)
         end
     --[[ for i=1,#CURSOR1 do
         CURSOR3=conn_dev:query{sql='SELECT * FROM 3pl_sps_ordering.order_header where PO_NUM==CURSOR2[i].PO_NUMBER and PO_DTE==CURSOR2[i].PO_DATE and ACTIVE_FLG==CURSOR2[i].ACTIVE_FLG', live=true};
        print(CURSOR3)
      end
      ]]--
       else
            log_file:write("Database connection  is not exist on : "..os.date('%x').." at :"..os.date('%X'),"\n")
                                end
end

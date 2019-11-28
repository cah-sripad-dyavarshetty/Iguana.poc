local file_soap={}

function file_soap.soaprequest()
  soap_template='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wsc="wsclient.dms.tecsys.com"><soapenv:Header/><soapenv:Body><wsc:update><arg0><userName>tecuser</userName><password>supt2013</password><sessionId>0</sessionId><transactions><action>update</action><data><DmsOrd-Update-OrderHoldWebordering><Organization>'..customer_billto_shipto_data[1].ORG_CDE..'</Organization><Division>01</Division><Order>'..order_header_data[1].ELITE_ORDER..'</Order><Customer>'..customer_billto_shipto_data[1].BILLTO_NUM..'</Customer><DmsOrdHoldWebordering><Line><OrderId>'..order_header_data[1].ELITE_ORDER_NUM..'</OrderId><HoldSequence>1</HoldSequence><HoldCode>CSWB</HoldCode><OnHold>N</OnHold><DateAndTimeOrderReleasedFromHold>'..os.date()..'</DateAndTimeOrderReleasedFromHold><ReleaseComment>validated</ReleaseComment></Line></DmsOrdHoldWebordering></DmsOrd-Update-OrderHoldWebordering></data></transactions></arg0></wsc:update></soapenv:Body></soapenv:Envelope>'
                    print(soap_template)
                    Response = net.http.post{response_headers_format='raw',body=soap_template,url=URL,live=true}
                    print(Response)
                    after_parsing =xml.parse{data=Response}
                    print(after_parsing)
                    net.http.respond{headers='',body='',persist=false,code=5}

      end
   

   
function file_soap.getsoapresponsevalues(after_parsing)
     result=after_parsing["soap:Envelope"]["soap:Body"]["ns2:updateResponse"]["return"].transactions.data["DmsOrd-Update-OrderHoldWebordering"].DmsOrdHoldWebordering.Line.OnHold:nodeText()
  return result
   end

 
   

   
  

return file_soap
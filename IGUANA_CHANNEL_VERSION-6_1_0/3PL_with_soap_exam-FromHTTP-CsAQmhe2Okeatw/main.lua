net.http.respond{headers='',body='',persist=false,code=5}
    
function main()

    Update=require("StoredProcedures")
    properties = require("properties")
    constants = require("Constants")
    mail=require("mail")
    soap=require("Soap_Function")

    properties.directory_path()
    properties.db_conn()
    constants.csos_order_header_size()
    constants.csos_order_details_size()
    constants.log_statements()
    constants.query_constants()
    constants.frequently_constants()

    log_file = getLogFile(output_log_path)    --calling the geLogFile function
    log_file:write(TIME_STAMP..CHANNEL_STARTED_RUNNING,"\n")
    local transaction_completed, transaction_not_completed = 0,0
    if pcall(DBConn) then   --if 2  --handling exception for database connection
        csos_order_header_data=conn_dev:query{sql="select CSOS_ORD_HDR_NUM,UNIQUE_TRANS_NUM,PO_NUMBER,PO_DATE,SHIPTO_NUM from 3pl_sps_ordering.csos_order_header where CSOS_ORDER_HDR_STAT='"..tostring(CSOS_ORDER_HDR_STAT_VALUE).."';", live=true};
        if(#csos_order_header_data>0 ) then   --if 3  -- checking for csos_order_header_data size
           log_file:write(TIME_STAMP.."Retrieve data from csos_order_header of "..#csos_order_header_data.." transactions ","\n")
           for i=1,#csos_order_header_data,1 do  --for 1  --initial loop for starting comparision
                log_file:write(TIME_STAMP.."Transaction "..i.." - Unique Transaction Number "..csos_order_header_data[i].UNIQUE_TRANS_NUM,"\n")  
                order_header_data=conn_dev:query{sql="select ELITE_ORDER,ELITE_ORDER_NUM,ORDER_NUM,CUSTOMER_NUM,CSOS_ORDER_NUM,PO_NUM,PO_DTE from 3pl_sps_ordering.order_header where CSOS_ORDER_NUM='"..tostring(csos_order_header_data[i].UNIQUE_TRANS_NUM).."';",live=true};
                customer_billto_shipto_data=conn_dev:query{sql="select BILLTO_NUM,ORG_CDE,CUSTOMER_NUM,SHIPTO_NUM FROM 3pl_sps_ordering.customer_billto_shipto WHERE CUSTOMER_NUM='"..tostring(order_header_data[1].CUSTOMER_NUM).."';",live=true};
                if(#order_header_data>0 and #customer_billto_shipto_data>0) then  --if 4  --checking for order_header_data and customer_billto_shipto_data size
                    log_file:write(TIME_STAMP..csos_order_header_data[i].UNIQUE_TRANS_NUM.." - Extracted data from order_header","\n")
                    log_file:write(TIME_STAMP..csos_order_header_data[i].UNIQUE_TRANS_NUM.." - Extracted data from customer_billto_shipto","\n")
                    if(tostring(csos_order_header_data[i].PO_NUMBER)==tostring(order_header_data[1].PO_NUM)
                        and tostring(csos_order_header_data[i].PO_DATE)==tostring(order_header_data[1].PO_DTE)
                        and tostring(csos_order_header_data[i].UNIQUE_TRANS_NUM)==tostring(order_header_data[1].CSOS_ORDER_NUM)
                        and tostring(csos_order_header_data[i].SHIPTO_NUM)==tostring(customer_billto_shipto_data[1].SHIPTO_NUM)
                        )
                    then  --if 5  --csos_order_header_data and order_header data comparing
                        order_details_data=conn_dev:query{sql="select REQ_QTY,SHIP_UOM_DESC,PROD_NUM from 3pl_sps_ordering.order_detail where ORDER_HDR_NUM='"..tostring(order_header_data[1].ORDER_NUM).."';",live=true};
                        if(#order_details_data>0) then  --if 6 --checking th size of order_details_data
                            log_file:write(TIME_STAMP..csos_order_header_data[i].UNIQUE_TRANS_NUM.." - Extracted data from order_details","\n")
                            prod_data={}
                            for j=1,#order_details_data do  -- for 2  -- loop for getting prod table details on the basis of order_details_data
                                prod_data[j]=conn_dev:query{sql="select SKU_ITEM_ID,NDC_ID,DEA_SCHEDULE FROM 3pl_sps_ordering.prod where PROD_NUM='"..tostring(order_details_data[j].PROD_NUM).."';",live=true};
                            end  --end for 2
                            if(#prod_data>0) then -- if 13 prod_data
                            log_file:write(TIME_STAMP..csos_order_header_data[i].UNIQUE_TRANS_NUM.." - Extracted data from prod","\n")
                            csos_order_details_data=conn_dev:query{sql="select CSOS_ORD_HDR_NUM,QUANTITY,BUYER_ITEM_NUM,NATIONAL_DRUG_CDE,DEA_SCHEDULE,SIZE_OF_PACKAGE FROM 3pl_sps_ordering.csos_order_details where CSOS_ORD_HDR_NUM='"..tostring(csos_order_header_data[i].CSOS_ORD_HDR_NUM).."';",live=true};
                             if(#csos_order_details_data>0) then -- if 14 data from csos_order_details_data
                             log_file:write(TIME_STAMP..csos_order_header_data[i].UNIQUE_TRANS_NUM.."- Extracted data from csos_order_details","\n")
                             matched_order_details_status=0
                             for k=1,#csos_order_details_data do  --for 3  loop for starting details tables comparing
                                 if(tostring(csos_order_details_data[k].QUANTITY)==tostring(order_details_data[k].REQ_QTY) and
                                     tostring(csos_order_details_data[k].SIZE_OF_PACKAGE)==tostring(order_details_data[k].SHIP_UOM_DESC) and
                                     tostring(csos_order_details_data[k].BUYER_ITEM_NUM)==tostring(prod_data[k][1].SKU_ITEM_ID) and
                                     tostring(csos_order_details_data[k].NATIONAL_DRUG_CDE)==tostring(prod_data[k][1].NDC_ID)
                                     and tostring(csos_order_details_data[k].DEA_SCHEDULE)==tostring(prod_data[k][1].DEA_SCHEDULE) )
                             then  --if 7  --for comparing the csos_order_details_data and order_details_data
                                matched_order_details_status=matched_order_details_status+1
                            end  --end if 7
                            end  --end for 3
                            if(matched_order_details_status==#order_details_data and matched_order_details_status==#csos_order_details_data )
                            then  --if 8  -- checking the result of comparing
                                log_file:write(TIME_STAMP..csos_order_header_data[i].UNIQUE_TRANS_NUM.." - Matched order_details","\n")
         
                                soap.soaprequest()--calling soap function
                                final_result=soap.getsoapresponsevalues(after_parsing)
                              
                                if(final_result=='N') then  --if 9  -- checking whether we got required result through soap
                                    log_file:write(TIME_STAMP..csos_order_header_data[i].UNIQUE_TRANS_NUM.." - Response from the soap is 'N'","\n")
                                    Update.updateProcedure() -- calling function to create a procedure
                                    conn_dev:execute{sql=[[START TRANSACTION;]] ,live=true};
                                    sql_update = "CALL Update_Procedure("
                                        ..conn:quote(tostring(csos_order_header_data[i].UNIQUE_TRANS_NUM))..
                                        ")"
                                    sql_update_status = conn_dev:execute{sql=sql_update, live=true};
                                    if(sql_update_status == nil) then  --if 10 -- verifying updation status
                                        log_file:write(TIME_STAMP..csos_order_header_data[i].UNIQUE_TRANS_NUM..UPDATE_SUCCESS,"\n")
                                        conn_dev:execute{sql=[[COMMIT;]],live=true}
                                        transaction_completed = transaction_completed + 1
                                    else
                                        log_file:write(TIME_STAMP..csos_order_header_data[i].UNIQUE_TRANS_NUM..CSOS_ORD_HRD_AND_DETAILS_SQL_NOT_UPDATE_FAILURE,"\n")
                                        conn_dev:execute{sql=[[ROLLBACK;]],live=true}
                                    end  --end if 10
                                else
                                    log_file:write(TIME_STAMP..csos_order_header_data[i].UNIQUE_TRANS_NUM.." - Response from the soap is 'Y'","\n")
                                    transaction_not_completed = transaction_not_completed + 1
                                end  --end if 9
                              else
                               log_file:write(TIME_STAMP..csos_order_header_data[i].UNIQUE_TRANS_NUM..DETAILS_MISS_MATCH,"\n")
                               transaction_not_completed = transaction_not_completed + 1
	                       end  -- end if 8
                               else
                                log_file:write(TIME_STAMP..csos_order_header_data[i].UNIQUE_TRANS_NUM.." - Data is not available from csos_order_details table","\n")
                                transaction_not_completed = transaction_not_completed + 1
                            end -- end if 14
                            else
                                log_file:write(TIME_STAMP..csos_order_header_data[i].UNIQUE_TRANS_NUM.." - Data is not available from prod table","\n")
                                transaction_not_completed = transaction_not_completed + 1
                            end -- end if 13                     
                        else
                            log_file:write(TIME_STAMP..csos_order_header_data[i].UNIQUE_TRANS_NUM..ORDER_DETAILS_EMPTY,"\n")
                            transaction_not_completed = transaction_not_completed + 1
                        end  --end if 6

                    else
                        log_file:write(TIME_STAMP..csos_order_header_data[i].UNIQUE_TRANS_NUM..HEADERS_MISS_MATCH,"\n")
                        transaction_not_completed = transaction_not_completed + 1
                    end  --end if 5
                else
                    log_file:write(TIME_STAMP..CSOS_ORDER_HEADER_EMPTY,"\n")
                    transaction_not_completed = transaction_not_completed + 1
                end   --end if 4
                log_file:write(TIME_STAMP..csos_order_header_data[i].UNIQUE_TRANS_NUM.." is completed ****","\n")
            end  --end for 1
            log_file:write(TIME_STAMP.."Total transactions : "..#csos_order_header_data,"\n")
            log_file:write(TIME_STAMP.."Total transactions are completed : "..transaction_completed,"\n")
            if(transaction_not_completed > 0) then
               log_file:write(TIME_STAMP.."Total transactions are not completed : "..transaction_not_completed,"\n")
	            mail.send_email()
            end
       else
            log_file:write(TIME_STAMP..csos_order_header_data[i].UNIQUE_TRANS_NUM..CSOS_ORDER_HEADER_EMPTY,"\n")
        end  --end if 3
    else
        log_file:write(TIME_STAMP.."_"..DB_CON_ERROR,"\n")
        mail.send_email()
    end  --end if 2
    log_file:write(TIME_STAMP.."*** Iguana channel 2 is stopped ***","\n")
end

function getLogFile(output_log_path)  -- function getLogFile
    result_LogFileDirectory_Status=os.fs.access(output_log_path)
    if(result_LogFileDirectory_Status==false) then  --if 11 -- checking for directory exist or not
        os.fs.mkdir(output_log_path)
    end   --end if 11
    log_file_with_today_date = "logs_2nd_channel_"..os.date("%Y-%m-%d")..".txt" --Today Date
    local log_file_verify=io.open(output_log_path..log_file_with_today_date,'r')
    if log_file_verify~=nil then  --if 12
        io.close(log_file_verify)
        return io.open(output_log_path..log_file_with_today_date,'a+')
    else
        return io.open(output_log_path..log_file_with_today_date,'w')
    end  --end if 12
end  --end function getLogFile


function DBConn() --function DBConn
    return conn:check()
end  --end function DBConn


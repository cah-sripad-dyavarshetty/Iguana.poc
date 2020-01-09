    constants = require("Constants")
    properties = require("properties")
    Validation = require("Validation")



    constants.csos_order_header_size()
    properties.directory_path()
    properties.db_conn()

function getLogFile(output_log_path)  -- function getLogFile
    result_LogFileDirectory_Status=os.fs.access(output_log_path)
    if(result_LogFileDirectory_Status==false) then  --if 11 -- checking for directory exist or not
        os.fs.mkdir(output_log_path)
    end   --end if 11
    log_file_with_today_date = "logs_Arcos_Delete_Data_DB "..os.date("%Y-%m-%d")..".txt" --Today Date
    print(log_file_with_today_date)
    local log_file_verify=io.open(output_log_path..log_file_with_today_date,'r')
    if log_file_verify~=nil then  --if 12
        io.close(log_file_verify)
        return io.open(output_log_path..log_file_with_today_date,'a+')
    else
        return io.open(output_log_path..log_file_with_today_date,'w')
    end  --end if 12
end  --end function getLogFile


log_file = getLogFile(output_log_path)    --calling the geLogFile function
log_file:write(TIME_STAMP..CHANNEL_STARTED_RUNNING,"\n")


function main()
    --  table={1,2,3,4,5}
    --  print(table[1])
    if pcall(verify_Directory_Status) then -- if 1
        if pcall(Verify_DBConn) then   --if 2  --handling exception for database connection
            --for i=1,5 do
            ts=os.time()
            DATE_VALUE=os.date('%Y-%m-%d %H:%M:%S',ts)
            print(DATE_VALUE)
            if pcall(Validation.validate_string_value,DATE_VALUE,PO_DATE) then  --if 4
                validate_string_value_status=Validation.validate_string_value(DATE_VALUE,PO_DATE)

                if (validate_string_value_status==true)  then  --if 99
              --      if pcall(create_Procedure) then  --if 5
                        if pcall(Deletion) then  --if 6
                        -- log_file:write(TIME_STAMP.." - "..INSERT_SUCCESS,"\n")   --checking
                        else
                            log_file:write(TIME_STAMP.."_".."-*-*-*-*-*-*-Detetion Successfull-*-*-*-*-*-*-","\n")
                        end  --if 6
               -- else
               --     log_file:write(TIME_STAMP.."_".."procedure creation failed","\n")
               -- end  --if 5
               
                else
                    log_file:write(TIME_STAMP.."_".."VALIDATION FAILED","\n")
                end   -- if 99
            else
                log_file:write(TIME_STAMP.."_".."STRING VALIDATION FAILED","\n")
            end  --if 4

            -- end   --for end
    else
        log_file:write(TIME_STAMP.."_"..DB_CON_ERROR,"\n")
        --mail.send_email()
    end  --end if 2
    else
        log_file:write(TIME_STAMP.."_".."lOG FILES DIRECTORY DOES NOT EXIST","\n")
    end  --if 1
    log_file:write(TIME_STAMP.."***     Iguana Arcos_Delete_Data_DB stopped      ***","\n")
end





function Verify_DBConn()  --function for validating db connection
    return conn:check()
end

result_LogDirectory_Status=os.fs.access(output_log_path)

function verify_Directory_Status()

    if(result_LogDirectory_Status==false)   then   -- checking for directory exist or not
        log_file:write(TIME_STAMP..ARC_DIR_MISS,"\n") --checking
        os.fs.mkdir(output_log_path)
        log_file:write(TIME_STAMP..ARC_DIR_CREATE,"\n") --checking
        result_LogDirectory_Status=os.fs.access(output_log_path)
    end
end

function Deletion() 
   count=0
   miss_matched_data,matched_data,dummy_miss_matched_data={},{},{}
  csos_order_header_data=conn:query{sql="select CSOS_ORD_HDR_NUM from world.csos_order_header;",live=true};
   print(csos_order_header_data[1].CSOS_ORD_HDR_NUM)
   --print(csos_order_header_data[1].PO_DATE)
   --print(csos_order_header_data[1].CSOS_ORDER_HDR_STAT,csos_order_header_data[1].ACTIVE_FLG)
   --print(csos_order_header_data[1].ROW_ADD_STP,csos_order_header_data[1].ROW_ADD_USER_ID)
  
   csos_order_header_dummy_data=conn:query{sql="select CSOS_ORD_HDR_NUM from world.csos_order_header_dummy;", live=true};
  
   length_csos_order_header_dummy_data=#csos_order_header_dummy_data
   for j=1,length_csos_order_header_dummy_data do
      print(csos_order_header_data[j].CSOS_ORD_HDR_NUM,csos_order_header_dummy_data[j].CSOS_ORD_HDR_NUM)
                    if(tostring(csos_order_header_data[j].CSOS_ORD_HDR_NUM)==tostring(csos_order_header_dummy_data[j].CSOS_ORD_HDR_NUM)) then
         print(csos_order_header_data[j].CSOS_ORD_HDR_NUM)               
         matched_data[j]=csos_order_header_data[j].CSOS_ORD_HDR_NUM
                    else
         count=count+1
                        miss_matched_data[count]=csos_order_header_dummy_data[j].CSOS_ORD_HDR_NUM
                    end
   end
    print(miss_matched_data,matched_data,#miss_matched_data)
   
   if(#miss_matched_data==0) then
     log_file:write(TIME_STAMP.."*-*-Detetion Failed as there is NO data which is MISS_MATCHED-*-*","\n")
      end
   if(#miss_matched_data>0) then
      log_file:write(TIME_STAMP.."*-*-*-*-*-*-*-*-Detetion Successfull-*-*-*-*-*-*-*-*","\n")
      end
   for k=1,count do
   deletion_status=conn:query{sql="delete from csos_order_header_dummy where CSOS_ORD_HDR_NUM='"..miss_matched_data[k].."';",live=true};
   end
  
      
end

  
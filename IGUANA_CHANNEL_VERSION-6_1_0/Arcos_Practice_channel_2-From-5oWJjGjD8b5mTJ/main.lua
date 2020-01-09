-- The main function is the first function called from Iguana.
output_log_path= "C:\\ARCOS\\LogFiles\\"
TIME_STAMP=os.date('%x').." "..os.date('%X').." - "
CHANNEL_STARTED_RUNNING="******* Iguana Arcos practice channel Started Running *******"
DB_CON_ERROR="Database connection failed"
INSERT_SUCCESS="Successfully inserted data into database"
name='Sripad'
CSOS_ORD_HDR_NUM	= 19
PO_DATE	         = 45
ROW_ADD_USER_ID	   = 255 --varchar

--print(DATE_VALUE)
ACTIVE_FLG	      = "Y"
user_name= "Sripad"




function getLogFile(output_log_path)  -- function getLogFile
    result_LogFileDirectory_Status=os.fs.access(output_log_path)
    if(result_LogFileDirectory_Status==false) then  --if 11 -- checking for directory exist or not
        os.fs.mkdir(output_log_path)
    end   --end if 11
    log_file_with_today_date = "logs_Arcos_Practice_channe2_"..os.date("%Y-%m-%d")..".txt" --Today Date
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
        if pcall(DBConn) then   --if 2  --handling exception for database connection
            --for i=1,5 do
            ts=os.time()
            DATE_VALUE=os.date('%Y-%m-%d %H:%M:%S',ts)
            print(DATE_VALUE)
            if pcall(validate_string_value,DATE_VALUE,PO_DATE) then  --if 4
                validate_string_value_status=validate_string_value(DATE_VALUE,PO_DATE)

                if (validate_string_value_status==true)  then  --if 99
                    if pcall(create_Procedure) then  --if 5
                        if pcall(Insertion) then  --if 6
                        -- log_file:write(TIME_STAMP.." - "..INSERT_SUCCESS,"\n")   --checking
                        else
                            log_file:write(TIME_STAMP.."_".."Insertion failed","\n")
                    end  --if 6
                else
                    log_file:write(TIME_STAMP.."_".."procedure creation failed","\n")
                end  --if 5
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
    log_file:write(TIME_STAMP.."*** Iguana Arcos Practice channe2 stopped  ***","\n")
end

function DBconnection()
    if not conn_dev or conn_dev:check() then  --dev connection
        if conn_dev and conn_dev:check() then
            conn_dev:close() end
    conn_dev = db.connect{
        api=db.MY_SQL,
        name='world@localhost:3306',
        user='root',
        password='dSrip@d2489',
        use_unicode = true,
        live = true
    }
    end
end

function DBConn() --function DBConn
    if pcall(db_conn) then
        return conn:check()
else
    log_file:write(TIME_STAMP.."data base connection function failed ","\n")
end
end  --end function DBConn

function db_conn()
    if pcall(DBconnection) then
        -- conn = conn_stg
        conn = conn_dev
    else
        log_file:write(TIME_STAMP.."DATABASE CONNECTION FAILED ","\n")
    end
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



function validate_string_value(order_value_string,column_size_string) --validation of data present in order files
    if(order_value_string == nil) then
        return false
elseif(type(order_value_string)=='string' and #order_value_string<=column_size_string and #order_value_string>=0) then
    return true
else
    return false
end
end


function create_Procedure()
    conn:execute{sql='DROP PROCEDURE IF EXISTS Add_csos_order_header_data',live=true}  --procedure to insert data into csos_order_header
    conn:execute{sql=[[CREATE PROCEDURE Add_csos_order_header_data(
      IN PO_DATE VARCHAR(45),      
      IN ACTIVE_FLG char(1),
      IN ROW_ADD_STP	timestamp,
      IN ROW_ADD_USER_ID varchar(255)
   )
      BEGIN
      INSERT INTO csos_order_header(PO_DATE,ACTIVE_FLG,ROW_ADD_STP,ROW_ADD_USER_ID) 
      VALUES(PO_DATE,ACTIVE_FLG,ROW_ADD_STP,ROW_ADD_USER_ID);
     
   END]],
    live=true
    }


    conn:execute{sql='DROP PROCEDURE IF EXISTS Add_csos_order_header_data_dummy',live=true}  --procedure to insert data into csos_order_header
    conn:execute{sql=[[CREATE PROCEDURE Add_csos_order_header_data_dummy(
      IN CSOS_ORD_HDR_NUM VARCHAR(45),
      IN PO_DATE VARCHAR(45),      
      IN ACTIVE_FLG char(1),
      IN ROW_ADD_STP	timestamp,
      IN ROW_ADD_USER_ID varchar(255)
   )
      BEGIN
      INSERT INTO csos_order_header_dummy(CSOS_ORD_HDR_NUM,PO_DATE,ACTIVE_FLG,ROW_ADD_STP,ROW_ADD_USER_ID) 
      VALUES(CSOS_ORD_HDR_NUM,PO_DATE,ACTIVE_FLG,ROW_ADD_STP,ROW_ADD_USER_ID);
     
   END]],
    live=true
    }

end

function Insertion()
    insertion_status = false
    --for i=1,2 do
    conn:execute{sql=[[START TRANSACTION;]] ,live=true};
    --insertion is done into csos_order_header
    sql_a = "CALL Add_csos_order_header_data("..
        conn:quote(DATE_VALUE)..", "..
        conn:quote(ACTIVE_FLG)..", "..
        conn:quote( DATE_VALUE)..", "..
        conn:quote(user_name)..
        ")"



    sql_a_status = conn:execute{sql=sql_a, live=true};
    print(sql_a_status)
    conn:execute{sql="select * from world.csos_order_header;",live=true};
    if(sql_a_status == nil) then
        result_csos_order_header=conn:query{sql="select * from world.csos_order_header;", live=true};
        result_Max=conn:query{sql="select MAX(CSOS_ORD_HDR_NUM) from world.csos_order_header;", live=true};
        result_Max_VAL=tostring(result_Max[1]["max(CSOS_ORD_HDR_NUM)"])
        print(result_csos_order_header[1].CSOS_ORD_HDR_NUM,result_csos_order_header[1].PO_DATE,result_csos_order_header[1].ROW_ADD_USER_ID)
        print(result_csos_order_header[1].ACTIVE_FLG,result_csos_order_header[1].ROW_ADD_STP)
        insertion_status = true

    else
        insertion_status = false
    end
    if (result_csos_order_header ~= nil and insertion_status == true) then
        sql_a_status = nil
        sql_b = "CALL Add_csos_order_header_data_dummy ("..
            conn:quote(result_Max_VAL)..", "..
            conn:quote(tostring(result_csos_order_header[#result_csos_order_header].PO_DATE))..", "..
            conn:quote(tostring(result_csos_order_header[#result_csos_order_header].ACTIVE_FLG))..", "..
            conn:quote(tostring(result_csos_order_header[#result_csos_order_header].ROW_ADD_STP))..", "..
            conn:quote(tostring(result_csos_order_header[#result_csos_order_header].ROW_ADD_USER_ID))..
            ")"

        sql_b_status = conn:execute{sql=sql_b, live=true};
        print(sql_b_status)
        print(insertion_status)
        if(sql_b_status == nil) then
            insertion_status = true
        else
            insertion_status = false
        end
    else
        insertion_status = false
    end
    if(insertion_status == true) then
        conn:execute{sql=[[COMMIT;]],live=true}
        log_file:write(TIME_STAMP.." - "..INSERT_SUCCESS,"\n")   --checking
    else
        conn:execute{sql=[[ROLLBACK;]],live=true}
        log_file:write(TIME_STAMP.."_".."Insertion failed","\n")
    end
    -- end  -- for  loop
end
   
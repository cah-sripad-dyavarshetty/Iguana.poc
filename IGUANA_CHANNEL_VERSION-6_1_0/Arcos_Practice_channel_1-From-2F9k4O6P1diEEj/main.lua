-- The main function is the first function called from Iguana.
output_log_path= "C:\\ARCOS\\LogFiles\\"
TIME_STAMP=os.date('%x').." "..os.date('%X').." - "
CHANNEL_STARTED_RUNNING="******* Iguana Arcos practice channel Started Running *******"
DB_CON_ERROR="Database connection failed"
INSERT_SUCCESS="Successfully inserted data into database using Arcos_Practice_channel 1"
sum,name=0,'Sripad'
column_size_string=11
column_size_number=6


function getLogFile(output_log_path)  -- function getLogFile
    result_LogFileDirectory_Status=os.fs.access(output_log_path)
    if(result_LogFileDirectory_Status==false) then  --if 11 -- checking for directory exist or not
        os.fs.mkdir(output_log_path)
    end   --end if 11
    log_file_with_today_date = "logs_Arcos_Practice_channel_"..os.date("%Y-%m-%d")..".txt" --Today Date
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
    table={1,2,3,4,5}
    print(table[1])
    if pcall(verify_Directory_Status) then -- if 1
        if pcall(DBConn) then   --if 2  --handling exception for database connection
            for i=1,5 do
                if pcall(validate_number_value,sum,column_size_number) then   --if 3
                    if pcall(validate_string_value,name,column_size_string) then  --if 4
                        validate_string_value_status=validate_string_value(name,column_size_string)
                        validate_number_value_status=validate_number_value(sum,column_size_number)
                        if (validate_string_value_status==true and validate_number_value_status==true)  then  --if 99
                            if pcall(create_Procedure) then  --if 5

                                if pcall(Insertion,i) then  --if 6
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
                else
                    log_file:write(TIME_STAMP.."_".."NUMBER VALIDATION FAILED","\n")
                end  --if 3
        end   --for end
    else
        log_file:write(TIME_STAMP.."_"..DB_CON_ERROR,"\n")
        --mail.send_email()
    end  --end if 2
    else
        log_file:write(TIME_STAMP.."_".."lOG FILES DIRECTORY DOES NOT EXIST","\n")
    end  --if 1
    log_file:write(TIME_STAMP.."*** Iguana Arcos Practice channel stopped  ***","\n")
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


function create_Procedure()
    conn:execute{sql='DROP PROCEDURE IF EXISTS Adddata',live=true}  --procedure to insert data into csos_order_header
    conn:execute{sql=[[CREATE PROCEDURE Adddata(
      IN id int(11),      
      IN val text
   )
      BEGIN
      INSERT INTO a(id,val) 
      VALUES(id,val);
     
   END]],
    live=true
    }


    conn:execute{sql='DROP PROCEDURE IF EXISTS Adddata2',live=true}  --procedure to insert data into csos_order_header
    conn:execute{sql=[[CREATE PROCEDURE Adddata2(
      IN id int(11),            
      IN val text
   )
      BEGIN
      INSERT INTO b(id,val) 
      VALUES(id,val);
     
   END]],
    live=true
    }

end

function Insertion(i)
    insertion_status = false

    --for i=1,2 do
    conn:execute{sql=[[START TRANSACTION;]] ,live=true};
    --insertion is done into csos_order_header
    sql_a = "CALL Adddata("..
        conn:quote(tostring(table[i]))..", "..
        conn:quote(tostring(name))..
        ")"
    sql_a_status = conn:execute{sql=sql_a, live=true};
    print(sql_a_status)
    conn:execute{sql="select * from world.a;",live=true};
    if(sql_a_status ==nil) then
        result_a=conn:query{sql="select * from world.a;", live=true};
        print(result_a[i].id,result_a[i].val)
        insertion_status = true
    else
        insertion_status = false
    end
    if (result_a~=nil and insertion_status == true) then
        sql_a_status = nil
        sql_b = "CALL Adddata2 ("..
            conn:quote(tostring(result_a[i].id))..", "..
            conn:quote(tostring(result_a[i].val))..
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


function validate_number_value(i,column_size_number) --validation of data present in order files
    if(i == nil) then
        return false
elseif(type(i)=='number' and i<=column_size_number and i>=0) then
    return true
else
    return false
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
   
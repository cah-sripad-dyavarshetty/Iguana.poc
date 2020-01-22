-- The main function is the first function called from Iguana.
function main()

    Constants = require("Constants")
    Properties = require("Properties")
    Validation = require("Validation")
    Procedure=require("Stored_Procedures")
    dbConnection = require("DBConnection")    


    Constants.csos_order_header_size()
    Properties.directory_path()
    Properties.db_conn()
    Procedure.firstProcedure()
    dbConnection.connectdb()

    log_file = getLogFile(output_log_path)    --calling the geLogFile function
    log_file:write(TIME_STAMP..CHANNEL_STARTED_RUNNING,"\n")
   
   
    if pcall(verify_Directory_Status) then  -- if 1
        if pcall(Verify_DBConn_Elite) then    --if 2
            if pcall(Verify_DBConn_Arcos) then  --if 3

            
            
            
            
            
            
            

            else
                log_file:write(TIME_STAMP..DB_CON_ERROR_ARCOS,"\n")
            end  --end if 3
        else
                log_file:write(TIME_STAMP..DB_CON_ERROR_ELITE,"\n")
        end  --end if 2
    else
        log_file:write(TIME_STAMP..LOG_DIR_MISS,"\n")
    end  --end if 1
    log_file:write(TIME_STAMP..CHANNEL_STOPPED_RUNNING,"\n\n")
   
end  ---end main function



function Verify_DBConn_Elite()  --function for validating db connection
    return conn_Elite:check()
end  --end Verify_DBConn_Elite() function



function Verify_DBConn_Arcos()  --function for validating db connection
    return conn_Arocs:check()
end  --end Verify_DBConn_Arcos() function



function verify_Directory_Status()  --function for verifying directory status

    if(result_LogDirectory_Status==false)   then   -- checking for directory exist or not   --if 99
        log_file:write(TIME_STAMP..LOG_DIR_MISS,"\n") --checking
        os.fs.mkdir(output_log_path)
        log_file:write(TIME_STAMP..LOG_DIR_CREATE,"\n") --checking
        result_LogDirectory_Status=os.fs.access(output_log_path)
end  --end if 99
end   --end verify_Directory_Status()



function getLogFile(output_log_path)  -- function getLogFile
    result_LogFileDirectory_Status=os.fs.access(output_log_path)
    if(result_LogFileDirectory_Status==false) then  --if 51 -- checking for directory exist or not
        os.fs.mkdir(output_log_path)
    end   --end if 51
    log_file_with_today_date = "logs_Import_Scheduled_Items_ "..os.date("%Y-%m-%d")..".txt" --lOG file name with Today Date
    print(log_file_with_today_date)
    local log_file_verify=io.open(output_log_path..log_file_with_today_date,'r')
    if log_file_verify~=nil then  --if 52
        io.close(log_file_verify)
        return io.open(output_log_path..log_file_with_today_date,'a+')
    else
        return io.open(output_log_path..log_file_with_today_date,'w')
    end  --end if 52
end  --end function getLogFile



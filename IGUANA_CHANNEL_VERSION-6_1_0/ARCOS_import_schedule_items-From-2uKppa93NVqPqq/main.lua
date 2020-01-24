-- The main function is the first function called from Iguana.
function main()

    Constants = require("Constants")
    --Properties = require("Properties")
    Validation = require("Validation")
    Procedure=require("Stored_Procedures")
   dbConnection = require("DBConnection")
   dbConnection.connectdb()
    Constants.csos_order_header_size()
   -- Properties.directory_path()
   -- Properties.db_conn()
    Procedure.firstProcedure()
    

    log_file = getLogFile(output_log_path)    --calling the geLogFile function
    log_file:write(TIME_STAMP..CHANNEL_STARTED_RUNNING,"\n")
   
   
    if pcall(verify_Directory_Status) then  -- if 1
        if pcall(Verify_DBConn_Elite) then    --if 2
            if pcall(Verify_DBConn_Arcos) then  --if 3
             --    if pcall(Verify_DBConn_Arcos_stg) then
            val=52136447
   
         conn_Elite_dev:execute{sql="select * from prod_841_d.ord_hold where ord_id = '"..val.."'",live=true};            
          
       -- query1=conn_Elite_stg:query{sql=[[select prod_841_d.item.ITEM_NUM from prod_841_d.item]],live=true};    
        --     print(query1)
          
            
  
            
             sql2=[[SELECT DISTINCT prod_841_D.Item.ITEM_NUM, prod_841_D.Item_CE.IS_LICENSE_REQ AS Lic_reqd, prod_841_D.Item_LICENSE_CE.DEA_SCHEDULE_LIST, 
prod_841_D.Item_LICENSE_CE.LICENSE_TYPE, prod_841_D.Item_2.BACCS, prod_841_D.Item_2.BREAK_CODE,
prod_841_D.Item_2.USE_BREAK_CODE, prod_841_D.Item.UPC, prod_841_D.Item.DESC_1, 
decode(trim(prod_841_D.Item_LICENSE_CE.DEA_SCHEDULE_LIST),'I','Y','N') AS Sched1, 
decode(trim(prod_841_D.Item_LICENSE_CE.DEA_SCHEDULE_LIST),'II','Y','N') AS Sched2, 
decode(trim(prod_841_D.Item_LICENSE_CE.DEA_SCHEDULE_LIST),'III','Y','N') AS Sched3, 
decode(trim(prod_841_D.Item_LICENSE_CE.DEA_SCHEDULE_LIST),'IV','Y','N') AS Sched4, 
decode(trim(prod_841_D.Item_LICENSE_CE.DEA_SCHEDULE_LIST),'V','Y','N') AS Sched5, 
decode(trim(prod_841_D.Item_LICENSE_CE.DEA_SCHEDULE_LIST),'VI','Y','N') AS Sched6, 
decode(trim(prod_841_D.Item_LICENSE_CE.DEA_SCHEDULE_LIST),'VII','Y','N') AS Sched7, 
decode(trim(prod_841_D.Item_LICENSE_CE.DEA_SCHEDULE_LIST),'VIII','Y','N') AS Sched8, 
' ' AS contr_subst 
FROM ((prod_841_D.Item INNER JOIN prod_841_D.Item_CE ON prod_841_D.Item.ITEM_NUM = prod_841_D.Item_CE.ITEM_NUM) 
INNER JOIN prod_841_D.Item_LICENSE_CE ON prod_841_D.Item.ITEM_NUM = prod_841_D.Item_LICENSE_CE.ITEM_NUM) 
INNER JOIN prod_841_D.Item_2 ON prod_841_D.Item.ITEM_NUM = prod_841_D.Item_2.ITEM_NUM
WHERE (
              ( prod_841_D.Item.ITEM_NUM = prod_841_D.Item_CE.ITEM_NUM ) And ( prod_841_D.Item.ITEM_NUM = prod_841_D.Item_LICENSE_CE.ITEM_NUM )  
              AND ( prod_841_D.Item_LICENSE_CE.DEA_SCHEDULE_LIST='I' )   AND ( prod_841_D.Item_2.ITEM_NUM=prod_841_D.Item.ITEM_NUM )
      )
      OR 
      (
              ( prod_841_D.Item.ITEM_NUM = prod_841_D.Item_CE.ITEM_NUM ) And ( prod_841_D.Item.ITEM_NUM = prod_841_D.Item_LICENSE_CE.ITEM_NUM )  
              AND ( prod_841_D.Item_LICENSE_CE.DEA_SCHEDULE_LIST='II' )   AND ( prod_841_D.Item_2.ITEM_NUM=prod_841_D.Item.ITEM_NUM )
      )
      OR
      (
              ( prod_841_D.Item.ITEM_NUM = prod_841_D.Item_CE.ITEM_NUM ) And ( prod_841_D.Item.ITEM_NUM = prod_841_D.Item_LICENSE_CE.ITEM_NUM )  
              AND ( prod_841_D.Item_LICENSE_CE.DEA_SCHEDULE_LIST='IIN' )   AND ( prod_841_D.Item_2.ITEM_NUM=prod_841_D.Item.ITEM_NUM )
      )
      OR
      (
              ( prod_841_D.Item.ITEM_NUM = prod_841_D.Item_CE.ITEM_NUM ) And ( prod_841_D.Item.ITEM_NUM = prod_841_D.Item_LICENSE_CE.ITEM_NUM )  
              AND ( prod_841_D.Item_LICENSE_CE.DEA_SCHEDULE_LIST='III' )   AND ( prod_841_D.Item_2.ITEM_NUM=prod_841_D.Item.ITEM_NUM )
      )
       OR
      (
              ( prod_841_D.Item.ITEM_NUM = prod_841_D.Item_CE.ITEM_NUM ) And ( prod_841_D.Item.ITEM_NUM = prod_841_D.Item_LICENSE_CE.ITEM_NUM )  
              AND ( prod_841_D.Item_LICENSE_CE.DEA_SCHEDULE_LIST='IIIN' )   AND ( prod_841_D.Item_2.ITEM_NUM=prod_841_D.Item.ITEM_NUM )
      )
       OR
      (
              ( prod_841_D.Item.ITEM_NUM = prod_841_D.Item_CE.ITEM_NUM ) And ( prod_841_D.Item.ITEM_NUM = prod_841_D.Item_LICENSE_CE.ITEM_NUM )  
              AND ( prod_841_D.Item_LICENSE_CE.DEA_SCHEDULE_LIST='IV' )   AND ( prod_841_D.Item_2.ITEM_NUM=prod_841_D.Item.ITEM_NUM )
      )
       OR
      (
              ( prod_841_D.Item.ITEM_NUM = prod_841_D.Item_CE.ITEM_NUM ) And ( prod_841_D.Item.ITEM_NUM = prod_841_D.Item_LICENSE_CE.ITEM_NUM )  
              AND ( prod_841_D.Item_LICENSE_CE.DEA_SCHEDULE_LIST='V' )   AND ( prod_841_D.Item_2.ITEM_NUM=prod_841_D.Item.ITEM_NUM )
      )
       OR
      (
              ( prod_841_D.Item.ITEM_NUM = prod_841_D.Item_CE.ITEM_NUM ) And ( prod_841_D.Item.ITEM_NUM = prod_841_D.Item_LICENSE_CE.ITEM_NUM )  
              AND ( prod_841_D.Item_LICENSE_CE.DEA_SCHEDULE_LIST is null )   AND ( prod_841_D.Item_2.ITEM_NUM=prod_841_D.Item.ITEM_NUM )
      )
      ]]
            
            
            
            query2=conn_Elite_dev:query{sql=sql2,live=true};
            print(query2)
            
            
          
            
            
            sql3=[[          SELECT DISTINCT prod_841_D.Item.ITEM_NUM, prod_841_D.Item_CE.IS_LICENSE_REQ AS Lic_reqd,
          prod_841_D.Item_LICENSE_CE.DEA_SCHEDULE_LIST, 
          prod_841_D.Item_LICENSE_CE.LICENSE_TYPE,
          prod_841_D.Item_2.BACCS, prod_841_D.Item_2.BREAK_CODE,
          prod_841_D.Item_2.USE_BREAK_CODE, prod_841_D.Item.UPC, prod_841_D.Item.DESC_1, 
          decode(trim(prod_841_D.Item_LICENSE_CE.DEA_SCHEDULE_LIST),'I','Y','N') AS Sched1, 
          decode(trim(prod_841_D.Item_LICENSE_CE.DEA_SCHEDULE_LIST),'II','Y','N') AS Sched2, 
          decode(trim(prod_841_D.Item_LICENSE_CE.DEA_SCHEDULE_LIST),'III','Y','N') AS Sched3, 
          decode(trim(prod_841_D.Item_LICENSE_CE.DEA_SCHEDULE_LIST),'IV','Y','N') AS Sched4, 
          decode(trim(prod_841_D.Item_LICENSE_CE.DEA_SCHEDULE_LIST),'V','Y','N') AS Sched5, 
          decode(trim(prod_841_D.Item_LICENSE_CE.DEA_SCHEDULE_LIST),'VI','Y','N') AS Sched6, 
          decode(trim(prod_841_D.Item_LICENSE_CE.DEA_SCHEDULE_LIST),'VII','Y','N') AS Sched7, 
          decode(trim(prod_841_D.Item_LICENSE_CE.DEA_SCHEDULE_LIST),'VIII','Y','N') AS Sched8, 
          ' ' AS contr_subst 
          FROM ((prod_841_D.Item INNER JOIN prod_841_D.Item_CE ON prod_841_D.Item.ITEM_NUM = prod_841_D.Item_CE.ITEM_NUM) 
          INNER JOIN prod_841_D.Item_LICENSE_CE ON prod_841_D.Item.ITEM_NUM = prod_841_D.Item_LICENSE_CE.ITEM_NUM) 
          INNER JOIN prod_841_D.Item_2 ON prod_841_D.Item.ITEM_NUM = prod_841_D.Item_2.ITEM_NUM
          WHERE (
                        ( prod_841_D.Item.ITEM_NUM = prod_841_D.Item_CE.ITEM_NUM ) And ( prod_841_D.Item.ITEM_NUM = prod_841_D.Item_LICENSE_CE.ITEM_NUM )  
                        AND ( prod_841_D.Item_LICENSE_CE.DEA_SCHEDULE_LIST='I' )   AND ( prod_841_D.Item_2.ITEM_NUM=prod_841_D.Item.ITEM_NUM )
                )
                OR 
                (
                        ( prod_841_D.Item.ITEM_NUM = prod_841_D.Item_CE.ITEM_NUM ) And ( prod_841_D.Item.ITEM_NUM = prod_841_D.Item_LICENSE_CE.ITEM_NUM )  
                        AND ( prod_841_D.Item_LICENSE_CE.DEA_SCHEDULE_LIST='II' )   AND ( prod_841_D.Item_2.ITEM_NUM=prod_841_D.Item.ITEM_NUM )
                )
                OR
                (
                        ( prod_841_D.Item.ITEM_NUM = prod_841_D.Item_CE.ITEM_NUM ) And ( prod_841_D.Item.ITEM_NUM = prod_841_D.Item_LICENSE_CE.ITEM_NUM )  
                        AND ( prod_841_D.Item_LICENSE_CE.DEA_SCHEDULE_LIST='IIN' )   AND ( prod_841_D.Item_2.ITEM_NUM=prod_841_D.Item.ITEM_NUM )
                )
                OR
                (
                        ( prod_841_D.Item.ITEM_NUM = prod_841_D.Item_CE.ITEM_NUM ) And ( prod_841_D.Item.ITEM_NUM = prod_841_D.Item_LICENSE_CE.ITEM_NUM )  
                        AND ( prod_841_D.Item_LICENSE_CE.DEA_SCHEDULE_LIST='III' )   AND ( prod_841_D.Item_2.ITEM_NUM=prod_841_D.Item.ITEM_NUM )
                )
                 OR
                (
                        ( prod_841_D.Item.ITEM_NUM = prod_841_D.Item_CE.ITEM_NUM ) And ( prod_841_D.Item.ITEM_NUM = prod_841_D.Item_LICENSE_CE.ITEM_NUM )  
                        AND ( prod_841_D.Item_LICENSE_CE.DEA_SCHEDULE_LIST='IIIN' )   AND ( prod_841_D.Item_2.ITEM_NUM=prod_841_D.Item.ITEM_NUM )
                )
                 OR
                (
                        ( prod_841_D.Item.ITEM_NUM = prod_841_D.Item_CE.ITEM_NUM ) And ( prod_841_D.Item.ITEM_NUM = prod_841_D.Item_LICENSE_CE.ITEM_NUM )  
                        AND ( prod_841_D.Item_LICENSE_CE.DEA_SCHEDULE_LIST='IV' )   AND ( prod_841_D.Item_2.ITEM_NUM=prod_841_D.Item.ITEM_NUM )
                )
                 OR
                (
                        ( prod_841_D.Item.ITEM_NUM = prod_841_D.Item_CE.ITEM_NUM ) And ( prod_841_D.Item.ITEM_NUM = prod_841_D.Item_LICENSE_CE.ITEM_NUM )  
                        AND ( prod_841_D.Item_LICENSE_CE.DEA_SCHEDULE_LIST='V' )   AND ( prod_841_D.Item_2.ITEM_NUM=prod_841_D.Item.ITEM_NUM )
                )
                 OR
                (
                        ( prod_841_D.Item.ITEM_NUM = prod_841_D.Item_CE.ITEM_NUM ) And ( prod_841_D.Item.ITEM_NUM = prod_841_D.Item_LICENSE_CE.ITEM_NUM )  
                        AND ( prod_841_D.Item_LICENSE_CE.DEA_SCHEDULE_LIST is null )   AND ( prod_841_D.Item_2.ITEM_NUM=prod_841_D.Item.ITEM_NUM )
                )
                and
            
            ( prod_841_D.Item.DESC_1 not Like '%DO NOT USE%' and prod_841_D.Item.DESC_1 not Like 'DISPOSAL%' )
      
]]
      
      
      
      

            
            
            elite_data=conn_Elite_dev:query{sql=sql3,live=true};
            print(elite_data,elite_data[1].ITEM_NUM,elite_data[1].LIC_REQD,elite_data[1].DEA_SCHEDULE_LIST)
            print(elite_data[1].LICENSE_TYPE,elite_data[1].BACCS,elite_data[1].BREAK_CODE,elite_data[1].UPC)
            
           
           Arcos_data = conn_Arcos_stg:query{sql = "SELECT * FROM ArcosMDB.dbo.ScheduleItems;",live=true};

               if(Arcos_data~=nil) then  --if 31
               for i=1,#elite_data do
                  
               if(Arcos_data[i].ITEM_NUM == elite_data[i].ITEM_NUM and 
                     Arcos_data[i].LIC_REQD == elite_data[i].LIC_REQD and
                     Arcos_data[i].DEA_SCHEDULE_LIST == elite_data[i].DEA_SCHEDULE_LIST and
                     Arcos_data[i].LICENSE_TYPE == elite_data[i].LICENSE_TYPE and 
                     Arcos_data[i].BACCS == elite_data[i].BACCS and
                     Arcos_data[i].BREAK_CODE == elite_data[i].BREAK_CODE and 
                     Arcos_data[i].UPC == elite_data[i].UPC 
                  )   then --if 32
                  
                  log_file:write(TIME_STAMP.."        for ITEM_NUM"..Arcos_data[1].ITEM_NUM.."there is no change in Arcosdatabase","\n")
                  
                else
                  
                 --conn_Arcos_stg:query{sql = "UPDATE TempSchedItems_ORA INNER JOIN ScheduleItems ON TempSchedItems_ORA.ITEM_NUM = ScheduleItems.item_num SET TempSchedItems_ORA.ITEM_NUM = Null;",live=true}; 
                  
                end  --end if 32
                   end  --for 
            else 
               
                -- conn_Arcos_stg:query{sql ="INSERT INTO ScheduleItems ( item_num, lic_reqd, baccs, break_code, use_break_code, upc, desc_1, sched1, sched2, sched3, sched4, sched5, sched6, sched7, sched8 );",live=true}; 
               
            end  --end if 31
           
        
            
            
            
            
            
     
            
       --  conn_Arcos_stg:execute{sql="select * from dbo.EMP",live=true};  
            
               else
                   log_file:write(TIME_STAMP..DB_CON_ERROR_ARCOS_STG,"\n")
               end
           -- else
          --      log_file:write(TIME_STAMP..DB_CON_ERROR_ARCOS,"\n")
           --- end  --end if 3
        else
                log_file:write(TIME_STAMP..DB_CON_ERROR_ELITE,"\n")
        end  --end if 2
    else
        log_file:write(TIME_STAMP..LOG_DIR_MISS,"\n")
    end  --end if 1
    log_file:write(TIME_STAMP..CHANNEL_STOPPED_RUNNING,"\n\n")
   
end  ---end main function



function Verify_DBConn_Elite()  --function for validating db connection
    return conn_Elite_dev:check()
end  --end Verify_DBConn_Elite() function



function Verify_DBConn_Arcos()  --function for validating db connection
    return conn_Arcos_stg:check()
end  --end Verify_DBConn_Arcos() function

function Verify_DBConn_Arcos_stg()  --function for validating db connection
    return conn_Arocs_stage:check()
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



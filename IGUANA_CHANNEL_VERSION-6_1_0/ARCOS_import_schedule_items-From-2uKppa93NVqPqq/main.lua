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

                


            elite_data = conn_Elite_dev:query{sql=sql_query,live=true};

       --[[     Arcos_data = conn_Arcos_stg:query{sql = "SELECT * FROM ArcosMDB.dbo.ScheduleItems;",live=true};

            for i=1,#elite_data do   --for 1
               for j=1,#Arcos_data do  --for 2
                 if(elite_data[i].ITEM_NUM == Arcos_data[j].ITEM_NUM) then  --if 31   
                     print("hello")
                     if( elite_data[i].LIC_REQD == Arcos_data[j].lic_reqd and
                     elite_data[i].DEA_SCHEDULE_LIST == Arcos_data[j].DEA_Schedule_List and
                     elite_data[i].LICENSE_TYPE == Arcos_data[j].License_type and 
                     elite_data[i].BACCS == Arcos_data[j].baccs and
                     elite_data[i].BREAK_CODE == Arcos_data[j].break_code and 
                     elite_data[i].UPC == Arcos_data[j].upc and
                     elite_data[i].USE_BREAK_CODE == Arcos_data[j].use_break_code and
                     elite_data[i].DESC_1 == Arcos_data[j].desc_1 and
                     elite_data[i].SCHED1 == Arcos_data[j].sched1 and
                     elite_data[i].SCHED2 == Arcos_data[j].sched2 and
                     elite_data[i].SCHED3 == Arcos_data[j].sched2 and
                     elite_data[i].SCHED4 == Arcos_data[j].sched2 and
                     elite_data[i].SCHED5 == Arcos_data[j].sched2 and
                     elite_data[i].SCHED6 == Arcos_data[j].sched2 and
                     elite_data[i].SCHED7 == Arcos_data[j].sched2 and
                     elite_data[i].SCHED8 == Arcos_data[j].sched2 and
                     elite_data[i].CONTR_SUBST == Arcos_data[j].contr_subst
                           
                     )  then --if 32
                  
                          log_file:write(TIME_STAMP.."        for ITEM_NUM"..Arcos_data[j].ITEM_NUM.."there is no change in Arcosdatabase","\n")                  
                  
                     else           
                           --conn_Arcos_stg:query{sql = "UPDATE TempSchedItems_ORA INNER JOIN ScheduleItems ON TempSchedItems_ORA.ITEM_NUM = ScheduleItems.item_num SET TempSchedItems_ORA.ITEM_NUM = Null;",live=true};                   
                           log_file:write(TIME_STAMP.."        for ITEM_NUM : "..Arcos_data[j].ITEM_NUM.."there needs to be some updation done in Arcos database","\n")                           
                     end  --end if 32                  
                 else       
                      if (j==#Arcos_data) then    --if 33
                           -- conn_Arcos_stg:query{sql ="INSERT INTO ScheduleItems ( item_num, lic_reqd, baccs, break_code, use_break_code, upc, desc_1, sched1, sched2, sched3, sched4, sched5, sched6, sched7, sched8 );",live=true};                
                           log_file:write(TIME_STAMP.."        for ITEM_NUM : "..Arcos_data[j].ITEM_NUM.."there needs to be some insertion done in Arcos database","\n")  
                      end     --end if 33
                 end  --end if 31                  
          end  -- for 2
        end --for 1
            
       ]]--    
            
        
     
            for i=1,#elite_data do   --for 1
                Arcos_data = conn_Arcos_stg:query{sql = "SELECT * FROM ArcosMDB.dbo.ScheduleItems where item_num='"..elite_data[i].ITEM_NUM.."';",live=true};
                print(#Arcos_data,Arcos_data)
                if(#Arcos_data>0) then  --if 31
                    if( elite_data[i].ITEM_NUM == Arcos_data[1].item_num and
                        elite_data[i].LIC_REQD == Arcos_data[1].lic_reqd and
                        elite_data[i].DEA_SCHEDULE_LIST == Arcos_data[1].DEA_Schedule_List and
                        elite_data[i].LICENSE_TYPE == Arcos_data[1].License_type and
                        elite_data[i].BACCS == Arcos_data[1].baccs and
                        elite_data[i].BREAK_CODE == Arcos_data[1].break_code and
                        elite_data[i].UPC == Arcos_data[1].upc and
                        elite_data[i].USE_BREAK_CODE == Arcos_data[1].use_break_code and
                        elite_data[i].DESC_1 == Arcos_data[1].desc_1 and
                        elite_data[i].SCHED1 == Arcos_data[1].sched1 and
                        elite_data[i].SCHED2 == Arcos_data[1].sched2 and
                        elite_data[i].SCHED3 == Arcos_data[1].sched2 and
                        elite_data[i].SCHED4 == Arcos_data[1].sched2 and
                        elite_data[i].SCHED5 == Arcos_data[1].sched2 and
                        elite_data[i].SCHED6 == Arcos_data[1].sched2 and
                        elite_data[i].SCHED7 == Arcos_data[1].sched2 and
                        elite_data[i].SCHED8 == Arcos_data[1].sched2 and
                        elite_data[i].CONTR_SUBST == Arcos_data[1].contr_subst
                        )  then --if 32
                           log_file:write(TIME_STAMP.."        for ITEM_NUM : "..Arcos_data[1].ITEM_NUM.."there is no change in Arcosdatabase","\n")
                    else
                         --conn_Arcos_stg:query{sql = "UPDATE TempSchedItems_ORA INNER JOIN ScheduleItems ON TempSchedItems_ORA.ITEM_NUM = ScheduleItems.item_num SET TempSchedItems_ORA.ITEM_NUM = Null;",live=true};
                          log_file:write(TIME_STAMP.."        for ITEM_NUM : "..Arcos_data[1].ITEM_NUM.."there needs to be some updation done in Arcos database","\n")
                    end  --end if 32
                else
                    -- conn_Arcos_stg:query{sql ="INSERT INTO ScheduleItems ( item_num, lic_reqd, baccs, break_code, use_break_code, upc, desc_1, sched1, sched2, sched3, sched4, sched5, sched6, sched7, sched8 );",live=true};
                    log_file:write(TIME_STAMP.."        for ITEM_NUM : "..Arcos_data[1].ITEM_NUM.."there needs to be some insertion done in Arcos database","\n")
                end  --end if 31
            end --for 1
     
     
            
            
            
            else
                log_file:write(TIME_STAMP..DB_CON_ERROR_ARCOS_STG,"\n")
            end   --end if 3
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
    log_file_with_today_date = "logs_PImport_PScheduled_Items_ "..os.date("%Y-%m-%d")..".txt" --lOG file name with Today Date
    print(log_file_with_today_date)
    local log_file_verify=io.open(output_log_path..log_file_with_today_date,'r')
    if log_file_verify~=nil then  --if 52
        io.close(log_file_verify)
        return io.open(output_log_path..log_file_with_today_date,'a+')
    else
        return io.open(output_log_path..log_file_with_today_date,'w')
    end  --end if 52
end  --end function getLogFile

--[[ print(elite_data,elite_data[1].ITEM_NUM,elite_data[1].LIC_REQD,elite_data[1].DEA_SCHEDULE_LIST)
            print(elite_data[1].LICENSE_TYPE,elite_data[1].BACCS,elite_data[1].BREAK_CODE,elite_data[1].UPC)
            print(elite_data[1].USE_BREAK_CODE,elite_data[1].DESC_1,elite_data[1].SCHED1,elite_data[1].SCHED2)
            print(elite_data[1].SCHED3,elite_data[1].SCHED4,elite_data[1].SCHED5,elite_data[1].SCHED6,elite_data[1].SCHED7)
            print(elite_data[1].SCHED8,elite_data[1].CONTR_SUBST)     
            
              print(Arcos_data[1].item_num,Arcos_data[1].lic_reqd,Arcos_data[1].sched1,Arcos_data[1].sched2,Arcos_data[1].sched3)
            print(Arcos_data[1].sched4,Arcos_data[1].sched5,Arcos_data[1].sched6,Arcos_data[1].sched7,Arcos_data[1].sched8)
            print(Arcos_data[1].contr_subst,Arcos_data[1].baccs,Arcos_data[1].break_code,Arcos_data[1].use_break_code)
            print(Arcos_data[1].desc_1,Arcos_data[1].ScheduleItem_ID,Arcos_data[1].upc,Arcos_data[1].DEA_Schedule_List)
            print(Arcos_data[1].License_type)
]]--

local Constants =  {}

function Constants.csos_order_header_size()


-- The main function is the first function called from Iguana.
output_log_path= "C:\\ARCOS\\LogFiles\\"
TIME_STAMP=os.date('%x').." "..os.date('%X').." - "
CHANNEL_STARTED_RUNNING="******* Iguana Import_Schedule_Items channel Started Running *******"
CHANNEL_STOPPED_RUNNING="^^^^^^^ Iguana Import_Schedule_Items channel Stopped Running ^^^^^^^"  
DB_CON_ERROR_ELITE="        Database connection failed for Elite DataBase"
DB_CON_ERROR_ARCOS="        Database connection failed for ARCOS DataBase"
DB_CON_ERROR_ARCOS_STG="        Database connection failed for ARCOS Stage DataBase "
INSERT_SUCCESS="        Successfully inserted data into DataBase"
LOG_DIR_MISS="        Log Directory does not exist"
LOG_DIR_CREATE="        Log directory created" 
CSOS_ORDER_HDR_STAT_VALUE='1'
end

return Constants
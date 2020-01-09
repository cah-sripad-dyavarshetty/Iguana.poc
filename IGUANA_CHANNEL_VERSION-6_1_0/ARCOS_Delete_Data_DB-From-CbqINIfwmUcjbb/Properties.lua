local Properties =  {}

dbConnection = require("DBConnection")    
dbConnection.connectdb()


function Properties.directory_path()    --directory paths for Order files,archive,error,log files

    --input_directory_path  = "\\\\wsec0509spsap03\\Axway_CSOS_Stage\\"
  output_log_path= "C:\\ARCOS\\LogFiles\\"
end

function Properties.db_conn()
  -- conn = conn_stg
   conn = conn_dev
  
end

return Properties
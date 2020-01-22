
local DBConnection =  {}

function DBConnection.connectdb()
    
   if not conn_Arcos_dev or conn_Arcos_dev:check() then  --dev connection
        if conn_Arcos_dev and conn_Arcos_dev:check() then
            conn_Arcos_dev:close() end
   
        conn_Arcos_dev = db.connect{   
      api=db.SQL_SERVER, 
      name='SQLSERVER',
      user='',      -- use empty string for integrated security
      password='',  -- use empty string for integrated security
      use_unicode = true,
      live = true
   }
   end
      
  
   
   
    if not conn_Elite_stg or conn_Elite_stg:check() then  --dev connection
        if conn_Elite_stg and conn_Elite_stg:check() then
            conn_Elite_stg:close() end
        conn_Elite_stg = db.connect{
            api=db.ORACLE_OCI,
            name='//lsec0409val1s01.cardinalhealth.net:1521/val1s/',
            user='sps_service',
            password='mickey222',
            use_unicode = true,
            live = true
        }
    end
   
   
   
end
return DBConnection
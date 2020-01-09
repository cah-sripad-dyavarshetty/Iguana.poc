



local DBConnection =  {}

function DBConnection.connectdb()
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
return DBConnection
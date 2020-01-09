
local Validation =  {}

function Validation.validate_string_value(order_value_string,column_size_string) --validation of data present in order files
    if(order_value_string == nil) then
        return false
elseif(type(order_value_string)=='string' and #order_value_string<=column_size_string and #order_value_string>=0) then
    return true
else
    return false
end
end


return Validation
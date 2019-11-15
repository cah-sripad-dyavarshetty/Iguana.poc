-- This channel read the order files and store in the database
-- Version 1.0
function main()

    dbConnection = require("DBConnection")
    properties = require("properties")
    Validation = require("Validation")
    constants = require("Constants")

    properties.directory_path()
    constants.csos_order_header_size()
    constants.csos_order_details_size()
    constants.query_constants()
    constants.frequently_constants()
    constants.log_statements()


    c=io.open(iguana.project.root()..'other/Log/Logfile_multiorders.txt','a+')
    d=c:read('*a')

    -- c=io.open("C:\\3PL_WO\\LogFiles\\Logfile.txt",'r+')   --log file creation
    -- d=c:read('*a')

    --Validating the directories of ArchivedFiles and ErrorFiles

    result_ArchivedDirectory_Status=os.fs.access(output_archived_path)     --checking directory exist status
    result_ErrorDirectory_Status=os.fs.access(output_error_path)        --checking directory exist status

    if(result_ArchivedDirectory_Status==false)   then --if 1  -- checking for directory exist or not
        c:write(ARC_DIR_MISS..os.date('%x').." at :"..os.date('%X'),"\n") --checking
        os.fs.mkdir(output_archived_path)
        c:write(ARC_DIR_CREATE..os.date('%x').." at :"..os.date('%X'),"\n") --checking
    end --end for 1


    if(result_ErrorDirectory_Status==false)   then --if 2  -- checking for directory exist or not
        c:write(ERR_DIR_MISS..os.date('%x').." at :"..os.date('%X'),"\n") --checking
        os.fs.mkdir(output_error_path)
        c:write(ERR_DIR_CREATE..os.date('%x').." at :"..os.date('%X'),"\n") --checking
    end --end if 2
    -- Read the XML file from the Directory

    file_directory =io.popen([[dir "]]..input_directory_path..[[" /b]])

    for filename in file_directory:lines() do  --for 1
        local order_file=input_directory_path..filename
        -- This is the default value of the column ACTIVE_FLAG in the database

        ACTIVE_FLG=active_flg_val
        ROW_ADD_USER_ID=user
        ROW_UPDATE_USER_ID=user
        CSOS_ORD_HDR_NUM=1


        --CSOS_ORD_HDR_NUM_UPDATE=''
        if(GetFileExtension(order_file) == '.xml') then  --if 3  checking for xml type
            c:write(XML_FILE_TEST_SUCCESS..os.date('%x').." at :"..os.date('%X'),"\n")  --checking
            -- Open order file
            local open_order_file = io.open(order_file, "r")
            -- Read order file
            local read_order_file =  open_order_file:read('*a')
            -- Close the file
            open_order_file:close()

            local order_data = xml.parse(read_order_file)



            --calling validationForTagStatus
            ORDER_DATA_TAG_STATUS = validationForTagStatus(order_data)
            -- Validation
            if(ORDER_DATA_TAG_STATUS==true) then --if 4 checking for tag availability

                os.rename(input_directory_path..filename, output_error_path..filename)
                c:write(ERR_DIR_MOV..os.date('%x').." at :"..os.date('%X'),"\n")  --checking
                order_data=''

            else
                Size_Of_NoOfLines=order_data.CSOSOrderRequest.CSOSOrder.OrderSummary.NoOfLines:nodeText()

                --calling validationForOrderData
                order_data_validation_status = validationForOrderData(order_data)

                if(order_data_validation_status==true) then  --if 5 checking for validation status

                    tag_OrderSummary=order_data.CSOSOrderRequest.CSOSOrder.OrderSummary
                    tag_order=order_data.CSOSOrderRequest.CSOSOrder.Order

                    --date type convertion
                    ts=os.time()
                    DATE_VALUE=os.date('%Y-%m-%d %H:%M:%S',ts)


                    dbConnection.connectdb()

                    local sql_csos_order_header = "CALL AddCSOSOrder ("..
                        conn_dev:quote(tag_OrderSummary.BusinessUnit:nodeText())..", "..
                        conn_dev:quote(tag_OrderSummary.NoOfLines:nodeText())..", "..
                        conn_dev:quote(tag_OrderSummary.OrderChannel:nodeText())..", "..
                        conn_dev:quote(tag_OrderSummary.PODate:nodeText())..", "..
                        conn_dev:quote(tag_OrderSummary.PONumber:nodeText())..", "..
                        conn_dev:quote(tag_OrderSummary.ShipToNumber:nodeText())..", "..
                        conn_dev:quote(tag_OrderSummary.UniqueTransactionNumber:nodeText())..", "..
                        conn_dev:quote(ACTIVE_FLG)..", "..
                        conn_dev:quote( DATE_VALUE)..", "..
                        conn_dev:quote(ROW_ADD_USER_ID)..", "..
                        conn_dev:quote( DATE_VALUE)..", "..
                        conn_dev:quote(ROW_UPDATE_USER_ID)..
                        ")"

                    sql_csos_order_status,sql_csos_order_error =conn_dev:execute{sql=sql_csos_order_header, live=true};

                    local CSOS_ORD_HDR_NUM_UPDATE=conn_dev:query{sql=sel_head, live=true};

                    CSOS_ORD_HDR_NUM_UPDATE_VAL=tostring(CSOS_ORD_HDR_NUM_UPDATE[1]["max(CSOS_ORD_HDR_NUM)"])


                    for i=1,Size_Of_NoOfLines do  --for 2

                        local sql_csos_order_details = "CALL AddCSOSOrderdetails ("..
                            conn_dev:quote(CSOS_ORD_HDR_NUM_UPDATE_VAL)..", "..
                            conn_dev:quote(tag_order[i].BuyerItemNumber:nodeText())..", "..
                            conn_dev:quote(tag_order[i].Form:nodeText())..", "..
                            conn_dev:quote(tag_order[i].LineNumber:nodeText())..", "..
                            conn_dev:quote(tag_order[i].NameOfItem:nodeText())..", "..
                            conn_dev:quote(tag_order[i].NationalDrugCode:nodeText())..", "..
                            conn_dev:quote(tag_order[i].QuantityOrdered:nodeText())..", "..
                            conn_dev:quote(tag_order[i].Schedule:nodeText())..", "..
                            conn_dev:quote(tag_order[i].SizeOfPackages:nodeText())..", "..
                            conn_dev:quote(tag_order[i].Strength:nodeText())..", "..
                            conn_dev:quote(tag_order[i].SupplierItemNumber:nodeText())..", "..
                            conn_dev:quote(ACTIVE_FLG)..", "..
                            conn_dev:quote( DATE_VALUE)..", "..
                            conn_dev:quote(ROW_ADD_USER_ID)..", "..
                            conn_dev:quote( DATE_VALUE)..", "..
                            conn_dev:quote(ROW_UPDATE_USER_ID)..
                            ")"

                    sql_csos_detail_status,sql_csos_detail_error = conn_dev:execute{sql=sql_csos_order_details, live=true};


                    end    --end for 2

                    c:write(INSERT_SUCCESS..os.date('%x').." at :"..os.date('%X'),"\n")   --checking



                    if(sql_csos_order_status == nil and sql_csos_detail_status == nil) --if 6
                    then
                        os.rename(input_directory_path..filename, output_archived_path..filename)
                        c:write("The given file is moved to archive folder on :"..os.date('%x').." at :"..os.date('%X'),"\n")  --checking
                    else
                        os.rename(input_directory_path..filename, output_error_path..filename)
                        c:write("The given file is moved to error folder on :"..os.date('%x').." at :"..os.date('%X'),"\n")  --checking
                    end --END FOR IF 6
                end -- end if 5 checking for validation status
            end --end for if 4 checking for tag availability
        else
            c:write(XML_FILE_TEST_FAIL..os.date('%x').." at :"..os.date('%X'),"\n")  --checking
            os.rename(input_directory_path..filename, output_error_path..filename)
            c:write(DATA_VALIDATION_FAIL..os.date('%x').." at :"..os.date('%X'),"\n")   --checking
            c:write(INSERT_FAIL..os.date('%x').." at :"..os.date('%X'),"\n")   --checking
            c:write(ERR_DIR_MOV..os.date('%x').." at :"..os.date('%X'),"\n")  --checking

        end -- end for if 3  checking for xml type
    end --end for for 1
end -- end for main function



-- Validating the file extenstion format
function GetFileExtension(url)
    return url:match("^.+(%..+)$")
end

-- Validating for tags availability

function validationForTagStatus(order_data)
    local validateion_Tag_Status = false

    tag_OrderSummary=order_data.CSOSOrderRequest.CSOSOrder.OrderSummary
    tag_order=order_data.CSOSOrderRequest.CSOSOrder.Order

    if(order_data.CSOSOrderRequest==nil or order_data.CSOSOrderRequest.CSOSOrder==nil or tag_OrderSummary==nil  --if 7
        or tag_OrderSummary.PODate==nil or tag_OrderSummary.PODate:nodeText()==nil
        or tag_OrderSummary.ShipToNumber==nil   or tag_OrderSummary.ShipToNumber:nodeText()== nil
        or tag_OrderSummary.PONumber==nil  or tag_OrderSummary.PONumber:nodeText()==nil
        or  tag_OrderSummary.BusinessUnit==nil or tag_OrderSummary.BusinessUnit:nodeText()==nil
        or tag_OrderSummary.OrderChannel==nil or tag_OrderSummary.OrderChannel:nodeText()==nil
        or tag_OrderSummary.UniqueTransactionNumber==nil or tag_OrderSummary.UniqueTransactionNumber:nodeText()==nil or tag_OrderSummary.NoOfLines:nodeText()==nil
        or tag_order==nil)
    then

        for i=1,2 do  --for 3

            if(tag_order[i].LineNumbe==nil or tag_order[i].LineNumber:nodeText()==nil  --if 8
                or tag_order[i].NameOfItem==nil or tag_order[i].NameOfItem:nodeText()==nil
                or tag_order[i].NationalDrugCode==nil or tag_order[i].NationalDrugCode:nodeText()==nil
                or  tag_order[i].SizeOfPackages==nil  or  tag_order[i].SizeOfPackages:nodeText()==nil
                or tag_order[i].QuantityOrdered==nil or tag_order[i].QuantityOrdered:nodeText()==nil
                or tag_order[i].Strength==nil or tag_order[i].Strength:nodeText()==nil
                or tag_order[i].Form==nil or tag_order[i].Form:nodeText()==nil
                or tag_order[i].Schedule==nil or tag_order[i].Schedule:nodeText()==nil
                or tag_order[i].SupplierItemNumber==nil or tag_order[i].SupplierItemNumber:nodeText()==nil
                or tag_order[i].BuyerItemNumber==nil or tag_order[i].BuyerItemNumber:nodeText()==nil)
        then
            validateion_Tag_Status = true

            c:write(TAG_MISS..os.date('%x').." at :"..os.date('%X'),"\n")   --checking
        end  --end for if 8

        end  --end for for3
    else
        validateion_Tag_Status = false

        c:write(TAGS_AVAILABLE..os.date('%x').." at :"..os.date('%X'),"\n")   --checking
    end -- end for if 7

    return validateion_Tag_Status
end --end for validationForTagStatus


-- Validating the order data

function validationForOrderData(order_data)
    tag_OrderSummary=order_data.CSOSOrderRequest.CSOSOrder.OrderSummary
    tag_order=order_data.CSOSOrderRequest.CSOSOrder.Order
    -- Validation for csos_order_header
    local validateion_status = false

    -- Task 1 : Write all the columns of csos_order_header and csos_order_details in the if condition
    if(Validation.validate_value(tag_OrderSummary.PODate:nodeText(),PO_DATE) --if 9
        and Validation.validate_value(tag_OrderSummary.PONumber:nodeText(),PO_NUMBER)
        and Validation.validate_value(tag_OrderSummary.ShipToNumber:nodeText(),SHIPTO_NUM)
        and Validation.validate_value(tag_OrderSummary.BusinessUnit:nodeText(),BUSINESS_UNIT)
        and Validation.validate_value(tag_OrderSummary.OrderChannel:nodeText(), ORDER_CHANNEL)
        and Validation.validate_value(tag_OrderSummary.UniqueTransactionNumber:nodeText(),UNIQUE_TRANS_NUM)
        and Validation.validate_value(tag_OrderSummary.NoOfLines:nodeText(),NO_OF_LINES))
    then

        for i=1,Size_Of_NoOfLines do   --for 4

            if(Validation.validate_value(tag_order[i].LineNumber:nodeText(),LINE_NUM)  --if 10
                and Validation.validate_value(tag_order[i].NameOfItem:nodeText(),NAME_OF_ITEM)
                and Validation.validate_value(tag_order[i].NationalDrugCode:nodeText(),NATIONAL_DRUG_CDE)
                and Validation.validate_value(tag_order[i].SizeOfPackages:nodeText(),SIZE_OF_PACKAGE)
                and Validation.validate_value(tag_order[i].QuantityOrdered:nodeText(),QUANTITY)
                and Validation.validate_value(tag_order[i].Strength:nodeText(),STRENGTH)
                and Validation.validate_value(tag_order[i].Form:nodeText(),FORM)
                and Validation.validate_value(tag_order[i].Schedule:nodeText(),DEA_SCHEDULE)
                and Validation.validate_value(tag_order[i].SupplierItemNumber:nodeText(),SUPPLIER_ITEM_NUM)
                and Validation.validate_value(tag_order[i].BuyerItemNumber:nodeText(),BUYER_ITEM_NUM))
        then

            validateion_status = true

            c:write(DATA_VALIDATION_SUCCESS..os.date('%x').." at :"..os.date('%X'),"\n")   --checking
        end  --end for if 10

        end   --end for for 4

    else
        validateion_status = false

        c:write(DATA_VALIDATION_FAIL..os.date('%x').." at :"..os.date('%X'),"\n")   --checking

    end -- end for if 9

    return validateion_status

end

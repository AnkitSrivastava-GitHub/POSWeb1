var POAutoId = 0;
$(document).ready(function () {
    debugger
    SetCurrency();
    $('#txtPurchaseDate').pickadate({
        format: 'mm/dd/yyyy',
        formatSubmit: 'mm/dd/yyyy',
        selectYears: true,
        selectMonths: true,
    });
    //$('#txtPurchaseDate').datepicker({
    //    changeMonth: true,
    //    changeYear: true,
    //    dateFormat: 'mm/dd/yy',
    //    selectYears: true,
    //    selectMonths: true,
    //    maxDate: 0,
    //});
    var now = new Date();
    var day = ("0" + now.getDate()).slice(-2);
    var month = ("0" + (now.getMonth() + 1)).slice(-2);
    var today = (month) + "/" + (day) + "/" + now.getFullYear();
    $('#txtPurchaseDate').val(today);
    var getQueryString = function (field, url) {
        var href = url ? url : window.location.href;
        var reg = new RegExp('[?&]' + field + '=([^&#]*)', 'i');
        var string = reg.exec(href);
        return string ? string[1] : null;
    };
    POAutoId = getQueryString('PageId');
    if (POAutoId != null) {
        GetPoDetail(POAutoId);
    }
    $('.select2-selection__rendered').hover(function () {
        $(this).removeAttr('title');
    });
});
var CSymbol = "";
function SetCurrency() {
    debugger
    $.ajax({
        type: "POST",
        url: "/Pages/POMaster.aspx/CurrencySymbol",
        dataType: "json",
        contentType: "application/json;charset=utf-8",
        beforeSend: function () {
            $('#fade').show();
        },
        complete: function () {
            $('#fade').hide();
        },
        success: function (response) {
            debugger
            if (response.d != '') {
                CSymbol = response.d;
                $('.symbol').text(response.d);
            }
            else {
                window.location.href = '/Default.aspx'
            }
        },
        error: function (err) {
            swal("Error!", err.d, "error", { closeOnClickOutside: false });
            $('#loading').hide();
        },
        failure: function (err) {
            swal("Error!", err.d, "error", { closeOnClickOutside: false });
            $('#loading').hide();
        }
    });
}

function GetPoDetail(POAutoId) {
    debugger;
    $.ajax({
        type: "POST",
        url: "/Pages/GenerateInvoice.aspx/GetPoDetail",
        data: "{'POAutoId':'" + POAutoId + "'}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            if (response.d == 'false') {
                swal("", "Po details found!", "warning", { closeOnClickOutside: false });
            } else if (response.d == "Session") {
                location.href = '/';
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var VendorList = xml.find("Table");
                var PODetails = xml.find("Table1");
                var POItemDetails = xml.find("Table2");
                $("#ddlVendor option").remove();
                $("#ddlVendor").append('<option value="0">Select Vendor</option>');
                $.each(VendorList, function () {
                    $("#ddlVendor").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("VendorName").text()));
                });
                $("#ddlVendor").select2();

                POAutoId = $(PODetails).find("AutoId").text();
                $("#ddlVendor").val($(PODetails).find("VendorId").text()).select2();
                $("#txtDate").val($(PODetails).find("PoDate").text());
                $("#ddlPotatus").val($(PODetails).find("Status").text());
                $("#txtRemark").val($(PODetails).find("Remark").text());
                $("#txtPONumber").val($(PODetails).find("PoNumber").text());
                var i = 0;
                $.each(POItemDetails, function (index, item) {
                    var TableHtml = '';
                    TableHtml += '<tr>';
                    //TableHtml += '<td class="Action" style="width: 50px; text-align: center;"><a id="deleterow"  title="Remove" onclick="deleterow11(this)"><span class="fa fa-times" style="color: blue;"></span></a></td>';  
                    TableHtml += '<td class="PoItemAutoId" style="white-space: nowrap; text-align: center; display: none;">' + $(this).find('AutoId').text() + '</td>';
                    TableHtml += '<td class="VendorProductCode" style="white-space: nowrap; text-align: center;">' + $(this).find('VendorProductCode').text() + '</td>';
                    TableHtml += '<td class="ProductAutoId" style="white-space: nowrap; text-align: center; display: none;">' + $(this).find('ProductId').text() + '</td>';
                    TableHtml += '<td class="ProductName" style="white-space: nowrap; text-align: center">' + $(this).find('ProductName').text() + '</td>';
                    TableHtml += '<td class="UnitType" style="white-space: nowrap; text-align: center">' + $(this).find('PackingName').text() + '</td>';
                    TableHtml += '<td class="UnitAutoId" style="white-space: nowrap; text-align: center; display: none;">' + $(this).find('PackingId').text() + '</td>';
                    TableHtml += '<td class="RequiredQty" style="white-space: nowrap; text-align: center">' + $(this).find('RequiredQty').text() + '</td>';
                    TableHtml += '<td class="PartialQty" style="white-space: nowrap; text-align: center">' + $(this).find('PartialReceivedQty').text() + '</td>';
                    TableHtml += '<td class="RemainingQty" style="white-space: nowrap; text-align: center;">' + $(this).find('RemainingQty').text() + '</td>';
                    if (parseInt($(this).find('RequiredQty').text()) - parseInt($(this).find('PartialReceivedQty').text()) == 0) {
                        TableHtml += '<td class="ReceivedQty" style="white-space: nowrap; text-align: center;width:12%;"><input type="text" onclick="this.select();" id="txtReceivedQty" value="0" disabled onchange="CalculateFoot()" onblure="CalculateFoot()" class="form-control input-sm" style="text-align:center;" onkeypress="return isNumberKey(this)" maxlength="4"></td>';
                        TableHtml += '<td class="UnitPrice" style="white-space: nowrap; text-align: center;width:12%;"><input type="text" onclick="this.select();" id="txtUnitPrice" value="0" disabled onchange="CalculateFoot()" class="form-control input-sm" style="text-align:right;" onkeypress="return isNumberDecimalKey(event,this)" maxlength="8"></td>';
                    }
                    else {
                        TableHtml += '<td class="ReceivedQty" style="white-space: nowrap; text-align: center;width:12%;"><input type="text" onclick="this.select();" id="txtReceivedQty" value="' + (parseInt($(this).find('RequiredQty').text()) - parseInt($(this).find('PartialReceivedQty').text())) + '" onchange="CalculateFoot()" class="form-control input-sm" style="text-align:center;" onkeypress="return isNumberKey(this)" maxlength="4"></td>';
                        TableHtml += '<td class="UnitPrice" style="white-space: nowrap; text-align: center;width:12%;"><input type="text" onclick="this.select();" id="txtUnitPrice" onchange="CalculateFoot()" class="form-control input-sm" style="text-align:right;" onkeypress="return isNumberDecimalKey(event,this)" maxlength="8"></td>';
                    }
                    TableHtml += '<td class="UnitPrice1" style="white-space: nowrap; text-align: right">' + $(this).find('UnitPrice').text() + '</td>';
                    TableHtml += '<td class="SecUnitPrice" style="white-space: nowrap; text-align: right">' + $(this).find('SecUnitPrice').text() + '</td>';
                    TableHtml += '<td class="TotalCost" style="white-space: nowrap; text-align: right">0.00</td>';
                    TableHtml += '<td class="Taxper" style="white-space: nowrap; text-align: center; display: none;">' + $(this).find('TaxPer').text() + '</td>';
                    TableHtml += '<td class="ActionId" style="white-space: nowrap; text-align: center; display: none;">2</td>';
                    TableHtml += '</tr>';
                    if (parseInt($(this).find('RequiredQty').text()) - parseInt($(this).find('PartialReceivedQty').text()) != 0) {
                        i += 1;
                    }
                    $('#tblPOListBody').prepend(TableHtml);
                });
                if (i == 0) {
                    $("#btnSave").text('Invoice Already Generated');
                    $("#btnSave").prop('disabled', true);
                    $("#txtInvoiceNo").attr('disabled', true);
                    $("#txtPurchaseDate").attr('disabled', true);
                }
                CalculateFoot();

            }
        },
        failure: function (result) {
            console.log(result.d);
        },
        error: function (result) {
            console.log(result.d);
        }
    });
}



function CalculateFoot() {
    debugger;
    var T_RequiredQty = 0, T_PartialQty = 0, i = 1, T_RemainingQty = 0, T_ReceivedQty = 0, T_UnitPrice = 0, T_TotalCost = 0,RowCnt=0;

    $("#tblPOListBody tr").each(function () {
        debugger;
      
        if ((parseInt(isNaN($(this).find('.RemainingQty').text()) ? 0 : $(this).find('.RemainingQty').text()) >= parseInt(isNaN($(this).find('.ReceivedQty input:eq(0)').val()) || ($(this).find('.ReceivedQty input:eq(0)').val() == "") ? 0 : $(this).find('.ReceivedQty input:eq(0)').val())) ) {
            T_RequiredQty += parseInt(isNaN($(this).find('.RequiredQty').text()) ? 0 : $(this).find('.RequiredQty').text());
            T_PartialQty += parseInt(isNaN($(this).find('.PartialQty').text()) ? 0 : $(this).find('.PartialQty').text());
            T_RemainingQty += parseInt(isNaN($(this).find('.RemainingQty').text()) ? 0 : $(this).find('.RemainingQty').text());
            T_ReceivedQty += parseInt(isNaN($(this).find('.ReceivedQty input:eq(0)').val()) || ($(this).find('.ReceivedQty input:eq(0)').val() == "") ? 0 : $(this).find('.ReceivedQty input:eq(0)').val());
            T_UnitPrice += parseFloat(isNaN($(this).find('.UnitPrice input:eq(0)').val()) || ($(this).find('.UnitPrice input:eq(0)').val() == "") ? 0 : $(this).find('.UnitPrice input:eq(0)').val());
            $(this).find('.UnitPrice input:eq(0)').val(parseFloat(isNaN($(this).find('.UnitPrice input:eq(0)').val()) || ($(this).find('.UnitPrice input:eq(0)').val() == "") ? 0 : $(this).find('.UnitPrice input:eq(0)').val()).toFixed(2));
            $(this).find('.TotalCost').text(parseFloat((parseInt(isNaN($(this).find('.ReceivedQty input:eq(0)').val()) || ($(this).find('.ReceivedQty input:eq(0)').val() == "") ? 0 : $(this).find('.ReceivedQty input:eq(0)').val())) * (parseFloat(isNaN($(this).find('.UnitPrice input:eq(0)').val()) || ($(this).find('.UnitPrice input:eq(0)').val() == "") ? 0 : $(this).find('.UnitPrice input:eq(0)').val()))).toFixed(2));
            T_TotalCost += parseFloat((parseInt(isNaN($(this).find('.ReceivedQty input:eq(0)').val()) || ($(this).find('.ReceivedQty input:eq(0)').val() == "") ? 0 : $(this).find('.ReceivedQty input:eq(0)').val())) * (parseFloat(isNaN($(this).find('.UnitPrice input:eq(0)').val()) || ($(this).find('.UnitPrice input:eq(0)').val() == "") ? 0 : $(this).find('.UnitPrice input:eq(0)').val())));
        }

        else {
            i = 0;
            $(this).find('.ReceivedQty input:eq(0)').val('0');
            return false;
        }
    });
    $("#RowCount").text($("#tblPOListBody tr").length);
    if (i == 1) {
        $("#F_RequiredQty").text(T_RequiredQty);
        $("#F_PartiallyQty").text(T_PartialQty);
        $("#F_RemainingQty").text(T_RemainingQty);
        $("#F_ReceivedQty").text(isNaN(T_ReceivedQty) ? 0 : T_ReceivedQty);
        $("#F_TotalCost").text(CSymbol + (isNaN(T_TotalCost) ? 0.00 : T_TotalCost).toFixed(2));
    } else {
        toastr.error('Received quantity must be less than required quantity.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        return false;
    }
}

function GenerateInvoice() {
    debugger;
    $('#loading').show();
    if ($('#ddlVendor').val() == '0') {
        toastr.error('Please Select Vendor.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $('#loading').hide();
        return false;
    }
    else if ($('#txtPONumber').val().trim() == '') {
        toastr.error('Please Enter PO Number.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtPONumber").focus();
        $('#loading').hide();
        return false;
    }
    else if ($('#txtInvoiceNo').val().trim() == '') {
        toastr.error('Please Enter Invoice Number.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtInvoiceNo").focus();
        $('#loading').hide();
        return false;
    }
    var validate = 1, ZeroQtyProductcnt = 0;
    //$("#tblPOListBody tr").each(function () {
    //    debugger;
    //    if (parseInt($(this).find('.RemainingQty').text()) > 0) {
    //        if (isNaN(parseInt($(this).find('.ReceivedQty input:eq(0)').val())) || $(this).find('.ReceivedQty input:eq(0)').val() == "" || parseInt($(this).find('.ReceivedQty input:eq(0)').val()) == 0) {
    //            validate = 0;
    //            toastr.error('Please Enter Received Quantity.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
    //            $(this).find('.ReceivedQty input:eq(0)').focus();
    //            $('#loading').hide();
    //            return false;
    //        }
    //        if (isNaN(parseFloat($(this).find('.UnitPrice input:eq(0)').val())) || $(this).find('.UnitPrice input:eq(0)').val() == "" || parseFloat($(this).find('.UnitPrice input:eq(0)').val()) == 0) {
    //            validate = 0;
    //            toastr.error('Please Enter Cost Price.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
    //            $(this).find('.UnitPrice input:eq(0)').focus();
    //            $('#loading').hide();
    //            return false;
    //        }
    //    }
    //});
    $("#tblPOListBody tr").each(function () {
        debugger;
        if (parseInt($(this).find('.RemainingQty').text()) > 0) {
            if (isNaN(parseInt($(this).find('.ReceivedQty input:eq(0)').val())) || $(this).find('.ReceivedQty input:eq(0)').val() == "") {
                //validate = 0;
                //toastr.error('Please Enter Received Quantity.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
                //$(this).find('.ReceivedQty input:eq(0)').focus();
                //$('#loading').hide();
                //return false;
                $(this).find('.ReceivedQty input:eq(0)').val('0');
            }
            else if (parseInt($(this).find('.ReceivedQty input:eq(0)').val()) > 0) {
                ZeroQtyProductcnt++;
            }
            if ((isNaN(parseFloat($(this).find('.UnitPrice input:eq(0)').val())) || $(this).find('.UnitPrice input:eq(0)').val() == "") && (parseInt($(this).find('.ReceivedQty input:eq(0)').val()) > 0)) {
                validate = 0;
                $(this).find('.UnitPrice input:eq(0)').val('0.00');
                toastr.error('Please Enter Valid Cost Price.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
                $(this).find('.UnitPrice input:eq(0)').focus();
                $('#loading').hide();
                return false;
            }
            else if ((parseFloat($(this).find('.UnitPrice input:eq(0)').val()) == 0) && (parseInt($(this).find('.ReceivedQty input:eq(0)').val()) > 0)) {
                validate = 0;
                $(this).find('.UnitPrice input:eq(0)').val('0.00');
                toastr.error('Please Enter Cost Price.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
                $(this).find('.UnitPrice input:eq(0)').focus();
                $('#loading').hide();
                return false;
            }
            //else {
            //    $(this).find('.UnitPrice input:eq(0)').val('0.00');
            //}
        }
    });
    var RNum = rollDice();
    if (validate == 0) {
        return false;
    }
    else if (ZeroQtyProductcnt == 0) {
        validate = 0;
        toastr.error('Please enter details of alteast one product to generate invoice.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $('#loading').hide();
    }
    if (validate == 1) {
        data = {
            BatchNo: RNum,
            POAutoId: POAutoId,
            PoNumber: $('#txtPONumber').val(),
            InvoiceDate: $('#txtPurchaseDate').val(),
            InvoiceNo: $('#txtInvoiceNo').val(),
        }
        PoItemTable = new Array();
        var i = 0;
        $("#tblPOList #tblPOListBody tr").each(function (index, item) {
            if (parseInt($(item).find('.ReceivedQty input:eq(0)').val()) > 0) {
                debugger;
                    PoItemTable[i] = new Object();
                    PoItemTable[i].ProductAutoId = $(item).find('.ProductAutoId').text();
                    PoItemTable[i].UnitAutoId = $(item).find('.UnitAutoId').text();
                    PoItemTable[i].ReceivedQty = $(item).find('.ReceivedQty input:eq(0)').val();
                    PoItemTable[i].UnitPrice = $(item).find('.UnitPrice input:eq(0)').val();
                    PoItemTable[i].Taxper = $(item).find('.Taxper').text();
                    PoItemTable[i].ProductUnitPrice = parseFloat($(item).find('.UnitPrice1').text());
                    PoItemTable[i].SecUnitPrice = parseFloat($(item).find('.SecUnitPrice').text());
                    PoItemTable[i].VendorProductCode = $(item).find('.VendorProductCode').text();
                    i++;
            }
        });
        if (PoItemTable.length <= 0) {
            swal("Error!", "Please add a item.", "error", { closeOnClickOutside: false });
            $('#loading').hide();
            return;
        }
        var PoItemTableValues = JSON.stringify(PoItemTable);
        $.ajax({
            type: "POST",
            url: "/Pages/GenerateInvoice.aspx/GenerateInvoice",
            data: JSON.stringify({ dataValues: JSON.stringify(data), PoItemTableValues: PoItemTableValues }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                if (response.d == 'true') {
                    $('#loading').hide();
                    swal("Success!", "Invoice generated successfully.", "success", { closeOnClickOutside: false }).then(function () {
                        window.location.href = '/Pages/InvoiceList.aspx';
                    });

                }
                else if (response.d == 'Session') {
                    $('#loading').hide();
                    window.location.href = '/Default.aspx'
                }
                else {
                    swal('Error!', response.d, 'error', { closeOnClientOutside: false });
                    $('#loading').hide();
                }
            },
            failure: function (result) {
                swal('Error!', response.d, 'error', { closeOnClickOutside: false });
                $('#loading').hide();
            },
            error: function (result) {
                swal('Error!', response.d, 'error', { closeOnClickOutside: false });
                $('#loading').hide();
            }
        });
    }
}

function ResetInvoice() {

}

function rollDice() {
    return (Math.floor(100000000 + Math.random() * 900000000));
}
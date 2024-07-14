$(document).ready(function () {
    $('#ddlDiscountCriteria').select2();
    SetCurrency();
    BindDropdowns();
    var getQueryString = function (field, url) {
        var href = url ? url : window.location.href;
        var reg = new RegExp('[?&]' + field + '=([^&#]*)', 'i');
        var string = reg.exec(href);
        return string ? string[1] : null;
    };
    GroupAutoId = getQueryString('PageId');
    if (GroupAutoId != null) {
        $("#btnSave").hide();
        $("#btnUpdate").attr('onclick', 'UpdateGroupDetails(' + GroupAutoId +')');
        $("#btnUpdate").show();
        editGroupDetail(GroupAutoId);
    }
    else {
        $("#btnUpdate").hide();
        $("#btnSave").show();
        $("#btnUpdate").removeAttr('onclick');
    }
    $("#check-all").change(function () {
        if ($(this).prop("checked")) {
            $("#tblProductGroupList input:checkbox:not(:disabled)").prop('checked', $(this).prop("checked"));
        }
        else {
            $("#tblProductGroupList input:checkbox").prop('checked', $(this).prop("checked"));
        }
        CountSelectedRow();
    });
});

function editGroupDetail(GroupAutoId) {
    $.ajax({
        type: "POST",
        url: "/Pages/ProductGroup.aspx/editGroupDetail",
        data: "{'GroupAutoId':'" + GroupAutoId + "'}",
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
            if (response.d == 'false') {
                swal("", "No Details found!", "warning", { closeOnClickOutside: false });
            } else if (response.d == "Session") {
                location.href = '/';
            }
            else {
                var JsonObj = $.parseJSON(response.d);
                var GroupDetails = JsonObj[0].GroupDetails;
                var GroupItemList = JsonObj[0].GroupItemList;
                var tableHtml = '', i = 0;
                $('#txtGroupName').val(GroupDetails[0].GroupName);
                $('#txtQuantity').val(GroupDetails[0].MinQty);
                $('#ddlDiscountCriteria').val(GroupDetails[0].DiscountCriteria).select2();
                if (GroupDetails[0].DiscountCriteria == '1') {
                    $("#txtDiscountAmount").val(GroupDetails[0].DiscountVal);
                }
                else if (GroupDetails[0].DiscountCriteria == '2') {
                    $("#txtDiscountPer").val(GroupDetails[0].DiscountVal);
                }
                else if (GroupDetails[0].DiscountCriteria == '3') {
                    $("#txtFixedPrice").val(GroupDetails[0].DiscountVal);
                }
                $('#ddlStatus').val(GroupDetails[0].Status);

                var tableHtml = '', i = 0;
                if (GroupItemList.length > 0) {
                    $.each(GroupItemList, function (index, item) {
                        debugger;
                        tableHtml = '';
                        SKUIdArray.push(GroupItemList[index].SKUId);
                        tableHtml += '<tr>';
                        tableHtml += '    <td class="chkCheckBox text-center" style="width: 3%; vertical-align: middle;">';
                        tableHtml += '        <input type="checkbox" name="table_records" class="chkCheque" onchange="CountSelectedRow()">';
                        tableHtml += '    </td>';
                        tableHtml += '    <td class="SKUAutoId" style="white-space: nowrap; text-align: center; display: none;">' + GroupItemList[index].SKUId + '</td>';
                        tableHtml += '    <td class="Action" style="white-space: nowrap; text-align: center;display:none;"><a id="deleterow" title="Remove" onclick="deleterow(this)"><span class="fa fa-trash" style="color: red;"></span></a></td>';
                        tableHtml += '    <td class="Department" style="white-space: nowrap; text-align: center">' + GroupItemList[index].DepartmentName + '</td>';
                        tableHtml += '    <td class="Category1" style="white-space: nowrap; text-align: center">' + GroupItemList[index].CategoryName + '</td>';
                        tableHtml += '    <td class="SKUName" style="white-space: nowrap; text-align: center">' + GroupItemList[index].SKUName + '</td>';
                        //tableHtml+='    <%--<td class="UnitAutoId" style="white-space: nowrap; text-align: center; display: none;">UnitAutoId</td>--%>';
                        tableHtml += '    <td class="Unitprice" style="white-space: nowrap; text-align: center">' + GroupItemList[index].SKUSubTotal + '</td>';
                        tableHtml += '    <td class="UnitDiscount" style="white-space: nowrap; text-align: center; width: 10%;">0</td>';
                        tableHtml += '    <td class="UnitDiscountP" style="white-space: nowrap; text-align: center; width: 10%;">0</td>';
                        tableHtml += '    <td class="Discount" style="white-space: nowrap; text-align: center; display: none;">0</td>';
                        tableHtml += '    <td class="DiscountedUnitPrice" style="white-space: nowrap; text-align: center; width: 10%;">' + GroupItemList[index].SKUSubTotal + '</td>';
                        tableHtml += '    <td class="TaxPer" style="white-space: nowrap; text-align: center;">' + GroupItemList[index].taxper + '</td>';
                        tableHtml += '    <td class="Tax" style="white-space: nowrap; text-align: center">0</td>';
                        tableHtml += '    <td class="TaxAutoId" style="white-space: nowrap; align-content: center; display: none;">' + GroupItemList[index].TaxId + '</td>';
                        tableHtml += '    <td class="Total" style="white-space: nowrap; text-align: center;">' + GroupItemList[index].SKUTotal + '</td>';
                        tableHtml += '    <td class="ActionId" style="white-space: nowrap; text-align: center; display: none;">ActionId</td>';
                        tableHtml += '</tr>';
                        $("#tblProductGroupListBody").prepend(tableHtml);
                    });
                }
                $('#ddlDiscountCriteria').change();
            }
            $('#loading').hide();
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

function UpdateGroupDetails(GroupId) {
    $('#loading').show();
    debugger;
    if ($('#txtGroupName').val().trim() == '') {
        toastr.error('Please Enter Group Name.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtSKUName").focus();
        $('#loading').hide();
        return false;
    }
    else if ($('#txtQuantity').val().trim() == '' || parseInt($('#txtQuantity').val().trim()) == 0) {
        toastr.error('Please Fill Valid Quantity.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtQuantity").focus();
        $('#loading').hide();
        return false;
    }
    else if ($('#ddlDiscountCriteria').val() == '0') {
        toastr.error('Please Select Discount Type.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $('#loading').hide();
        return false;
    }
    else if ($('#ddlDiscountCriteria').val() == '1' && ($('#txtDiscountAmount').val().trim() == '' || parseFloat($('#txtDiscountAmount').val().trim()) == 0)) {
        toastr.error('Please Fill Discount Amount.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtDiscountAmount").focus();
        $('#loading').hide();
        return false;
    }
    else if ($('#ddlDiscountCriteria').val() == '2' && ($('#txtDiscountPer').val().trim() == '' || parseFloat($('#txtDiscountPer').val().trim()) == 0)) {
        toastr.error('Please Fill Discount Percentage.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtDiscountPer").focus();
        $('#loading').hide();
        return false;
    }
    else if ($('#ddlDiscountCriteria').val() == '3' && ($('#txtFixedPrice').val().trim() == '' || parseFloat($('#txtFixedPrice').val().trim()) == 0)) {
        toastr.error('Please Fill Fixed Amount.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtFixedPrice").focus();
        $('#loading').hide();
        return false;
    }
    ProductGroupTable = new Array();
    var i = 0;
    $("#tblProductGroupList #tblProductGroupListBody tr").each(function (index, item) {
        if ($(item).find('.SKUAutoId').text() != '0') {
            ProductGroupTable[i] = new Object();
            ProductGroupTable[i].SKUAutoId = $(item).find('.SKUAutoId').text();
            ProductGroupTable[i].SKUQty = 1;
            //ProductGroupTable[i].Department = $(item).find('.Department').text();
            //ProductGroupTable[i].Category1 = $(item).find('.Category1').text();
            ProductGroupTable[i].Unitprice = parseFloat($(item).find('.Unitprice').text());
            ProductGroupTable[i].UnitDiscount = parseFloat($(item).find('.UnitDiscount').text());
            ProductGroupTable[i].UnitDiscountP = parseFloat($(item).find('.UnitDiscountP').text());
            ProductGroupTable[i].DiscountedUnitPrice = parseFloat($(item).find('.DiscountedUnitPrice').text());
            ProductGroupTable[i].TaxPer = parseFloat($(item).find('.TaxPer').text());
            ProductGroupTable[i].TaxAutoId = $(item).find('.TaxAutoId').text();
            ProductGroupTable[i].Total = parseFloat($(item).find('.Total').text());
            i++;
        }
    });
    if (ProductGroupTable.length <= 0) {
        swal("Warning!", "Please add a product.", "warning", { closeOnClickOutside: false });
        $('#loading').hide();
        $(evt).removeAttr('disabled');
        return;
    }
    var ProductGroupTableValues = JSON.stringify(ProductGroupTable);

    var DiscountValue = 0;
    if ($('#ddlDiscountCriteria').val() == '1') {
        DiscountValue = $('#txtDiscountAmount').val().trim();
    }
    else if ($('#ddlDiscountCriteria').val() == '2') {
        DiscountValue = $('#txtDiscountPer').val().trim();
    }
    else if ($('#ddlDiscountCriteria').val() == '3') {
        DiscountValue = $('#txtFixedPrice').val().trim();
    }

    data = {
        GroupId: GroupId,
        GroupName: $('#txtGroupName').val().trim(),
        Status: $('#ddlStatus').val(),
        Quantity: $('#txtQuantity').val().trim(),
        DiscountCriteria: $('#ddlDiscountCriteria').val().trim(),
        DiscountValue: DiscountValue,
    }
    $.ajax({
        type: "POST",
        url: "/Pages/ProductGroup.aspx/UpdateProductGroup",
        data: JSON.stringify({ dataValues: JSON.stringify(data), ProductGroupTableValues: ProductGroupTableValues }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            if (response.d == 'true') {
                swal("Success!", "Product Group Updated successfully.", "success", { closeOnClickOutside: false });
                window.location.reload();
                $('#loading').hide();
            }
            else if (response.d == 'Session') {
                $('#loading').hide();
                window.location.href = '/Default.aspx'
            }
            else {
                swal('Warning!', response.d, 'warning', { closeOnClickOutside: false });
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

var CSymbol = "";
function SetCurrency() {
    debugger
    $.ajax({
        type: "POST",
        url: "/Pages/SchemeMaster.aspx/CurrencySymbol",
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

function BindDropdowns() {
    $.ajax({
        type: "POST",
        url: "/Pages/ProductGroup.aspx/BindDropdowns",
        data: "{}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            debugger;
            if (response.d == 'false') {
                swal("", "No product found!", "warning", { closeOnClickOutside: false });
            } else if (response.d == "Session") {
                location.href = '/';
            }
            else {
                debugger;
                var JsonObj = $.parseJSON(response.d);
                var ProductList = JsonObj[0].PL;
                var CategoryList = JsonObj[0].CL;
                var DepartmentList = JsonObj[0].DL;
                var DisTypeList = JsonObj[0].DCL;
                if (ProductList != null) {
                    debugger;
                    var PType = $("#ddlSKU"); var ProVal = 0;
                    $("#ddlSKU option:not(:first)").remove();
                    for (var k = 0; k < ProductList.length; k++) {
                        var Product = ProductList[k];
                        if (Product.IsDefault == 1) {
                            ProVal = Product.A;
                        }
                        var option = $("<option />");
                        option.html(Product.P);
                        option.val(Product.A);
                        PType.append(option);
                    }
                    $("#ddlSKU").select2();
                    $("#ddlSKU").val(ProVal).change();
                }
                $("#ddlDept option").remove();
                if (DepartmentList.length > 0) {
                    $("#ddlDept").append('<option value="0">Select Department</option>');
                    $.each(DepartmentList, function (index, item) {
                        $("#ddlDept").append($("<option></option>").val(DepartmentList[index].A).html(DepartmentList[index].B));
                    });
                    $("#ddlDept").val(0).select2();
                }
                $("#ddlCategory option").remove();
                if (CategoryList.length > 0) {
                    $("#ddlCategory").append('<option value="0">Select Category</option>');
                    $.each(CategoryList, function (index, item) {
                        $("#ddlCategory").append($("<option></option>").val(CategoryList[index].A).html(CategoryList[index].B));
                    });
                    $("#ddlCategory").val(0).select2();
                }
                $("#ddlDiscountCriteria option").remove();
                if (DisTypeList.length > 0) {
                    $("#ddlDiscountCriteria").append('<option value="0">Select Discount Type</option>');
                    $.each(DisTypeList, function (index, item) {
                        $("#ddlDiscountCriteria").append($("<option></option>").val(DisTypeList[index].A).html(DisTypeList[index].B));
                    });
                    $("#ddlDiscountCriteria").val(0).select2();
                }
            }
        },
        failure: function (result) {
            debugger;
            console.log(result.d);
        },
        error: function (result) {
            debugger;
            console.log(result.d);
        }
    });
}

function ShowDiscountTextBox() {
    if ($('#ddlDiscountCriteria').val() == '1') {
        $("#DivDiscountAmount").show();
        $("#DivDiscountPer").hide();
        $("#DivFixedPrice").hide();
        //$("#txtDiscountAmount").val('0.00');
        $("#txtDiscountPer").val('0');
        $("#txtFixedPrice").val('0.00');
    }
    else if ($('#ddlDiscountCriteria').val() == '2') {
        $("#DivDiscountAmount").hide();
        $("#DivDiscountPer").show();
        $("#DivFixedPrice").hide();
        $("#txtDiscountAmount").val('0.00');
        //$("#txtDiscountPer").val('0.00');
        $("#txtFixedPrice").val('0.00');
    }
    else if ($('#ddlDiscountCriteria').val() == '3') {
        $("#DivDiscountAmount").hide();
        $("#DivDiscountPer").hide();
        $("#DivFixedPrice").show();
        $("#txtDiscountAmount").val('0.00');
        $("#txtDiscountPer").val('0');
        //$("#txtFixedPrice").val('0');
    }
    else {
        $("#DivDiscountAmount").hide();
        $("#DivDiscountPer").hide();
        $("#DivFixedPrice").hide();
        $("#txtDiscountAmount").val('0.00');
        $("#txtDiscountPer").val('0');
        $("#txtFixedPrice").val('0.00');
    }
    cal_TotalPrice();
}

function increaseValueSKU() {
    var value = $('#txtQuantity').val();
    value = isNaN(value) ? 1 : value;
    value++;
    $('#txtQuantity').val(value);
}

function ChangeValueSKU(e) {
    var value = $('#txtQuantity').val();
    value = isNaN(value) ? 1 : value;
    value <= 1 ? value = 1 : '';
    $('#txtQuantity').val(value);
}

function decreaseValueSKU(e) {
    var value = $('#txtQuantity').val();
    value = isNaN(value) ? 1 : value;
    value <= 1 ? value = 2 : '';
    value--;
    $('#txtQuantity').val(value);
}

function ChangeDropdown(evt) {
    debugger;
    if ($(evt).attr('id') == 'ddlDept') {
        debugger;
        $("#ddlCategory").val('0').select2();
        $("#ddlSKU").val('0').select2();
    }
    else if ($(evt).attr('id') == 'ddlCategory') {
        debugger;
        $("#ddlDept").val('0').select2();
        $("#ddlSKU").val('0').select2();
    }
    else if ($(evt).attr('id') == 'ddlSKU') {
        debugger;
        $("#ddlDept").val('0').select2();
        $("#ddlCategory").val('0').select2();
    }
    if ($("#ddlDept").val() == '0' && $("#ddlCategory").val() == '0' && $("#ddlSKU").val() == '0') {
        debugger;
        $("#ddlDept").removeAttr('disabled');
        $("#ddlCategory").removeAttr('disabled');
        $("#ddlSKU").removeAttr('disabled');
        $("#spnDept").show();
        $("#spnCat").show();
        $("#spnProduct").show();

    }
    else if ($("#ddlDept").val() != '0') {
        debugger;
        $("#ddlCategory").attr('disabled', 'disabled');
        $("#ddlSKU").attr('disabled', 'disabled');
        $("#spnDept").show();
        $("#spnCat").hide();
        $("#spnProduct").hide();
    }
    else if ($("#ddlCategory").val() != '0') {
        $("#ddlDept").attr('disabled', 'disabled');
        $("#ddlSKU").attr('disabled', 'disabled');
        $("#spnDept").hide();
        $("#spnCat").show();
        $("#spnProduct").hide();
    }
    else if ($("#ddlSKU").val() != '0') {
        debugger;
        $("#ddlDept").attr('disabled', 'disabled');
        $("#ddlCategory").attr('disabled', 'disabled');
        $("#spnDept").hide();
        $("#spnCat").hide();
        $("#spnProduct").show();
    }
    cal_TotalPrice();
}

var SKUIdArray = [];
function CreateMixMatchTable() {
    $('#loading').show();
    if ($("#ddlDept").val() == '0' && $("#ddlCategory").val() == '0' && $("#ddlSKU").val() == '0') {
        $('#loading').hide();
        toastr.error('Select a department, category, or product.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        //validate = 0;
        return false;
    }
    data = {
        DepartmentId: $("#ddlDept").val(),
        CategoryId: $("#ddlCategory").val(),
        SKUId: $("#ddlSKU").val(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/ProductGroup.aspx/CreateMixMatchTable",
        data: JSON.stringify({ dataValue: JSON.stringify(data) }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
       // async: false,
        success: function (response) {
            if (response.d == 'false') {
                $('#loading').hide();
                swal("", "No product found!", "warning", { closeOnClientOutside: false });
            } else if (response.d == "Session") {
                location.href = '/';
            }
            else {
                debugger;
                var JsonObj = $.parseJSON(response.d);
                var SKUList = JsonObj[0].SL;
                var tableHtml = '', i = 0;
                if (SKUList.length > 0) {
                    $.each(SKUList, function (index, item) {
                        debugger;
                        if (SKUIdArray.includes(SKUList[index].SKUId)) {
                            i++;
                        }
                        else {
                            SKUIdArray.push(SKUList[index].SKUId);
                            tableHtml += '<tr>';
                            tableHtml += '    <td class="chkCheckBox text-center" style="width: 3%; vertical-align: middle;">';
                            tableHtml += '        <input type="checkbox" name="table_records" class="chkCheque" onchange="CountSelectedRow()">';
                            tableHtml += '    </td>';
                            tableHtml += '    <td class="SKUAutoId" style="white-space: nowrap; text-align: center; display: none;">' + SKUList[index].SKUId + '</td>';
                            tableHtml += '    <td class="Action" style="white-space: nowrap; text-align: center;display:none;"><a id="deleterow" title="Remove" onclick="deleterow(this)"><span class="fa fa-trash" style="color: red;"></span></a></td>';
                            tableHtml += '    <td class="Department" style="white-space: nowrap; text-align: center">' + SKUList[index].DepartmentName + '</td>';
                            tableHtml += '    <td class="Category1" style="white-space: nowrap; text-align: center">' + SKUList[index].CategoryName + '</td>';
                            tableHtml += '    <td class="SKUName" style="white-space: nowrap; text-align: center">' + SKUList[index].SKUName + '</td>';
                            tableHtml += '    <td class="Unitprice" style="white-space: nowrap; text-align: center">' + SKUList[index].SKUSubTotal + '</td>';
                            tableHtml += '    <td class="UnitDiscount" style="white-space: nowrap; text-align: center; width: 10%;">0</td>';
                            tableHtml += '    <td class="UnitDiscountP" style="white-space: nowrap; text-align: center; width: 10%;">0</td>';
                            tableHtml += '    <td class="Discount" style="white-space: nowrap; text-align: center; display: none;">0</td>';
                            tableHtml += '    <td class="DiscountedUnitPrice" style="white-space: nowrap; text-align: center; width: 10%;">' + SKUList[index].SKUSubTotal + '</td>';
                            tableHtml += '    <td class="TaxPer" style="white-space: nowrap; text-align: center;">' + SKUList[index].taxper + '</td>';
                            tableHtml += '    <td class="Tax" style="white-space: nowrap; text-align: center">0</td>';
                            tableHtml += '    <td class="TaxAutoId" style="white-space: nowrap; align-content: center; display: none;">' + SKUList[index].TaxId + '</td>';
                            tableHtml += '    <td class="Total" style="white-space: nowrap; text-align: center;">' + SKUList[index].SKUTotal + '</td>';
                            tableHtml += '    <td class="ActionId" style="white-space: nowrap; text-align: center; display: none;">ActionId</td>';
                            tableHtml += '</tr>';
                        }
                    });
                    $("#tblProductGroupListBody").prepend(tableHtml);
                    if (i > 0) {
                        if (i == 1) {
                            swal("Warning!", "A product already exists in the table.", "warning", { closeOnClickOutside: false });
                        }
                        else {
                            swal("Warning!", "Some products already exists in the table.", "warning", { closeOnClickOutside: false });
                        }
                    }
                    ResetFilters();
                    cal_TotalPrice();
                    $('#loading').hide();
                }
                else {
                    swal('Warning!', 'No Product Found.', 'warning').then(function () {
                        $('#loading').hide();
                        ResetFilters();
                    });
                }
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

function CountSelectedRow() {
    debugger;
    var Count_Row = 0, TotalAmount = 0;
    $('input:checkbox:checked', '#tblProductGroupList tbody').each(function (index, item) {
        var row = $(item).closest('tr');
        Count_Row += 1;
    });
    if (Count_Row > 0) {
        $("#btnDeleteSelectedRow").removeAttr('disabled');
        $("#btnDeleteSelectedRow").show();
    }
    else {
        $("#btnDeleteSelectedRow").attr('disabled', 'disabled');
        $("#btnDeleteSelectedRow").hide();
    }
}

function DeleteSelectedRow() {
    var Count_Row = 0, TotalAmount = 0;
    if ($('input:checkbox:checked', '#tblProductGroupList tbody').length == 0) {
        swal("Warning!", "Please select at least one product to proceed.", "warning", { closeOnClickOutside: false });
    }
    else {
        var TextString = 'You want to Delete selected rows.';
        var span = document.createElement("span");
        span.innerHTML = TextString;
        swal({
            title: "Are you sure?",
            content: span,
            allowOutsideClick: "false",
            icon: "warning",
            buttons: {
                cancel: {
                    text: "No, Cancel",
                    value: null,
                    visible: true,
                    className: "btn-warning",
                    closeModal: true,
                },
                confirm: {
                    text: "Yes, Proceed",
                    value: true,
                    visible: true,
                    className: "",
                    closeModal: true,
                }
            }
        }).then(function (isConfirm) {
            if (isConfirm) {
                $('input:checkbox:checked', '#tblProductGroupList tbody').each(function (index, item) {
                    debugger;
                    var tempSKUId = $(item).closest('tr').find('.SKUAutoId').text();
                    const indx = SKUIdArray.indexOf(parseInt(tempSKUId));
                    if (indx > -1) { // only splice array when item is found
                        SKUIdArray.splice(indx, 1); // 2nd parameter means remove one item only
                    }
                    $(item).closest('tr').remove();
                    ///swal("", "Product deleted successfully.", "success", { closeOnClickOutside: false });
                    if ($("#tblProductGroupList").length == 0) {
                        $("#tblProductGroupList").hide();
                        $("#ProductGroupEmptyTable").show();
                    }
                    CountRow();
                });
                $("#check-all").prop('checked', false).change();
                swal("Success!", "Product deleted successfully.", "success", { closeOnClickOutside: false });
                //if (Count_Row > 0) {
                //    //$('#BulkChangeModal').modal('show');
                //}
                //else {
                //    swal("Warning!", "Please select at least one product to proceed.", "warning", { closeOnClickOutside: false });
                //}
            }
            else {
                //debugger;
                //ResetBulk();
                //MasterBindProductList(1);
            }
        });
    }
}


function deleterow(e) {
    swal({
        title: "Are you sure?",
        text: "You want to delete this product.",
        icon: "warning",
        showCancelButton: true,
        closeOnClickOutside: false,
        buttons: {
            cancel: {
                text: "No, Cancel",
                value: null,
                visible: true,
                className: "btn-warning",
                closeModal: true,
            },
            confirm: {
                text: "Yes, Delete it",
                value: true,
                visible: true,
                className: "",
                closeModal: true,
            }
        }
    }).then(function (isConfirm) {
        if (isConfirm) {
            deleteItemrecord(e);
        }
    })
}

function deleteItemrecord(e) {
    $(e).closest('tr').remove();
    swal("", "Product deleted successfully.", "success", { closeOnClickOutside: false });
    CountRow();
    if ($("#tblProductGroupList").length == 0) {
        $("#tblProductGroupList").hide();
        $("#ProductGroupEmptyTable").show();
    }
}

function ResetFilters() {
    $("#ddlDept").removeAttr('disabled');
    $("#ddlDept").val('0').select2();
    $("#ddlCategory").removeAttr('disabled');;
    $("#ddlCategory").val('0').select2();
    $("#ddlSKU").removeAttr('disabled');
    $("#ddlSKU").val('0').select2();
}


function CountRow() {
    $("#RowCount").text($("#tblProductGroupListBody tr").length);
}
function cal_TotalPrice() {
    debugger;
    var UnitPrice = 0, DiscountAmt = 0, DiscountPer = 0, TaxPer = 0, TaxAmt = 0, DiscountUnitPrice = 0, TotalPrice = 0;
    if ($("#ddlDiscountCriteria option:selected").val() == '0') {
        $("#tblProductGroupListBody tr").each(function () {
            debugger;
            UnitPrice = $(this).find('.Unitprice').text();
            TaxPer = $(this).find('.TaxPer').text();
            DiscountAmt = 0;
            DiscountPer = 0;
            DiscountUnitPrice = UnitPrice - DiscountAmt;
            TaxAmt = DiscountUnitPrice * TaxPer / 100;
            TotalPrice = DiscountUnitPrice + TaxAmt;
            $(this).find('.Tax').text(parseFloat(TaxAmt).toFixed(2));
            $(this).find('.DiscountedUnitPrice').text(parseFloat(DiscountUnitPrice).toFixed(2));
            $(this).find('.Total').text(parseFloat(TotalPrice).toFixed(2));
            $(this).find('.UnitDiscount').text(parseFloat(DiscountAmt).toFixed(2));
            $(this).find('.UnitDiscountP').text(parseFloat(DiscountPer).toFixed(2));
        });
    }
    else if ($("#ddlDiscountCriteria option:selected").val() == '1') {
        $("#tblProductGroupListBody tr").each(function () {
            debugger;
            UnitPrice = $(this).find('.Unitprice').text();
            TaxPer = $(this).find('.TaxPer').text();
            DiscountAmt = $('#txtDiscountAmount').val().trim();
            if (parseFloat(UnitPrice) < parseFloat(DiscountAmt)) {
                DiscountPer = 100;
                DiscountUnitPrice = 0;
            }
            else {
                DiscountPer = (DiscountAmt * 100) / UnitPrice;
                DiscountUnitPrice = parseFloat(UnitPrice) - parseFloat(DiscountAmt);
            }
            TaxAmt = DiscountUnitPrice * TaxPer / 100;
            TotalPrice = DiscountUnitPrice + TaxAmt;
            $(this).find('.Tax').text(parseFloat(TaxAmt).toFixed(2));
            $(this).find('.DiscountedUnitPrice').text(parseFloat(DiscountUnitPrice).toFixed(2));
            $(this).find('.Total').text(parseFloat(TotalPrice).toFixed(2));
            $(this).find('.UnitDiscount').text(parseFloat(DiscountAmt).toFixed(2));
            $(this).find('.UnitDiscountP').text(parseFloat(DiscountPer).toFixed(2));
        });
    }
    else if ($("#ddlDiscountCriteria option:selected").val() == '2') {
        if (!isNaN(parseFloat($('#txtDiscountPer').val().trim())) && parseFloat($('#txtDiscountPer').val().trim()) <= 100 && parseFloat($('#txtDiscountPer').val().trim()) >= 0) {
            $("#tblProductGroupListBody tr").each(function () {
                debugger;
                UnitPrice = $(this).find('.Unitprice').text();
                TaxPer = $(this).find('.TaxPer').text();
                //DiscountAmt = $('#txtDiscountAmount').val().trim();
                DiscountPer = $('#txtDiscountPer').val().trim();
                DiscountAmt = (UnitPrice * DiscountPer) / 100;
                DiscountUnitPrice = UnitPrice - DiscountAmt;
                TaxAmt = DiscountUnitPrice * TaxPer / 100;
                TotalPrice = DiscountUnitPrice + TaxAmt;
                $(this).find('.Tax').text(parseFloat(TaxAmt).toFixed(2));
                $(this).find('.DiscountedUnitPrice').text(parseFloat(DiscountUnitPrice).toFixed(2));
                $(this).find('.Total').text(parseFloat(TotalPrice).toFixed(2));
                $(this).find('.UnitDiscount').text(parseFloat(DiscountAmt).toFixed(2));
                $(this).find('.UnitDiscountP').text(parseFloat(DiscountPer).toFixed(2));
            });
        }
        else {
            $('#loading').hide();
            $('#txtDiscountPer').val('0.00');
            toastr.error('Please enter valid percentage.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
            //validate = 0;
            return false;
        }
    }
    else if ($("#ddlDiscountCriteria option:selected").val() == '3') {
        $("#tblProductGroupListBody tr").each(function () {
            debugger;
            UnitPrice = $(this).find('.Unitprice').text();
            TaxPer = $(this).find('.TaxPer').text();
            //DiscountAmt = $('#txtDiscountAmount').val().trim();
            //DiscountPer = $('#txtDiscountPer').val().trim();
            DiscountUnitPrice = $('#txtFixedPrice').val().trim();
            if (parseFloat(UnitPrice) < parseFloat(DiscountUnitPrice)) {
                DiscountAmt = 0;
                DiscountPer = 0;
                //TaxAmt = 0;
            }
            else {
                DiscountAmt = UnitPrice - parseFloat(DiscountUnitPrice);
                DiscountPer = (DiscountAmt * 100) / UnitPrice;
            }
            TaxAmt = DiscountUnitPrice * TaxPer / 100;
            TotalPrice = parseFloat(DiscountUnitPrice) + parseFloat(TaxAmt);
            $(this).find('.Tax').text(parseFloat(TaxAmt).toFixed(2));
            $(this).find('.DiscountedUnitPrice').text(parseFloat(DiscountUnitPrice).toFixed(2));
            $(this).find('.Total').text(parseFloat(TotalPrice).toFixed(2));
            $(this).find('.UnitDiscount').text(parseFloat(DiscountAmt).toFixed(2));
            $(this).find('.UnitDiscountP').text(parseFloat(DiscountPer).toFixed(2));
        });
    }
    CountRow();
}


function InsertProductGroup() {
    $('#loading').show();
    debugger;
    if ($('#txtGroupName').val().trim() == '') {
        toastr.error('Please Enter Group Name.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtSKUName").focus();
        $('#loading').hide();
        return false;
    }
    else if ($('#txtQuantity').val().trim() == '' || parseInt($('#txtQuantity').val().trim()) == 0) {
        toastr.error('Please Fill Valid Quantity.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtQuantity").focus();
        $('#loading').hide();
        return false;
    }
    else if ($('#ddlDiscountCriteria').val() == '0') {
        toastr.error('Please Select Discount Type.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $('#loading').hide();
        return false;
    }
    else if ($('#ddlDiscountCriteria').val() == '1' && ($('#txtDiscountAmount').val().trim() == '' || parseFloat($('#txtDiscountAmount').val().trim()) == 0)) {
        toastr.error('Please Fill Discount Amount.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtDiscountAmount").focus();
        $('#loading').hide();
        return false;
    }
    else if ($('#ddlDiscountCriteria').val() == '2' && ($('#txtDiscountPer').val().trim() == '' || parseFloat($('#txtDiscountPer').val().trim()) == 0)) {
        toastr.error('Please Fill Discount Percentage.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtDiscountPer").focus();
        $('#loading').hide();
        return false;
    }
    else if ($('#ddlDiscountCriteria').val() == '3' && ($('#txtFixedPrice').val().trim() == '' || parseFloat($('#txtFixedPrice').val().trim()) == 0)) {
        toastr.error('Please Fill Fixed Amount.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        $("#txtFixedPrice").focus();
        $('#loading').hide();
        return false;
    }
    ProductGroupTable = new Array();
    var i = 0;
    $("#tblProductGroupList #tblProductGroupListBody tr").each(function (index, item) {
        if ($(item).find('.SKUAutoId').text() != '0') {
            ProductGroupTable[i] = new Object();
            ProductGroupTable[i].SKUAutoId = $(item).find('.SKUAutoId').text();
            ProductGroupTable[i].SKUQty = 1;
            //ProductGroupTable[i].Department = $(item).find('.Department').text();
            //ProductGroupTable[i].Category1 = $(item).find('.Category1').text();
            ProductGroupTable[i].Unitprice = parseFloat($(item).find('.Unitprice').text());
            ProductGroupTable[i].UnitDiscount = parseFloat($(item).find('.UnitDiscount').text());
            ProductGroupTable[i].UnitDiscountP = parseFloat($(item).find('.UnitDiscountP').text());
            ProductGroupTable[i].DiscountedUnitPrice = parseFloat($(item).find('.DiscountedUnitPrice').text());
            ProductGroupTable[i].TaxPer = parseFloat($(item).find('.TaxPer').text());
            ProductGroupTable[i].TaxAutoId = $(item).find('.TaxAutoId').text();
            ProductGroupTable[i].Total = parseFloat($(item).find('.Total').text());
            i++;
        }
    });
    if (ProductGroupTable.length <= 0) {
        swal("Warning!", "Please add a product.", "warning", { closeOnClickOutside: false });
        $('#loading').hide();
        $(evt).removeAttr('disabled');
        return;
    }
    var ProductGroupTableValues = JSON.stringify(ProductGroupTable);

    var DiscountValue = 0;
    if ($('#ddlDiscountCriteria').val() == '1') {
        DiscountValue = $('#txtDiscountAmount').val().trim();
    }
    else if ($('#ddlDiscountCriteria').val() == '2') {
        DiscountValue = $('#txtDiscountPer').val().trim();
    }
    else if ($('#ddlDiscountCriteria').val() == '3') {
        DiscountValue = $('#txtFixedPrice').val().trim();
    }

    data = {
        GroupName: $('#txtGroupName').val().trim(),
        Status: $('#ddlStatus').val(),
        Quantity: $('#txtQuantity').val().trim(),
        DiscountCriteria: $('#ddlDiscountCriteria').val().trim(),
        DiscountValue: DiscountValue,
    }
    $.ajax({
        type: "POST",
        url: "/Pages/ProductGroup.aspx/InsertProductGroup",
        data: JSON.stringify({ dataValues: JSON.stringify(data), ProductGroupTableValues: ProductGroupTableValues }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            if (response.d == 'true') {
                swal("Success!", "Product Group added successfully.", "success", { closeOnClickOutside: false });
                ResetMixNMatch();
                $('#loading').hide();
            }
            else if (response.d == 'Session') {
                $('#loading').hide();
                window.location.href = '/Default.aspx'
            }
            else {
                swal('Warning!', response.d, 'warning', { closeOnClickOutside: false });
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

function ResetMixNMatch() {
    var getQueryString = function (field, url) {
        var href = url ? url : window.location.href;
        var reg = new RegExp('[?&]' + field + '=([^&#]*)', 'i');
        var string = reg.exec(href);
        return string ? string[1] : null;
    };
    GroupAutoId = getQueryString('PageId');
    if (GroupAutoId != null) {
        window.location.href = '/Pages/ProductGroup.aspx';
    }
    else {
        $('#txtGroupName').val('');
        $('#txtQuantity').val('1');
        $("#ddlDept").val('0').select2();
        $("#ddlCategory").val('0').select2();
        $("#ddlSKU").val('0').select2();
        SKUIdArray = [];
        $("#tblProductGroupListBody").text('');
        $('#ddlDiscountCriteria').val('0').select2().change();
        $("#btnUpdate").hide();
        $("#btnSave").show();
    }
}


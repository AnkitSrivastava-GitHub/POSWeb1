$(document).ready(function () {   

    SetCurrency();
    BindDropDowns();
    MasterBindProductList(1);
    $("#ddlStatus").select2();
    $("#ddlBulkStatus").select2();
    CountSelectedRow();
    $('.select2-selection__rendered').removeAttr("title");    
});

var CSymbol = "";
function SetCurrency() {
    debugger
    $.ajax({
        type: "POST",
        url: "/Pages/ProductList.aspx/CurrencySymbol",
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

function Pagevalue(e) {
    MasterBindProductList(parseInt($(e).attr("page")));
};
function BindDropDowns() {
    $('#loading').show();
    $.ajax({
        type: "POST",
        url: "/pages/ProductMaster.aspx/BindDropDowns",
        data: "{}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        beforeSend: function () {
            $('#fade').show();
        },
        complete: function () {
            $('#fade').hide();
        },
        success: function (response) {
            if (response.d == 'Session') {
                window.location.href = '/Default.aspx'
            }
            else if (response.d == 'false') {
                swal('Error!', 'Some error occured.', 'error', { closeOnClientOutside: false });
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var Category = xml.find("Table");
                var Brand = xml.find("Table1");
                var Tax = xml.find("Table2");
                var AgeRestriction = xml.find("Table3");
                var DeptList = xml.find("Table4");
                var MeasurementUnitList = xml.find("Table7");

                $("#ddlDept option").remove();
                $("#ddlDept").append($("<option></option>").val(0).html("All Department"));
                $.each(DeptList, function () {
                    $("#ddlDept").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("DepartmentName").text().trim()));
                });
                $("#ddlDept").select2();

                $("#ddlBulkDept option").remove();
                $("#ddlBulkDept").append($("<option></option>").val(0).html("Select Department"));
                $.each(DeptList, function () {
                    $("#ddlBulkDept").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("DepartmentName").text().trim()));
                });
                $("#ddlBulkDept").select2();

                $("#ddlbrand option").remove();
                $("#ddlbrand").append($("<option></option>").val(0).html("All Brand"));
                $.each(Brand, function () {
                    $("#ddlbrand").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("BrandName").text().trim()));
                });
                $("#ddlbrand").select2();

                $("#ddlBulkbrand option").remove();
                $("#ddlBulkbrand").append($("<option></option>").val(0).html("Select Brand"));
                $.each(Brand, function () {
                    $("#ddlBulkbrand").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("BrandName").text().trim()));
                });
                $("#ddlBulkbrand").select2();

                $("#ddlcategory option").remove();
                $("#ddlcategory").append($("<option></option>").val(0).html('All Category'));
                $.each(Category, function () {
                    $("#ddlcategory").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("CategoryName").text().trim()));
                });
                $("#ddlcategory").select2();

                $("#ddlBulkcategory option").remove();
                $("#ddlBulkcategory").append($("<option></option>").val(0).html('Select Category'));
                $.each(Category, function () {
                    $("#ddlBulkcategory").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("CategoryName").text().trim()));
                });
                $("#ddlBulkcategory").select2();

                $("#ddlBulkTax option").remove();
                $("#ddlBulkTax").append($("<option></option>").val(0).html('Select Tax'));
                $.each(Tax, function () {
                    $("#ddlBulkTax").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("TaxName").text().trim()));
                });
                $("#ddlBulkTax").select2();

                $.each(MeasurementUnitList, function () {
                    $("#ddlBulkMeasureUnit").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("UnitName").text().trim()));
                });
                $("#ddlBulkMeasureUnit").val('0').select2();
                $('#loading').hide();

                $("#ddlBulkAgeRest option").remove();
                $("#ddlBulkAgeRest").append($("<option></option>").val(0).html("Select Age Restriction"));
                $.each(AgeRestriction, function () {
                    $("#ddlBulkAgeRest").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("AgeRestrictionName").text().trim()));
                });
                $("#ddlBulkAgeRest").select2();
            }
          
        },
        failure: function (response) {
            alert(response.d);
            $('#loading').hide();
        },
        error: function (response) {
            alert(response.d);
            $('#loading').hide();
        }
    });
}

function MasterBindProductList(pageIndex) {
    debugger;
    $('#loading').show();
    data = {
        Product: $("#txtPname").val().trim(),
        DeptId: $("#ddlDept").val(),
        Brand: $("#ddlbrand").val(),
        Category: $("#ddlcategory").val(),
        Status: $("#ddlStatus").val(),
        pageIndex: pageIndex,
        PageSize: $("#ddlPageSize").val(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/ProductList.aspx/BindProductList",
        data: JSON.stringify({ dataValue: JSON.stringify(data) }),
        dataType: "json",
        contentType: "application/json;charset=utf-8",
        //async: false,
        //beforeSend: function () {
        //    $('#loading').show();
        //},
        //complete: function () {
        //    $('#loading').hide();
        //},
        success: function (response) {
            if (response.d == 'Session') {
                window.location.href = '/Default.aspx'
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var ProductList = xml.find("Table1");
                var pager = xml.find("Table");
                var status = "";
                if (ProductList.length > 0) {
                    if (pager.length > 0) {
                        $("#spSortBy").text($(pager).find("SortByString").text());
                    }
                    if (parseInt($(pager).find("RecordCount").text()) > 10) {
                        $('#ddlPageSize').show();
                    }
                    else {
                        $('#ddlPageSize').hide();
                    }
                    $("#spSortBy").show();
                    $("#EmptyTable").hide();
                    $("#tblProductList tbody tr").remove();
                    var Action = '',html='';
                    $.each(ProductList, function () {
                        Action = "<a href='/Pages/ProductMaster.aspx?PageId=" + $(this).find("AutoId").text() + "'><img src='/Style/img/edit.png' title='Edit' class='imageButton' /></a>&nbsp;&nbsp;<a onclick='ViewPackingDetail(" + $(this).find("AutoId").text() + ")' style='ursor: point;'><img src='/Style/img/ViewDetails2.png' title='Packing Details' class='imageButton' /></a>";
                        if ($(this).find("Status").text() == '1') {
                            status = "<span class='badge badge badge-pill' style='background-color:#40992b'>Active</span>"
                        }
                        else {
                            status = "<span class='badge badge badge-pill' style='background-color:#e52525'>Inactive</span>"
                        }
                        html += '<tr class="thead">';
                        html += '    <td class="chkCheckBox text-center" style="width: 3%; vertical-align: middle;">';
                        html += '        <input type="checkbox" name="table_records" class="chkCheque" onchange="CountSelectedRow()">';
                        html += '    </td>';
                        html += '    <td class="Action" style="width: 50px; text-align: center; vertical-align: middle;">' + Action +'</td>';
                        html += '    <td class="ProductId" style="width: 50px; text-align: center; vertical-align: middle;display:none;">' + $(this).find("AutoId").text() +'</td>';
                        html += '    <td class="ProductName" style="white-space: nowrap; text-align: center; vertical-align: middle;">' + $(this).find("ProductName").text() +'</td>';
                        html += '    <td class="GroupName" style="white-space: nowrap; text-align: center; display: none;">' + $(this).find("GroupName").text() +'</td>';
                        html += '    <td class="Dept" style="width: 150px; text-align: center; vertical-align: middle;">' + $(this).find("DepartmentName").text() +'</td>';
                        html += '    <td class="Brand" style="width: 150px; text-align: center; vertical-align: middle;">' + $(this).find("BrandName").text() +'</td>';
                        html += '    <td class="Category1" style="width: 250px; text-align: center; vertical-align: middle;">' + $(this).find("CategoryName").text() +'</td>';
                        html += '    <td class="CurrentStock" style="width: 250px; text-align: center; vertical-align: middle;">' + $(this).find("StockQTY").text() +'</td>';
                        html += '    <td class="AlertStock" style="width: 250px; text-align: center; vertical-align: middle;">' + $(this).find("AlertQty").text() +'</td>';
                        html += '    <td class="CreationDetail" style="width: 330px; text-align: center; vertical-align: middle;">'+$(this).find("CreationDetail").text()+'</td>';
                        html += '    <td class="Status" style="width: 100px; text-align: center; vertical-align: middle;">' + status +'</td>';
                        html += '</tr>';
                    });
                    $("#tblProductList").append(html);
                    $("#tblProductList").show();
                }
                else {
                    $("#EmptyTable").show();
                    $("#tblProductList").hide();
                    $("#spSortBy").hide();
                    $("#ddlPageSize").hide();
                }

                $(".Pager").ASPSnippets_Pager({
                    ActiveCssClass: "current",
                    PagerCssClass: "pager",
                    PageIndex: parseInt(pager.find("PageIndex").text()),
                    PageSize: parseInt(pager.find("PageSize").text()),
                    RecordCount: parseInt(pager.find("RecordCount").text())
                });
                if ($('#ddlPageSize').val() == '0') {
                    $('#Pager').hide();
                }
                else {
                    $('#Pager').show();
                }
            }
            $('#loading').hide();
        },
        error: function (err) {
            swal("Error!", err.d, "error", { closeOnClientOutside: false });
            $('#loading').hide();
        },
        failure: function (err) {
            swal("Error!", err.d, "error", { closeOnClientOutside: false });
            $('#loading').hide();
        }
    });
}

function CloseModalPackingList() {
    $('#ProductPackingsModal').modal('hide');
}

function ViewPackingDetail(ProductId) {
    editProductDetail(ProductId);
    //$('#ProductPackingsModal').modal('show');
}


function editProductDetail(id) {
    debugger;
    data = {
        AutoId: id,
    }
    $.ajax({
        type: "POST",
        url: "/Pages/ProductMaster.aspx/editProductDetail",
        data: JSON.stringify({ dataValue: JSON.stringify(data) }),
        dataType: "json",
        contentType: "application/json;charset=utf-8",
        async: false,
        beforeSend: function () {
            $('#fade').show();
        },
        complete: function () {
            $('#fade').hide();
        },
        success: function (response) {
            if (response.d == 'Session') {
                window.location.href = '/Default.aspx'
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                //var Department = xml.find("Table");
                //var Category = xml.find("Table1");
                //var Brand = xml.find("Table2");
                //var Tax = xml.find("Table3");
                //var AgeRestriction = xml.find("Table4");
                //var ProductDetail = xml.find("Table5");
                var UnitDetail = xml.find("Table6");

                //$("#ddlDept option").remove();
                //$.each(Department, function () {
                //    $("#ddlDept").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("DepartmentName").text().trim()));
                //});
                //$("#ddlDept").select2();

                //$("#ddlbrand option").remove();
                //$.each(Brand, function () {
                //    $("#ddlbrand").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("BrandName").text().trim()));
                //});
                //$("#ddlbrand").select2();

                //$("#ddlcategory option").remove();
                //$.each(Category, function () {
                //    $("#ddlcategory").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("CategoryName").text().trim()));
                //});
                //$("#ddlcategory").select2();

                //$("#ddltax option").remove();
                //$.each(Tax, function () {
                //    $("#ddltax").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("TaxName").text().trim()));
                //});

                //$("#ddlAgeRestriction option").remove();
                //$.each(AgeRestriction, function () {
                //    $("#ddlAgeRestriction").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("AgeRestrictionName").text().trim()));
                //});
                //$("#hdnProductId").val(id);
                //$("#ddlbrand").val($(ProductDetail).find('BrandId').text()).select2();
                //$("#ddlcategory").val($(ProductDetail).find('CategoryId').text()).select2();
                //$("#txtProductName").val($(ProductDetail).find('ProductName').text());
                //$("#ddlAgeRestriction").val($(ProductDetail).find('AgeRestrictionId').text());
                //$("#ddlStatus").val($(ProductDetail).find('Status').text());
                //$("#txtDescription").val($(ProductDetail).find('Description').text());
                //if ($(ProductDetail).find('ImagePath').text() != '' && $(ProductDetail).find('ImagePath').text() != null && $(ProductDetail).find('ImagePath').text() != undefined) {
                //    $("#imgPath").val($(ProductDetail).find('ImagePath').text());
                //    $('#imgPreview').attr('src', "../Images/ProductImages/" + $(ProductDetail).find('ImagePath').text());
                //}
                //if ($(ProductDetail).find('ViewImage').text() == "1") {
                //    document.getElementById("chkviewimage").checked = true;
                //}
                //else {
                //    document.getElementById("chkviewimage").checked = false;
                //}
                if (UnitDetail.length > 0) {
                    $("#PackingEmptyTable").hide();
                    $("#tblProductPackingList tbody tr").remove();
                    var i = 1;
                    var row = $("#tblProductPackingList thead tr:first-child").clone(true);
                    $.each(UnitDetail, function () {
                        $(".Action", row).html("<img src='/Style/img/edit.png' title='Edit' class='imageButton' onclick='EditPacking(" + $(this).find("AutoId").text() + ")'>");
                        $(".Packing", row).html($(this).find("PackingName").text());
                        $(".NoOfPieces", row).html($(this).find("NoOfPieces").text());
                        $(".PieceSize", row).html($(this).find("SizeOfSinglePiece").text());
                        $(".Barcode", row).html($(this).find("Barcode").text());
                        $(".CP", row).html($(this).find("CostPrice").text()).css('text-align', 'right');
                        $(".SP", row).html($(this).find("SellingPrice").text()).css('text-align', 'right');
                        $(".SecondaryUnitPrice", row).html($(this).find("SecondaryUnitPrice").text()).css('text-align', 'right');
                        $(".TaxId", row).html($(this).find("TaxAutoId").text());
                        $(".Tax", row).html($(this).find("TaxPer").text() + ' %');
                        $(".WebAvailability", row).html($(this).find("IsShowOnWeb").text());
                        if ($(this).find("ManageStock").text() == '1') {
                            $(".MS", row).html('Yes');
                        }
                        else {
                            $(".MS", row).html('No');
                        }
                        $(".InStock", row).html($(this).find("AvailableQty").text());
                        $(".LowStock", row).html($(this).find("AlertQty").text());
                        if ($(this).find("ImageName").text() != '') {
                            $(".PreviewImage", row).html('<a style="cursor:pointer;" onclick="ViewImage(\'' + $(this).find("ImageName").text() + '\')">View</a>');
                            $(".ImageName", row).html($(this).find("ImageName").text());
                        }
                        else {
                            $(".PreviewImage", row).html('No Image');
                            $(".ImageName", row).html('');
                        }

                        if ($(this).find("Status").text() == '1') {
                            $(".Status", row).html("<span class='badge badge badge-pill' style='background-color:#40992b;font-size:14px;'>Active</span>");
                        }
                        else {
                            $(".Status", row).html("<span class='badge badge badge-pill' style='background-color:#e52525;font-size:14px;'>Inactive</span>");
                        }
                        $("#tblProductPackingList").append(row);
                        row = $("#tblProductPackingList tbody tr:last-child").clone(true);
                        i++;
                    });
                    $("#tblProductPackingList").show();
                }
                else {
                    $("#PackingEmptyTable").show();
                    $("#tblProductPackingList").hide();
                }
                $('#ProductPackingsModal').modal('show');
                //$(".ManageStatus").show();
                //$("#btnSave").hide();
                //$("#btnUpdate").show();
                //$("#divupdate").show();
                //$("#btnAddPacking").show();
                //$("#btnUpdatePacking").hide();
                //$("#btnInsertPacking").hide();

            }
            $('#loading').hide();
        },
        error: function (err) {
            swal("Error!", err.d, "error", { closeOnClientOutside: false });
            $('#loading').hide();
        },
        failure: function (err) {
            swal("Error!", err.d, "error", { closeOnClientOutside: false });
            $('#loading').hide();
        }
    });

}

function ViewImage(ImageName) {
    debugger;
    $('#imgPackingImage').attr('src', '/Images/ProductImages/' + ImageName);
    $('#ModalPackingImage').modal('show');
}

function ClosePackingImageModal() {
    $('#imgPackingImage').attr('src', '#');
    $('#ModalPackingImage').modal('hide');
}


function CountSelectedRow() {
    debugger;
    var Count_Row = 0, TotalAmount = 0;
    $('input:checkbox:checked', '#tblProductList tbody').each(function (index, item) {
        var row = $(item).closest('tr');
        Count_Row += 1;
    });
    //if (Count_Row > 0) {

    //    $("#btnBulkChange").attr("disabled", false);
    //    $("#btnBulkChange").removeAttr("title");
    //    //OpenBulkModal();
    //}
    //else {
    //    $("#btnBulkChange").attr("disabled", "disabled");
    //    $("#btnBulkChange").attr("title", "This only works if the any check box is selected");
    //}
}

function OpenBulkModal() {
    var Count_Row = 0, TotalAmount = 0;
    $('input:checkbox:checked', '#tblProductList tbody').each(function (index, item) {
        var row = $(item).closest('tr');
        Count_Row += 1;
    });
    if (Count_Row > 0) {
        $('#BulkChangeModal').modal('show');
    }
    else {
        swal("Warning!", "Please select at least one product to proceed.", "warning", { closeOnClickOutside: false });
    }
}


function CloseBulkModal() {
    ResetBulk();
    $('#BulkChangeModal').modal('hide');
}


function ChangeProductInBulk(VerifcationCode) {
    debugger;
    $('#loading').show();
    var ProductIds = [], ProductIdString = '',flag=0;
    $('input:checkbox:checked', '#tblProductList tbody').each(function (index, item) {
        var row = $(item).closest('tr');
        ProductIds.push(row.find('.ProductId').text());
    });
    if (ProductIds.length > 0) {
        ProductIdString = ProductIds.join(",");
    }
    else {
        $('#loading').hide();
        toastr.error('Please check atleast one checkbox.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($('#ddlBulkDept').val() != 0 && $('#ddlBulkDept').val() != '' && $('#ddlBulkDept').val() != null) {
        flag = 1;
    }
    if ($('#ddlBulkbrand').val() != 0 && $('#ddlBulkbrand').val() != '' && $('#ddlBulkbrand').val() != null) {
        flag = 1;
    }
    if ($('#ddlBulkcategory').val() != 0 && $('#ddlBulkcategory').val() != '' && $('#ddlBulkcategory').val() != null) {
        flag = 1;
    }
    if ($('#ddlBulkAgeRest').val() != 0 && $('#ddlBulkAgeRest').val() != '' && $('#ddlBulkAgeRest').val() != null) {
        flag = 1;
    }
    if ($('#ddlBulkTax').val() != 0 && $('#ddlBulkTax').val() != '' && $('#ddlBulkTax').val() != null) {
        flag = 1;
    }
    if (parseFloat($('#txtBulkProductSize').val().trim()) != 0 && $('#txtBulkProductSize').val().trim() != '' && $('#txtBulkProductSize').val().trim() != null) {
        flag = 1;
    }
    if ($('#ddlBulkMeasureUnit').val() != 0 && $('#ddlBulkMeasureUnit').val() != '' && $('#ddlBulkMeasureUnit').val() != null) {
        flag = 1;
    }
    if (parseFloat($('#txtCostPrice').val().trim()) != 0 && $('#txtCostPrice').val().trim() != '' && $('#txtCostPrice').val().trim() != null) {
        flag = 1;
    }
    if (parseFloat($('#txtSellingPrice').val().trim()) != 0 && $('#txtSellingPrice').val().trim() != '' && $('#txtSellingPrice').val().trim() != null) {
        flag = 1;
    }
    if (parseFloat($('#txtSecondaryUnitPrice').val().trim()) != 0 && $('#txtSecondaryUnitPrice').val().trim() != '' && $('#txtSecondaryUnitPrice').val().trim() != null) {
        flag = 1;
    }
    if ($('#ddlBulkStatus').val() != '2' && $('#ddlBulkStatus').val() != '' && $('#ddlBulkStatus').val() != null) {
        flag = 1;
    }
    //if (ProductIdString!='') {
    //    flag = 1;
    //}
    if (flag == 0) {
        $('#loading').hide();
        swal("Warning!", "Please select at least one field.", "warning", { closeOnClickOutside: false });
        return false;
    }
    data = {
        DeptId: $('#ddlBulkDept').val(),
        brandId: $('#ddlBulkbrand').val(),
        CategoryId: $('#ddlBulkcategory').val(),
        AgeRestId: $('#ddlBulkAgeRest').val(),
        TaxId: $('#ddlBulkTax').val(),
        ProductSize: $('#txtBulkProductSize').val().trim(),
        MeasureUnitId: $('#ddlBulkMeasureUnit').val(),
        CostPrice: $('#txtCostPrice').val().trim(),
        SellingPrice: $('#txtSellingPrice').val().trim(),
        SecUnitPrice: $('#txtSecondaryUnitPrice').val().trim(),
        Status: $('#ddlBulkStatus').val(),
        ProductIdString: ProductIdString,
        VerificationCode: VerifcationCode
    }
    $.ajax({
        type: "POST",
        url: "/pages/ProductList.aspx/ChangeInBulk",
        data: JSON.stringify({ dataValue: JSON.stringify(data) }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        beforeSend: function () {
            $('#fade').show();
        },
        complete: function () {
            $('#fade').hide();
        },
        success: function (response) {
            if (response.d == 'false') {
                swal("Error!", "Some error occured.", "error", { closeOnClickOutside: false })
            }
            else if (response.d == 'Session') {
                window.location.href = '/Default.aspx'
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var ResposeTable = xml.find("Table");
                if ($(ResposeTable).find('ResponseCode').text() == '0') {
                    debugger;
                    var TextString = '';
                    if ($(ResposeTable).find('ResponseMessage').text().split(', ').length == 1) {
                        TextString += '<br/>Below product has multiple packing and its cost price, unit price and secondary unit price will not update.<br/>';
                    }
                    else {
                        TextString += '<br/>Below products have multiple packing and their cost price, unit price and secondary unit price will not update.<br/>';
                    }
                    TextString += $(ResposeTable).find('ResponseMessage').text();
                    TextString += '<br/><br/><b>Do you want to proceed?</b>';
                    var span = document.createElement("span");
                    span.innerHTML = TextString;
                    swal({
                        title: "Confirmation!",
                        content: span,
                        allowOutsideClick: "false",
                        //icon: "warning",
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
                            debugger;
                            ChangeProductInBulk(1);
                        }
                        else {
                            debugger;
                            ResetBulk();
                            MasterBindProductList(1);
                        }
                    });
                }
                else if ($(ResposeTable).find('ResponseCode').text() == '1') {
                    debugger;
                    ResetBulk();
                    swal("Success!", "Product details changed successfully.", "success", { closeOnClickOutside: false }).then(function () {
                        MasterBindProductList(1);
                    });
                }
            }
            $('#loading').hide();
        },
        failure: function (response) {
            alert(response.d);
            $('#loading').hide();
        },
        error: function (response) {
            alert(response.d);
            $('#loading').hide();
        }
    });
}

function ResetBulk() {
    debugger;
    $('#BulkChangeModal').modal('hide');
    $("#check-all").prop('checked', false).change();
    $('#ddlBulkDept').val('0').select2();
    $('#ddlBulkbrand').val('0').select2();
    $('#ddlBulkcategory').val('0').select2();
    $('#ddlBulkAgeRest').val('0').select2();
    $('#ddlBulkTax').val('0').select2();
    $('#txtBulkProductSize').val('');
    $('#ddlBulkMeasureUnit').val('0').select2();
    $('#txtCostPrice').val('0.00');
    $('#txtSellingPrice').val('0.00');
    $('#txtSecondaryUnitPrice').val('0.00');
    $('#ddlBulkStatus').val('2').select2();
}

function fillsecondPrice(e) {
    debugger;
    if ($(e).val().trim() == '' || isNaN(parseFloat($(e).val().trim()))) {
        $(e).val('0.00')
        $(e).focus();
    }
    else {
        $("#txtSellingPrice").val(parseFloat($(e).val().trim()).toFixed(2));
        $("#txtSecondaryUnitPrice").val(parseFloat($(e).val().trim()).toFixed(2));
    }
}
$(document).ready(function () {
    BindVendor();
    BindPOList(1);
});

function BindVendor() {
    $.ajax({
        type: "POST",
        url: "/Pages/POMaster.aspx/BindVendor",
        data: "{}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            if (response.d == 'false') {
                swal("", "No product found!", "warning", { closeOnClickOutside: false });
            } else if (response.d == "Session") {
                location.href = '/';
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var VendorList = xml.find("Table");
                $("#ddlVendor option").remove();
                $("#ddlVendor").append('<option value="0">Select Vendor</option>');
                $.each(VendorList, function () {
                    $("#ddlVendor").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("VendorName").text()));
                });
                $("#ddlVendor").select2();
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

function Pagevalue(e) {
    BindPOList(parseInt($(e).attr("page")));
};

function BindPOList(pageIndex) {
    data = {
        PONumber: $('#txtPONumber').val().trim(),
        VendorAutoId: $('#ddlVendor').val(),
        Status: $('#ddlStatus').val(),
        pageIndex: pageIndex,
        PageSize: $("#ddlPageSize").val(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/POList.aspx/BindPOList",
        data: JSON.stringify({ dataValues: JSON.stringify(data) }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            if (response.d == 'false') {
                swal("", "No PO details found!", "warning", { closeOnClientOutside: false });
            } else if (response.d == "Session") {
                location.href = '/';
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var pager = xml.find("Table");
                var POList = xml.find("Table1");
                var status = "";
                if (POList.length > 0) {
                    if (pager.length > 0) {
                        $("#spPOSortBy").text($(pager).find("SortByString").text());
                    }
                    if (parseInt($(pager).find("RecordCount").text()) > 10) {
                        $('#ddlPageSize').show();
                    }
                    else {
                        $('#ddlPageSize').hide();
                    }
                    $("#spPOSortBy").show();
                    //$("#ddlPageSize").show();
                    $("#POEmptyTable").hide();
                    $("#tblPOList tbody tr").remove();
                    var row = $("#tblPOList thead tr:first-child").clone(true);
                    $.each(POList, function () {
                        status = '';
                        debugger;
                        $(".POAutoId", row).html($(this).find("AutoId").text());
                        $(".PONumber", row).html($(this).find("PoNumber").text());
                        $(".Vendor", row).html($(this).find("VendorName").text());
                        $(".PODate", row).html($(this).find("PoDate").text());
                        $(".POItems", row).html("<a title='View PO Items' style='cursor:pointer;' onclick='ViewPOItem(" + $(this).find("AutoId").text() + ")'>View Items</a>");
                        /* $(".CreatedDetails", row).html($(this).find("CreatedDetails").text());*/
                        $(".UpdationDetails", row).html($(this).find("UpdatedDetails").text());
                        if ($(this).find("Status").text() == '1' && $(this).find("PIMAutoId").text() == '0') {
                            status = "<span class='badge badge badge-pill' style='background-color:#FFC436;font-size:14px;'>New</span>"
                        }
                        else if ($(this).find("Status").text() == '1' && $(this).find("PIMAutoId").text() != '0') {
                            status = "<span class='badge badge badge-pill' style='background-color:#005B41;font-size:14px;'>Process </span>"
                        }
                        else if ($(this).find("Status").text() == '2') {
                            status = "<span class='badge badge badge-pill' style='background-color:#0094ff;font-size:14px;'>Closed</span>"
                        }
                        else if ($(this).find("Status").text() == '0') {
                            status = "<span class='badge badge badge-pill' style='background-color:#e52525;font-size:14px;'>Inactive</span>"
                        }
                        else {
                            status = "";
                        }
                        $(".PO_Status", row).html(status);
                        if ($(this).find("Status").text() == '1' && $(this).find("PIMAutoId").text() == '0') {
                            $(".Action", row).html("<a style='' href='/Pages/POMaster.aspx?PageId=" + $(this).find("AutoId").text() + "'><img src='/Style/img/edit.png' title='Edit' class='imageButton' style='height: 20px;width: 20px;' /></a>&nbsp;&nbsp;&nbsp;<a title='Generate Invoice' href='/Pages/GenerateInvoice.aspx?PageId=" + $(this).find("AutoId").text() + "'><img src='/Images/invoice.png' title='Generate Invoice' class='imageButton' style='height: 20px;width: 20px;' /></a>&nbsp;&nbsp;&nbsp;<a title='Delete' onclick='deletePO(" + $(this).find("AutoId").text() + ")'><span class='fa fa-trash' style='color: red;'></span></a>");
                        }
                        else if ($(this).find("Status").text() == '1' && $(this).find("PIMAutoId").text() != '0') {
                            $(".Action", row).html("<a style='' href='/Pages/POMaster.aspx?PageId=" + $(this).find("AutoId").text() + "'><img src='/Style/img/View.png' title='Show detail' class='imageButton' style='height: 30px;width: 30px;' /></a>&nbsp;&nbsp;&nbsp;<a title='Generate Invoice' href='/Pages/GenerateInvoice.aspx?PageId=" + $(this).find("AutoId").text() + "'><img src='/Images/invoice.png' title='Generate Invoice' class='imageButton' style='height: 20px;width: 20px;' /></a>");
                        }
                        else if ($(this).find("Status").text() == '2') {
                            $(".Action", row).html("<a style='' href='/Pages/POMaster.aspx?PageId=" + $(this).find("AutoId").text() + "'><img src='/Style/img/View.png' title='Show detail' class='imageButton' style='height: 30px;width: 30px;' /></a>");
                        }
                        //else if ($(this).find("PIMAutoId").text() != '0' && $(this).find("Status").text() != '1') {
                        //    $(".Action", row).html("<a style='' href='/Pages/POMaster.aspx?PageId=" + $(this).find("AutoId").text() + "'><img src='/Style/img/View.png' title='Show detail' class='imageButton' style='height: 30px;width: 30px;' /></a>&nbsp;&nbsp;&nbsp;<a title='Delete' onclick='deletePO(" + $(this).find("AutoId").text() + ")'><span class='fa fa-trash' style='color: red;'></span></a>");
                        //}
                        //else if ($(this).find("PIMAutoId").text() != '0' && $(this).find("Status").text() != '2') {
                        //    $(".Action", row).html("<a style='' href='/Pages/POMaster.aspx?PageId=" + $(this).find("AutoId").text() + "'><img src='/Style/img/View.png' title='Show detail' class='imageButton' style='height: 30px;width: 30px;' /></a>");

                        //}
                        else if ($(this).find("Status").text() == '0') {
                            //$(".Action", row).html("<a style='' href='/Pages/POMaster.aspx?PageId=" + $(this).find("AutoId").text() + "'><img src='/Style/img/edit.png' title='Edit' class='imageButton' style='height: 20px;width: 20px;' /></a>&nbsp;&nbsp;&nbsp;<a title='Delete' onclick='deletePO(" + $(this).find("AutoId").text() + ")'><span class='fa fa-trash' style='color: red;'></span></a>");
                            $(".Action", row).html("<a style='' href='/Pages/POMaster.aspx?PageId=" + $(this).find("AutoId").text() + "'><img src='/Style/img/edit.png' title='Edit' class='imageButton' style='height: 20px;width: 20px;' /></a>&nbsp;&nbsp;&nbsp;<a title='Delete' onclick='deletePO(" + $(this).find("AutoId").text() + ")'><span class='fa fa-trash' style='color: red;'></span></a>");
                        }
                            $("#tblPOList").append(row);
                        row = $("#tblPOList tbody tr:last-child").clone(true);
                    });
                    $("#tblPOList").show();
                }
                else {
                    $("#POEmptyTable").show();
                    $("#tblPOList").hide();
                    $("#spPOSortBy").hide();
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
        failure: function (result) {
            console.log(result.d);
        },
        error: function (result) {
            console.log(result.d);
        }
    });
}


function deletePO(POId) {
    swal({
        title: "Are you sure?",
        text: "You want to delete this PO.",
        icon: "warning",
        showCancelButton: true,
        closeOnClickOutside: false,
        buttons: {
            cancel: {
                text: "No",
                value: null,
                visible: true,
                className: "btn-warning",
                closeModal: true,
            },
            confirm: {
                text: "Yes",
                value: true,
                visible: true,
                className: "",
                closeModal: true,
            }
        }
    }).then(function (isConfirm) {
        if (isConfirm) {
            DeletePOfromDB(POId);
        }
    })
}

function DeletePOfromDB(POId) {
    $.ajax({
        type: "POST",
        url: "/Pages/POList.aspx/DeletePO",
        data: "{'POAutoId':'" + POId + "'}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            if (response.d == 'false') {
                swal("", "No unit details found!", "warning", { closeOnClickOutside: false });
            } else if (response.d == "Session") {
                location.href = '/';
            }
            else {
                if (response.d == 'Succeess') {
                    $('#loading').hide();
                    swal("Success!", "PO deleted successfully.", "success", { closeOnClickOutside: false })
                    BindPOList(1);
                }
                else {
                    swal("Error!", "Failed.", "error", { closeOnClickOutside: false });
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

function ViewPOItem(Id) {
    $.ajax({
        type: "POST",
        url: "/Pages/POList.aspx/ViewPOItem",
        data: "{'PoAutoId':'" + Id + "'}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            if (response.d == 'false') {
                swal("", "No unit details found!", "warning", { closeOnClickOutside: false });
            } else if (response.d == "Session") {
                location.href = '/';
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var POProductList = xml.find("Table");
                if (POProductList.length > 0) {
                    $("#tblPOProductList tbody tr").remove();
                    var row = $("#tblPOProductList thead tr:first-child").clone(true);
                    $.each(POProductList, function () {
                        status = '';
                        $(".PoItemAutoId", row).html($(this).find("AutoId").text());
                        $(".ProductAutoId", row).html($(this).find("ProductId").text());
                        $(".ProductName", row).html($(this).find("ProductName").text());
                        $(".UnitType", row).html($(this).find("PackingName").text());
                        $(".UnitAutoId", row).html($(this).find("PackingId").text());
                        $(".Quantity", row).html($(this).find("RequiredQty").text());
                        $(".Action", row).html("<a title='Delete' onclick=''><span class='fa fa-trash' style='color: red;'></span></a>");
                        $("#tblPOProductList").append(row);
                        row = $("#tblPOProductList tbody tr:last-child").clone(true);
                    });
                    $("#tblPOProductList").show();
                }
                else {
                    $("#POEmptyTable").show();
                    $("#tblPOProductList").hide();
                }
                $('#POProductListModal').modal('show');
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
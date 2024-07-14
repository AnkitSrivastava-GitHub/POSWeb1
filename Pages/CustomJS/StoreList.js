$(document).ready(function () {
    BindStoreList(1);    
});
function Pagevalue(e) {
    BindStoreList(parseInt($(e).attr("page")));
};

function BindStoreList(pageIndex) {
    $('#loading').show();
    data = {
        companyName: $("#txtSCompanyName").val().trim(),
        ContactPerson: $("#txtSContact").val().trim(),
        MobileNo: $("#txtSmob").val().trim(),
        Website: $("#txtSWebsite").val().trim(),
        Status: $("#ddlStoreStatus").val(),
        pageIndex: pageIndex,
        PageSize: $("#ddlPageSize").val(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/StoreList.aspx/BindStoreList",
        data: JSON.stringify({ dataValue: JSON.stringify(data) }),
        dataType: "json",
        contentType: "application/json;charset=utf-8",
        //async: false,
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
                debugger;
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var StoreList = xml.find("Table1");
                var pager = xml.find("Table");
                var status = "";
                if (StoreList.length > 0) {
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
                    //$("#ddlPageSize").show();
                    $("#EmptyTable").hide();
                    $("#tblStoreList tbody tr").remove();
                    var row = $("#tblStoreList thead tr:first-child").clone(true);
                    $.each(StoreList, function () {
                        debugger;
                        status = '';
                        $(".StoreAutoId", row).html($(this).find("StoreAutoId").text());
                        $(".CompanyName", row).html($(this).find("CompanyName").text());
                        $(".ContactName", row).html($(this).find("ContactName").text());
                        $(".Website", row).html($(this).find("Website").text());
                        $(".Address", row).html($(this).find("BillingAddress").text() + "<br/>" + $(this).find("City").text() + " , " + $(this).find("State").text() + " " + $(this).find("Country").text() + "-" + $(this).find("ZipCode").text());
                        $(".City", row).html($(this).find("City").text());
                        $(".State", row).html($(this).find("State").text());
                        $(".Country", row).html($(this).find("Country").text());
                        $(".Currency", row).html($(this).find("Currency").text());
                        $(".ZipCode", row).html($(this).find("ZipCode").text());
                        $(".Mob", row).html($(this).find("PhoneNo").text());
                        if ($(this).find("Status").text() == '1') {
                            status = "<span class='badge badge badge-pill' style='background-color:#40992b'>Open</span>"
                        }
                        else {
                            status = "<span class='badge badge badge-pill' style='background-color:#e52525'>Closed</span>"
                        }
                        $(".Status", row).html(status);

                        //$(".Action", row).html("<a id='btnDeleteAge' onclick='isDeleteStore(" + $(this).find("AutoId").text() + ")' title='Delete' style='cursor: pointer'><i class='fa fa-trash' style='color:red'></i></a>&nbsp;&nbsp;&nbsp;<a style='' href='/Pages/CompanyProfile.aspx?PageId=" + $(this).find("AutoId").text() + "'><img src='/Style/img/edit.png' title='Edit' class='imageButton' /></a>");
                        $(".Action", row).html("<a style='' href='/Pages/CompanyProfile.aspx?PageId=" + $(this).find("AutoId").text() + "'><img src='/Style/img/edit.png' title='Edit' class='imageButton' /></a>&nbsp;&nbsp;&nbsp;<a id='btnDeleteAge' onclick='isDeleteStore(" + $(this).find("AutoId").text() + ")' title='Delete' style='cursor: pointer'><i class='fa fa-trash' style='color:red'></i></a>");

                        $("#tblStoreList").append(row);
                        row = $("#tblStoreList tbody tr:last-child").clone(true);
                    });
                    $("#tblStoreList").show();
                }
                else {
                    $("#EmptyTable").show();
                    $("#tblStoreList").hide();
                    $("#spSortBy").hide();
                    $("#ddlPageSize").hide();
                }
                //var pager = xml.find("Table");
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
            swal("Error!", err.d, "error", { closeOnClickOutside: false });
            $('#loading').hide();
        },
        failure: function (err) {
            swal("Error!", err.d, "error", { closeOnClickOutside: false });
            $('#loading').hide();
        }

    });
}
function NumericInput(event) {
    debugger;
    if (!(event.keyCode == 85
        || event.keyCode == 46
        /* || (event.keyCode >= 35 && event.keyCode <= 40)*/
        || (event.keyCode >= 48 && event.keyCode <= 57)
    )) {
        event.preventDefault();
    }
}
function isDeleteStore(id) {
    $('#loading').show();
    swal({
        title: "Are you sure?",
        text: "You want to delete this Store.",
        icon: "warning",
        showCancelButton: true,
        closeOnClickOutside: false,
        buttons: {
            cancel: {
                text: "No",
                value: null,
                visible: true,
                className: "btn-warning",
                closeModal: false,
            },
            confirm: {
                text: "Yes",
                value: true,
                visible: true,
                className: "",
                closeModal: false
            }
        },
    }).then((isConfirm) => {
        if (isConfirm) {

            data = {
                AutoId: id,
            }
            $.ajax({
                type: "POST",
                url: "/Pages/StoreList.aspx/DeleteStore",
                data: JSON.stringify({ dataValue: JSON.stringify(data) }),
                dataType: "json",
                contentType: "application/json;charset=utf-8",
                //async: false,
                beforeSend: function () {
                    $('#fade').show();
                },
                complete: function () {
                    $('#fade').hide();
                },
                success: function (response) {
                    if (response.d == 'true') {
                        swal("Success!", "Store deleted successfully.", "success", { closeOnClickOutside: false });
                        BindStoreList(1);
                    }
                    else if (response.d == 'Session') {
                        window.location.href = '/Default.aspx'
                    }
                    else {
                        swal("Error!", response.d, "error", { closeOnClickOutside: false });
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
        else {
            swal("", "Cancelled.", "error", { closeOnClickOutside: false });
            $('#loading').hide();
        }
    });
}


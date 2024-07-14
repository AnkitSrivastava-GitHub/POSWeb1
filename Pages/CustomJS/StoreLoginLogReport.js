$(document).ready(function () {
    $('.date').pickadate({
        format: 'mm/dd/yyyy',
        formatSubmit: 'mm/dd/yyyy',
        selectYears: true,
        selectMonths: true,
    });
    var now = new Date();
    var day = ("0" + now.getDate()).slice(-2);
    var month = ("0" + (now.getMonth() + 1)).slice(-2);
    var today = (month) + "/" + (day) + "/" + now.getFullYear();
    $(".date").val(today);
    $('.select2-selection__rendered').hover(function () {
        $(this).removeAttr('title');
    });
    /*BindDropDowns();*/
    //BindUser();
    BindStoreLoginLogList(1);
});


function Pagevalue(e) {
    BindStoreLoginLogList(parseInt($(e).attr("page")));
};
function BindUser() {
    debugger;
    $.ajax({
        type: "POST",
        url: "/Pages/StoreLoginLogReport.aspx/BindUserList",
        data: "{}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            if (response.d == 'false') {
                swal("", "No User Found!", "warning", { closeOnClickOutside: false });
            } else if (response.d == "Session") {
                location.href = '/';
            }
            else {
                debugger;
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var UserList = xml.find("Table");
                $("#ddlUser option").remove();
                $("#ddlUser").append('<option value="0">All User</option>');
                $.each(UserList, function () {
                    $("#ddlUser").append($("<option></option>").val($(this).find("UserAutoId").text()).html($(this).find("UserName").text()));
                });
                $("#ddlUser").select2();
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
function BindStoreLoginLogList(pageIndex) {
    debugger;
    if ($("#txtFromDate").val().trim() != '' && $("#txtToDate").val().trim() && (Date.parse($("#txtFromDate").val()) > Date.parse($("#txtToDate").val()))) {
        //$('#loading').hide();
        toastr.error('To date must be greater than from date.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    $('#loading').show();
    data = {
        FirstName: $("#txtEmpName").val().trim(),
        FromDate: $("#txtFromDate").val(),
        ToDate: $("#txtToDate").val(),
        /*Store: $("#ddlStore").val(),*/
        Status: $("#ddlStatus").val(),
        pageIndex: pageIndex,
        PageSize: $("#ddlPageSize").val(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/StoreLoginLogReport.aspx/BindStoreLoginLogList",
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
                var StoreLoginLogList = xml.find("Table1");
                var pager = xml.find("Table");
                if (StoreLoginLogList.length > 0) {
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
                    $("#tblStoreLoginList tbody tr").remove();
                    var row = $("#tblStoreLoginList thead tr:first-child").clone(true);
                    $.each(StoreLoginLogList, function () {
                        debugger;
                        /*status = '';*/
                        $(".StoreAutoId", row).html($(this).find("CompanyId").text());
                        $(".StoreName", row).html($(this).find("CompanyName").text());
                        $(".UserName", row).html($(this).find("UserName").text());
                        $(".IPAddress", row).html($(this).find("IPAddress").text());
                        $(".UserType", row).html($(this).find("UserType").text());
                        //$(".Store", row).html($(this).find("Store").text());
                        //$(".Terminal", row).html($(this).find("TerminalName").text());
                        $(".Status", row).html($(this).find("Status").text());
                        $(".LoginDateTime", row).html($(this).find("LoginTime").text());
                        $("#tblStoreLoginList").append(row);
                        row = $("#tblStoreLoginList tbody tr:last-child").clone(true);
                    });
                    $("#tblStoreLoginList").show();
                }
                else {
                    $("#EmptyTable").show();
                    $("#tblStoreLoginList").hide();
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

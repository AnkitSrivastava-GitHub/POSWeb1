$(document).ready(function () {

    //$('.Date').datepicker({
    //    changeMonth: true,//this option for allowing user to select month
    //    changeYear: true, //this option for allowing user to select from year range
    //    dateFormat: 'mm/dd/yy', //indian date format
    //    // yearRange: "-70:-6",
    //});

    $('.date').pickadate({
        format: 'mm/dd/yyyy',
        formatSubmit: 'mm/dd/yyyy',
        selectYears: true,
        selectMonths: true,
    });
    //SearchCustomer(1);
    var now = new Date();
    var day = ("0" + now.getDate()).slice(-2);
    var month = ("0" + (now.getMonth() + 1)).slice(-2);
    var today = (month) + "/" + (day) + "/" + now.getFullYear();
    $(".date").val(today);
    $('.select2-selection__rendered').hover(function () {
        $(this).removeAttr('title');
    });
    BindDropDowns();
    BindUser();
    BindUserList(1);
});

function BindDropDowns() {
    $('#loading').show();
    $.ajax({
        type: "POST",
        url: "/pages/VendorMaster.aspx/BindDropDowns",
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
                var StateList = xml.find("Table");
                var CompanyList = xml.find("Table1");

                $("#ddlStore option").remove();
                $("#ddlStore").append('<option value="0">All</option>');
                $.each(CompanyList, function () {
                    $("#ddlStore").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("CompanyName").text()));
                });
                $("#ddlStore").select2();
                $('#loading').hide();
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

function Pagevalue(e) {
    BindUserList(parseInt($(e).attr("page")));
};
function BindUser() {
    debugger;
    $.ajax({
        type: "POST",
        url: "/Pages/LogInLogDetail.aspx/BindUser",
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
function BindUserList(pageIndex) {
    debugger;
    if ($("#txtFromDate").val().trim() != '' && $("#txtToDate").val().trim() && (Date.parse($("#txtFromDate").val()) > Date.parse($("#txtToDate").val()))) {
        //$('#loading').hide();
        toastr.error('To date must be greater than from date.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    $('#loading').show();
    data = {
        FirstName: $("#ddlUser").val(),
        FromDate: $("#txtFromDate").val(),
        ToDate: $("#txtToDate").val(),
        /*Store: $("#ddlStore").val(),*/
        Status: $("#ddlStatus").val(),
        pageIndex: pageIndex,
        PageSize: $("#ddlPageSize").val(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/LogInLogDetail.aspx/BindUserList",
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
                var UserList = xml.find("Table1");
                var pager = xml.find("Table");
                if (UserList.length > 0) {
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
                    $("#tblUserList tbody tr").remove();
                    var row = $("#tblUserList thead tr:first-child").clone(true);
                    $.each(UserList, function () {
                        debugger;
                        status = '';
                        $(".UserAutoId", row).html($(this).find("UserAutoId").text());
                        $(".UserName", row).html($(this).find("UserName").text());
                        $(".IPAddress", row).html($(this).find("IPAddress").text());
                        $(".UserType", row).html($(this).find("UserType").text());
                        //$(".Store", row).html($(this).find("Store").text());
                        //$(".Terminal", row).html($(this).find("TerminalName").text());
                        $(".ddlStatus", row).html($(this).find("Status").text());
                        $(".Time", row).html($(this).find("LogInDate").text());
                        $("#tblUserList").append(row);
                        row = $("#tblUserList tbody tr:last-child").clone(true);
                    });
                    $("#tblUserList").show();
                }
                else {
                    $("#EmptyTable").show();
                    $("#tblUserList").hide();
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

$(document).ready(function () {
    var now = new Date();
    $('.date').pickadate({
        format: 'mm/dd/yyyy',
        formatSubmit: 'mm/dd/yyyy',
        selectYears: true,
        selectMonths: true,
        yearRange: "-70:-6",
        max: [month, today, now.getFullYear()]
    });
    
    var day = ("0" + now.getDate()).slice(-2);
    var month = ("0" + (now.getMonth() + 1)).slice(-2);
    var today = (month) + "/" + (day) + "/" + now.getFullYear();
    $(".date").val(today);
    $('.select2-selection__rendered').hover(function () {
        $(this).removeAttr('title');
    });

    BindTerminal();
    BindTerminalList(1);
})
function Pagevalue(e) {
    BindTerminalList(parseInt($(e).attr("page")));
};

function BindTerminal() {
    debugger;
    $.ajax({
        type: "POST",
        url: "/Pages/TerminalLoginReport.aspx/BindTerminal",
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
                $("#ddlterminal option").remove();
                $("#ddlterminal").append('<option value="0">All Terminal</option>');
                $.each(UserList, function () {
                    $("#ddlterminal").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("TerminalName").text()));
                });
                $("#ddlterminal").select2();
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

function BindTerminalList(pageIndex) {
    debugger;
    if ($("#txtFromDate").val().trim() != '' && $("#txtToDate").val().trim() && (Date.parse($("#txtFromDate").val()) > Date.parse($("#txtToDate").val()))) {
        //$('#loading').hide();
        toastr.error('To date must be greater than from date.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtFromDate").val().trim() != '' && $("#txtToDate").val().trim() == '' || $("#txtFromDate").val().trim() == '' && $("#txtToDate").val().trim() != '') {
        //$('#loading').hide();
        toastr.error('Both date required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    $('#loading').show();
    data = {
        
        TerminalId: $("#ddlterminal").val(),
        FromDate: $("#txtFromDate").val(),
        ToDate: $("#txtToDate").val(),
        pageIndex: pageIndex,
        PageSize: $("#ddlPageSize").val(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/TerminalLoginReport.aspx/BindTerminalList",
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
                var TerminalList = xml.find("Table1");
                var pager = xml.find("Table");
                if (TerminalList.length > 0) {
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
                    $("#tblTerminalList tbody tr").remove();
                    var row = $("#tblTerminalList thead tr:first-child").clone(true);
                    $.each(TerminalList, function () {
                        debugger;
                        $(".AutoId", row).html($(this).find("AutoId").text());
                        $(".TerminalName", row).html($(this).find("TerminalName").text());
                        $(".CurrentUser", row).html($(this).find("CurrentUser").text());
                        $(".Time", row).html($(this).find("LoginTime").text());
                        $("#tblTerminalList").append(row);
                        row = $("#tblTerminalList tbody tr:last-child").clone(true);
                    });
                    $("#tblTerminalList").show();
                }
                else {
                    $("#EmptyTable").show();
                    $("#tblTerminalList").hide();
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
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
    BindEmployeeList();
    BindClockInOutReport(1);
});

function BindEmployeeList() {
    $.ajax({
        type: "POST",
        url: "/Pages/ClockInOutReport.aspx/BindEmployeeList",
        data: "{}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            if (response.d == 'false') {
                swal("", "No Employee Found!", "warning", { closeOnClickOutside: false });
            } else if (response.d == "Session") {
                location.href = '/';
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var EmpList = xml.find("Table");
                var EmpTypeList = xml.find("Table1");
                $("#ddlEmployee option").remove();
                $("#ddlEmployee").append('<option value="0">All Employee</option>');
                $.each(EmpList, function () {
                    $("#ddlEmployee").append($("<option></option>").val($(this).find("UserAutoId").text()).html($(this).find("Name").text()));
                });
                $("#ddlEmployee").select2();
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
    BindClockInOutReport(parseInt($(e).attr("page")));
};

function BindClockInOutReport(pageIndex) {
    if ($("#txtFromDate").val().trim() != '' && $("#txtToDate").val().trim() && (Date.parse($("#txtFromDate").val()) > Date.parse($("#txtToDate").val()))) {
        toastr.error('To date must be greater than from date.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtFromDate").val().trim() != '' && $("#txtToDate").val().trim() == '' || $("#txtFromDate").val().trim() == '' && $("#txtToDate").val().trim() != '') {
        toastr.error('Both date required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    data = {
        EmpAutoId: $('#ddlEmployee').val(),
        FromDate: $("#txtFromDate").val(),
        ToDate: $("#txtToDate").val(),
        pageIndex: pageIndex,
        PageSize: $("#ddlPageSize").val(),

    }
    $.ajax({
        type: "POST",
        url: "/Pages/ClockInOutReport.aspx/BindClockInOutReport",
        data: JSON.stringify({ dataValues: JSON.stringify(data) }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            if (response.d == 'false') {
                swal("", "No Detail Found!", "warning", { closeOnClickOutside: false });
            } else if (response.d == "Session") {
                location.href = '/';
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var pager = xml.find("Table");
                var ClockInOut = xml.find("Table1");
                var status = "";
                if (ClockInOut.length > 0) {
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
                    $("#tblClockInOutList tbody tr").remove();
                    var row = $("#tblClockInOutList thead tr:first-child").clone(true);
                    $.each(ClockInOut, function () {
                        status = '';
                        $(".ClockInOutAutoId", row).html($(this).find("AutoId").text());
                        $(".UserName", row).html($(this).find("EmpName").text());
                        $(".ClockIn", row).html($(this).find("ClockIN").text());
                        $(".Remark", row).html($(this).find("Remark").text()).css('text-align', 'justify'); 
                        $(".ClockOut", row).html($(this).find("ClockOUT").text());
                        $(".COutRemark", row).html($(this).find("CloseRemark").text()).css('text-align', 'justify');
                        $(".TotalTime", row).html($(this).find("TotalTime").text());
                        $("#tblClockInOutList").append(row);
                        row = $("#tblClockInOutList tbody tr:last-child").clone(true);
                    });
                    $("#tblClockInOutList").show();
                }
                else {
                    $("#EmptyTable").show();
                    $("#tblClockInOutList").hide();
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
        failure: function (result) {
            console.log(result.d);
        },
        error: function (result) {
            console.log(result.d);
        }
    });
}
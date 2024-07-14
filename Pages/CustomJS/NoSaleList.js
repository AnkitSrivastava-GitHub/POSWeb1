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
    BindNoSaleReport(1);
});

function BindEmployeeList() {
    $.ajax({
        type: "POST",
        url: "/Pages/NoSaleList.aspx/BindEmployeeList",
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
                    $("#ddlEmployee").append($("<option></option>").val($(this).find("UserAutoId").text()).html($(this).find("EmpName").text()));
                });
                $("#ddlEmployee").select2();

                $("#ddlUserType option").remove();
                $("#ddlUserType").append('<option value="0">All</option>');
                $.each(EmpTypeList, function () {
                    $("#ddlUserType").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("UserType").text()));
                });
                $("#ddlUserType").select2();
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
    BindNoSaleReport(parseInt($(e).attr("page")));
};

function BindNoSaleReport(pageIndex) {
    if ($("#txtFromDate").val().trim() != '' && $("#txtToDate").val().trim() && (Date.parse($("#txtFromDate").val()) > Date.parse($("#txtToDate").val()))) {
        //$('#loading').hide();
        toastr.error('To date must be greater than from date.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtFromDate").val().trim() != '' && $("#txtToDate").val().trim() == '' || $("#txtFromDate").val().trim() == '' && $("#txtToDate").val().trim() != '') {
        toastr.error('Both date required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    //if ($("#txtToDate").val().trim() == '') {
    //    //$('#loading').hide();
    //    toastr.error('To Date Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
    //    validate = 0;
    //    return false;
    //}
    data = {
        UserType: $("#ddlUserType").val(),
        EmpAutoId: $('#ddlEmployee').val(),
        FromDate: $("#txtFromDate").val(),
        ToDate: $("#txtToDate").val(),
        pageIndex: pageIndex,
        PageSize: $("#ddlPageSize").val(),
        
    }
    $.ajax({
        type: "POST",
        url: "/Pages/NoSaleList.aspx/BindNoSaleReport",
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
                var NoSaleList = xml.find("Table1");
                var status = "";
                if (NoSaleList.length > 0) {
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
                    $("#tblNoSaleList tbody tr").remove();
                    var row = $("#tblNoSaleList thead tr:first-child").clone(true);
                    $.each(NoSaleList, function () {
                        status = '';
                        $(".NosaleAutoId", row).html($(this).find("AutoId").text());
                        $(".OpenBy", row).html($(this).find("EmpName").text());
                        $(".Terminal", row).html($(this).find("TerminalName").text());
                        $(".Time", row).html($(this).find("OpenDate").text());
                        $(".UserType", row).html($(this).find("UserType").text());
                        $(".Remark", row).html($(this).find("Remark").text()).css('text-align','justify');
                        $("#tblNoSaleList").append(row);
                        row = $("#tblNoSaleList tbody tr:last-child").clone(true);
                    });
                    $("#tblNoSaleList").show();
                }
                else {
                    $("#EmptyTable").show();
                    $("#tblNoSaleList").hide();
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
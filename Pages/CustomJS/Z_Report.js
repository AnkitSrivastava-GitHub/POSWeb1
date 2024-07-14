$(document).ready(function () {    
    debugger;
    var now = new Date();
    $('.date').pickadate({
        format: 'mm/dd/yyyy',
        formatSubmit: 'mm/dd/yyyy',
        clear: false,
        backspace: false,
        selectYears: true,
        selectMonths: true,
        yearRange: "-70:-6",
        max: [month, today, now.getFullYear()]
    });
    $("#txtDate").on('keyup', function (event) {
        const key = event.key; // const {key} = event; ES6+
        if (key === "Backspace" || key === "Delete") {
            $("#txtDate").val(filledDate);
            return false;
        }
    });
    var day = ("0" + now.getDate()).slice(-2);
    var month = ("0" + (now.getMonth() + 1)).slice(-2);
    var today = (month) + "/" + (day) + "/" + now.getFullYear();
    $(".date").val(today);
    $('.select2-selection__rendered').hover(function () {
        $(this).removeAttr('title');
    });
    BindTerminalList();
    $("#ddlTerminal").change().select2();
    SearchZ_Report();
});
var filledDate = '';

function getShiftList() {
    if ($("#txtDate").val() != '') {
        filledDate = $("#txtDate").val();
    }
    data = {
        ReportDate: $("#txtDate").val().trim(),
        TerminalId: $("#ddlTerminal").val(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/CategorySalesReport.aspx/getShiftList",
        data: JSON.stringify({ dataValue: JSON.stringify(data) }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            if (response.d == 'false') {
                swal("", "No Shift Found!", "warning", { closeOnClickOutside: false });
            } else if (response.d == "Session") {
                location.href = '/';
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var ShiftList = xml.find("Table");
                $("#ddlAllShift option").remove();
                if (ShiftList.length > 0) {
                    $("#ddlAllShift").append('<option value="0">All Shift</option>');
                    $.each(ShiftList, function () {
                        $("#ddlAllShift").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("shiftName").text()));
                    });
                }
                else {
                    $("#ddlAllShift").append('<option value="0">All Shift</option>');
                }
                $("#ddlAllShift").select2();
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

async function BindTerminalList() {
    $.ajax({
        type: "POST",
        url: "/Pages/Z_Report.aspx/BindTerminalList",
        data: "{}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            if (response.d == 'false') {
                swal("", "No Terminal Found!", "warning", { closeOnClickOutside: false });
            } else if (response.d == "Session") {
                location.href = '/';
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var TerminalList = xml.find("Table");
                $("#ddlTerminal option").remove();
                //$("#ddlTerminal").append('<option value="0">Select Terminal</option>');
                $.each(TerminalList, function () {
                    $("#ddlTerminal").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("TerminalName").text()));
                });
                $("#ddlTerminal").select2();
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


function PrintZ_Report() {
    swal({
        title: '',
        text: "Do you want to print the Z Report?",
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
            },
        }
    }).then(function (isConfirm) {
        if (isConfirm) {
            var TerminalId = $('#ddlTerminal').val();
            var ZReportDate = $('#txtDate').val();
            var ShiftId = $('#ddlAllShift').val();
            var z = 1;
            window.open("/Pages/Print_Z_Report.html?dt=" + TerminalId + "&dt1=" + ShiftId + "&ddt=" + ZReportDate + "&ddl=" + z, "popUpWindow", "height=600,width=1030,left=10,top=10,,scrollbars=yes,menubar=no");
        }
    });
    
}

function SearchZ_Report() {
    debugger;
    var TerminalId = $('#ddlTerminal').val();
    var ZReportDate = $('#txtDate').val();
    var ShiftId = $('#ddlAllShift').val();
    var z = 0;
    $("#ZReportIFrame").attr('src', '/Pages/Print_Z_Report.html?dt="' + TerminalId + '"&dt1="' + ShiftId + '"&ddt="' + ZReportDate + "&ddl=" + z+'"');
    //document.getElementById('ZReportIFrame').innerHTML = '<iframe src="/Pages/Print_Z_Report.html?dt="' + TerminalId + ' "&ddt="' + ZReportDate+'"/>';
}
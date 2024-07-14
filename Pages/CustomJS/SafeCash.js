$(document).ready(function () {
    SetCurrency();
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
    $("#txtStartDate").val(today); $("#txtEndDate").val(today);
    BindSafeCashList(1);
    BindDropDowns();
    $(".modal").on('shown.bs.modal', function () {
        $(this).find("input:visible:first").focus();
    });
});

var CSymbol = "";

function SetCurrency() {
    debugger
    $.ajax({
        type: "POST",
        url: "/Pages/SafeCash.aspx/CurrencySymbol",
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
    BindSafeCashList(parseInt($(e).attr("page")));
}

function process(input) {
    let value = input.value;
    let numbers = value.replace(/[^0-9\.]/g, '');
    input.value = numbers;
}

function BindDropDowns() {
    $.ajax({
        type: "POST",
        url: "/Pages/PayoutMaster.aspx/bindTerminal",
        data: "{}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            if (response.d == 'false') {
                swal("", "No Terminal Found!", "warning", { closeOnClickOutside: false });
            } else if (response.d == "Session") {
                swal("", "Session expired!", "warning", { closeOnClickOutside: false }).then(function () {
                    location.href = '/Default.aspx';
                });
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var StateList = xml.find("Table");

                $("#ddlTerminal option").remove();
                $("#ddlSTerminal option").remove();
                $("#ddlTerminal").append('<option value="0">Select Terminal</option>');
                $("#ddlSTerminal").append('<option value="0">All Terminal</option>');
                $.each(StateList, function () {
                    $("#ddlTerminal").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("TerminalName").text()));
                    $("#ddlSTerminal").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("TerminalName").text()));
                });
                $("#ddlTerminal").select2().next().css('width', '403px');
                $("#ddlSTerminal").select2();
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

function InsertSafeCash() {
    $('#loading').show();
    var validate = 1;
    debugger;
    if ($("#ddlTerminal").val() == '' || $("#ddlTerminal").val() == '0') {
        $('#loading').hide();
        toastr.error('Terminal Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#ddlMode").val() == '' || $("#ddlMode").val() == '0') {
        $('#loading').hide();
        toastr.error('Mode Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if (parseFloat($("#txtAmount").val()) == 0 || $("#txtAmount").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Amount Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }

    if (validate == 1) {
        data = {
            Terminal: $("#ddlTerminal").val(),
            Amount: parseFloat($("#txtAmount").val()).toFixed(2),
            Mode: $("#ddlMode option:selected").val(),
            Remark: $("#txtRemark").val(),
            Status: $("#ddlStatus option:selected").val()
        }
        $.ajax({
            type: "POST",
            url: "/Pages/SafeCash.aspx/InsertSafeCash",
            data: JSON.stringify({ dataValue: JSON.stringify(data) }),
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
                if (response.d == 'Session') {
                    $('#loading').hide();
                    window.location.href = '/Default.aspx'
                }
                else if (response.d == 'Insufficient Safe Cash Amount!') {
                    $('#loading').hide();
                    swal("Warning!", response.d, "warning", { closeOnClickOutside: false });
                }
                else {
                    var xmldoc = $.parseXML(response.d);
                    var xml = $(xmldoc);
                    var SafeCashList = xml.find("Table");
                    var AID = '';
                    $.each(SafeCashList, function () {
                        if ($(this).find("AutoId").text() != "") {
                            AID = $(this).find("AutoId").text();
                        }
                    });
                    swal("Success!", "Safe Cash added successfully.", "success", { closeOnClickOutside: false }).then(function () {
                        PrintSafeCash(AID);
                        $('#loading').hide();
                        BindSafeCashList(1);
                        Reset();
                        CloseModel();
                    });
                }

                //else {
                //    $('#loading').hide();
                //    swal("Error!", response.d, "error", { closeOnClickOutside: false });
                //}
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
        })
    }
}

function PrintSafeCash(AutoId) {
    debugger;
    window.open("/Pages/SafeCashSlip.html?dt=" + AutoId, "popUpWindow", "height=600,width=1030,left=10,top=10,,scrollbars=yes,menubar=no");
}
function BindSafeCashList(pageIndex) {
    //$("#Total").text('$0.00');
    debugger
    $('#loading').show();
    if ($("#txtStartDate").val().trim() != '' && $("#txtEndDate").val().trim() != '' && (Date.parse($("#txtStartDate").val()) > Date.parse($("#txtEndDate").val()))) {
        $('#loading').hide();
        toastr.error('To date must be greater than from date.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }

    data = {
        Terminal: $("#ddlSTerminal").val().trim() || 0,
        Amount: parseFloat($("#txtAmount1").val()) || 0,
        Mode: $("#ddlMode2").val(),
        FromDate: $("#txtStartDate").val(),
        ToDate: $("#txtEndDate").val(),
        pageIndex: pageIndex,
        PageSize: $("#ddlPageSize").val(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/SafeCash.aspx/BindSafeCashList",
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
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var ModuleList = xml.find("Table1");
                var pager = xml.find("Table");
                var TotalAmt = xml.find("Table2");
                var status = "";
                $.each(TotalAmt, function () {
                    debugger
                    if ($(this).find("Total").text() == '') {
                        $("#Total", row).html(CSymbol + '0.00');
                    }
                    else {
                        if (parseFloat($(this).find("Total").text()) < 0) {
                            var T = parseFloat($(this).find("Total").text()) - parseFloat($(this).find("Total").text() * 2);
                            $("#Total", row).html('-' + CSymbol + parseFloat(T).toFixed(2));
                        }
                        else {
                            $("#Total", row).html(CSymbol + $(this).find("Total").text());
                        }
                    }
                    //$("#OTotal", row).html('$' + $(this).find("OpenTotal").text());
                });
                if (ModuleList.length > 0) {
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
                    $("#tblSafeCashList tbody tr").remove();
                    var row = $("#tblSafeCashList thead tr:first-child").clone(true);
                    var TotalDep = 0, TotalWith = 0;
                    $.each(ModuleList, function () {
                        debugger;
                        status = '';
                        $(".SafeCashAutoId", row).html($(this).find("AutoId").text());
                        if ($(this).find("Mode").text() == 1) {
                            $(".Mode", row).html('Deposit');
                            TotalDep += parseFloat($(this).find("Amount").text());
                        }
                        else {
                            $(".Mode", row).html('Withdraw');
                            TotalWith += parseFloat($(this).find("Amount").text());
                        }

                        $(".Amount", row).html($(this).find("Amount").text()).css('text-align', 'right');
                        $(".Remark", row).html($(this).find("Remark").text());
                        $(".CreatedDate", row).html($(this).find("CreatedDate").text());
                        $(".CreatedBy", row).html($(this).find("CreatedBy").text());
                        $(".Terminal", row).html($(this).find("TerminalName").text());
                        if ($(this).find("Status").text() == 0) {
                            $(".Status", row).html('Open');
                            //    $(".Action", row).html("<a id='btnDeleteSafe' onclick='isDeleteSafe(" + $(this).find("AutoId").text() + "," + $(this).find("Mode").text() + ")' title='Delete' style='cursor: pointer'><i class='fa fa-trash' style='color:red'></i></a>&nbsp;&nbsp;&nbsp;<a style='' Onclick='editSafeCash(" + $(this).find("AutoId").text() + ")'><img src='/Style/img/edit.png' title='Edit' class='imageButton' /></a>");
                            $(".Action", row).html("<a style='' Onclick='editSafeCash(" + $(this).find("AutoId").text() + ")'><img src='/Style/img/edit.png' title='Edit' class='imageButton' /></a>&nbsp;&nbsp;&nbsp;<a id='btnDeleteSafe' onclick='isDeleteSafe(" + $(this).find("AutoId").text() + "," + $(this).find("Mode").text() + ")' title='Delete' style='cursor: pointer'><i class='fa fa-trash' style='color:red'></i></a>&nbsp;&nbsp;&nbsp;<a id = 'btnPrintSafe' onclick = 'PrintSafeCash(" + $(this).find("AutoId").text() + ")' title = 'Print' style = 'cursor: pointer' > <i class='fa fa-print' style='color:black'></i></a >");

                        }
                        else {
                            $(".Status", row).html('Close');
                            $(".Action", row).html("<a id = 'btnPrintSafe' onclick = 'PrintSafeCash(" + $(this).find("AutoId").text() + ")' title = 'Print' style = 'cursor: pointer' > <i class='fa fa-print' style='color:black'></i></a >");
                        }

                        $("#tblSafeCashList").append(row);
                        row = $("#tblSafeCashList tbody tr:last-child").clone(true);
                    });
                    var TotalAmt = TotalDep - TotalWith;
                    $("#spn_TotalSafe").text((CSymbol + parseFloat(TotalAmt).toFixed(2)).replace(CSymbol + '-', '-' + CSymbol));
                    $("#tblSafeCashList").show();
                }
                else {
                    $("#EmptyTable").show();
                    $("#tblSafeCashList").hide();
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

function isDeleteSafe(id, Mode) {
    $('#loading').show();
    swal({
        title: "Are you sure?",
        text: "You want to delete this Safe Cash.",
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
                SafeCashAutoId: id,
            }
            $.ajax({
                type: "POST",
                url: "/Pages/SafeCash.aspx/DeleteSafeCash",
                data: JSON.stringify({ dataValue: JSON.stringify(data) }),
                dataType: "json",
                contentType: "application/json;charset=utf-8",
                beforeSend: function () {
                    $('#fade').show();
                },
                complete: function () {
                    $('#fade').hide();
                },
                success: function (response) {
                    if (response.d == 'true') {
                        if (Mode == 1) {
                            swal("Success!", "Deposit Safe Cash deleted successfully.", "success", { closeOnClickOutside: false });
                        }
                        else {
                            swal("Success!", "Withdraw Safe Cash deleted successfully.", "success", { closeOnClickOutside: false });
                        }
                        Reset();
                        BindSafeCashList(1);
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

function editSafeCash(id) {
    $('#loading').show();
    data = {
        SafeCashAutoId: id,
    }
    $.ajax({
        type: "POST",
        url: "/Pages/SafeCash.aspx/editSafeCash",
        data: JSON.stringify({ dataValue: JSON.stringify(data) }),
        dataType: "json",
        contentType: "application/json;charset=utf-8",
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
                var SafeCashDetail = xml.find("Table");
                OpenModel();
                $("#hdnSafeCashId").val($(SafeCashDetail).find('AutoId').text());
                $("#ddlMode").val($(SafeCashDetail).find('Mode').text()).change();
                $("#ddlTerminal").val($(SafeCashDetail).find('Terminal').text()).change();
                $("#txtAmount").val($(SafeCashDetail).find('Amount').text());
                $("#txtRemark").val($(SafeCashDetail).find('Remark').text());
                if ($(SafeCashDetail).find('Status').text() == 1) {
                    $("#ddlStatus").attr('disabled', 'disabled');
                    $("#txtRemark").attr('disabled', 'disabled');
                    $("#btnUpdate").attr('disabled', 'disabled');
                }
                else {
                    $("#ddlStatus").removeAttr('disabled', 'disabled');
                    $("#txtRemark").removeAttr('disabled', 'disabled');
                    $("#btnUpdate").removeAttr('disabled', 'disabled');
                }
                $("#ddlStatus").val($(SafeCashDetail).find('Status').text()).change();
                $("#btnSave").hide();
                $("#btnUpdate").show();
                $("#txtAmount").attr('disabled', 'disabled');
                $("#ddlMode").attr('disabled', 'disabled');
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

function UpdateSafeCash() {
    debugger
    $('#loading').hide();
    var validate = 1;
    if ($("#ddlTerminal").val() == '' || $("#ddlTerminal").val() == '0') {
        $('#loading').hide();
        toastr.error('Terminal Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#ddlMode").val().trim() == '' || $("#ddlMode").val().trim() == '0') {
        $('#loading').hide();
        toastr.error('Mode Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if (parseFloat($("#txtAmount").val()) == 0 || $("#txtAmount").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Amount Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }

    if (validate == 1) {

        data = {
            Terminal: $("#ddlTerminal").val(),
            SafeCashAutoId: $("#hdnSafeCashId").val(),
            Mode: $("#ddlMode").val(),
            Amount: $("#txtAmount").val().trim(),
            Remark: $("#txtRemark").val(),
            Status: $("#ddlStatus option:selected").val()
        }
        $.ajax({
            type: "POST",
            url: "/Pages/SafeCash.aspx/UpdateSafeCash",
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
                    swal("Success!", "Safe Cash details updated successfully.", "success", { closeOnClickOutside: false }).then(function () {
                        PrintSafeCash($("#hdnSafeCashId").val());
                        BindSafeCashList(1);
                        Reset();
                        CloseModel();
                    });

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
        })
    }
}

function Reset() {
    $("#txtAmount").val('');
    $("#hdnSafeCashId").val('');
    $("#txtRemark").val('');
    $("#ddlMode").val('0').change();
    $("#ddlStatus").val('0').change();
    $("#btnSave").show();
    $("#btnUpdate").hide();
    $("#ddlMode").removeAttr('disabled');
    $("#ddlStatus").removeAttr('disabled');
    $("#txtRemark").removeAttr('disabled');
    $("#txtAmount").removeAttr('disabled');
    $("#btnUpdate").removeAttr('disabled');
}
function OpenModel() {
    Reset();
    $("#ModalTerminal").modal("show");
}

function CloseModel() {
    $("#ModalTerminal").modal("hide");
}
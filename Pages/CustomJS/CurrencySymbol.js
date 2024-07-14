$(document).ready(function () {
    BindCurrencyList(1);
    $(".modal").on('shown.bs.modal', function () {
        $(this).find("input:visible:first").focus();
    });
});

function Pagevalue(e) {
    BindCurrencyList(parseInt($(e).attr("page")));
};

function InsertCurrency() {
    /* $('#loading').show();*/
    var validate = 1;
    if ($("#txtCurrencyName").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Currency Name Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtCurrencySymbol").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Currency Symbol Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if (validate == 1) {
        data = {
            CurrencyName: $("#txtCurrencyName").val().trim(),
            CurrencySymbol: $("#txtCurrencySymbol").val().trim(),
            Status: $("#ddlStatus").val(),
        }
        $.ajax({
            type: "POST",
            url: "/Pages/CurrencySymbol.aspx/InsertCurrency",
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
                    $('#loading').hide();
                    swal("Success!", "Currency added successfully.", "success", { closeOnClickOutside: false });
                    BindCurrencyList(1);
                    Reset();
                    CloseModel();
                }
                else if (response.d == 'Session') {
                    $('#loading').hide();
                    window.location.href = '/Default.aspx'
                }
                else {
                    $('#loading').hide();
                    swal("Warning!", response.d, "warning", { closeOnClickOutside: false });
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

function BindCurrencyList(pageIndex) {
    $('#loading').show();
    data = {
        CurrencyName: $("#txtCurrency").val().trim(),
        CurrencySymbol: $("#txtSymbol").val().trim(),
        Status: $("#ddlSStatus").val(),
        pageIndex: pageIndex,
        PageSize: $("#ddlPageSize").val(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/CurrencySymbol.aspx/BindCurrencyList",
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
                var CurrencyList = xml.find("Table1");
                var pager = xml.find("Table");
                var status = "";
                if (CurrencyList.length > 0) {
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
                    // $("#ddlPageSize").show();
                    $("#EmptyTable").hide();
                    $("#tblCurrencyList tbody tr").remove();
                    var row = $("#tblCurrencyList thead tr:first-child").clone(true);
                    $.each(CurrencyList, function () {
                        debugger;
                        status = '';
                        $(".CurrencyAutoId", row).html($(this).find("AutoId").text());
                        $(".CurrencyName", row).html($(this).find("CurrencyName").text());
                        $(".CurrencySymbol", row).html($(this).find("CurrencySymbol").text());
                        if ($(this).find("Status").text() == '1') {
                            status = "<span class='badge badge badge-pill' style='background-color:#40992b'>Active</span>"
                        }
                        else {
                            status = "<span class='badge badge badge-pill' style='background-color:#e52525'>Inactive</span>"
                        }
                        debugger;
                        $(".Status", row).html(status);
                        $(".Action", row).html("<a style='' Onclick='editCurrency(" + $(this).find("AutoId").text() + ")'><img src='/Style/img/edit.png' title='Edit' class='imageButton' /></a>&nbsp;&nbsp;&nbsp;<a id='btnDeleteCurrency' onclick='isDeleteCurrency(" + $(this).find("AutoId").text() + ")' title='Delete' style='cursor: pointer'><i class='fa fa-trash' style='color:red'></i></a>");
                        $("#tblCurrencyList").append(row);
                        row = $("#tblCurrencyList tbody tr:last-child").clone(true);
                    });
                    $("#tblCurrencyList").show();
                }
                else {
                    $("#EmptyTable").show();
                    $("#tblCurrencyList").hide();
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
            swal("Error!", err.d, "error", { closeOnClickOutside: false });
            $('#loading').hide();
        },
        failure: function (err) {
            swal("Error!", err.d, "error", { closeOnClickOutside: false });
            $('#loading').hide();
        }

    });
}

function isDeleteCurrency(id) {
    $('#loading').show();
    swal({
        title: "Are you sure?",
        text: "You want to delete this Currency.",
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
                CurrencyAutoId: id,
            }
            $.ajax({
                type: "POST",
                url: "/Pages/CurrencySymbol.aspx/DeleteCurrency",
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
                        swal("Success!", "Currency deleted successfully.", "success", { closeOnClickOutside: false });
                        Reset();
                        BindCurrencyList(1);
                    }
                    else if (response.d == 'Session') {
                        window.location.href = '/Default.aspx'
                    }
                    else {
                        swal("Warning!", response.d, "warning", { closeOnClickOutside: false });
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
            $('#loading').hide();
            swal("", "Cancelled.", "error", { closeOnClickOutside: false });
        }
    });
}

function editCurrency(id) {
    $('#loading').show();
    data = {
        CurrencyAutoId: id,
    }
    $.ajax({
        type: "POST",
        url: "/Pages/CurrencySymbol.aspx/editCurrency",
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
                var CurrencyDetail = xml.find("Table");
                OpenModel();
                $("#hdnCurrencyId").val($(CurrencyDetail).find('AutoId').text());
                $("#txtCurrencyName").val($(CurrencyDetail).find('CurrencyName').text());
                $("#txtCurrencySymbol").val($(CurrencyDetail).find('CurrencySymbol').text()),
                $("#ddlStatus").val($(CurrencyDetail).find('Status').text());
                $("#btnSave").hide();
                $("#btnUpdate").show();
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

function UpdateCurrency() {
    $('#loading').show();
    var validate = 1;
    if ($("#txtCurrencyName").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Currency Name Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtCurrencySymbol").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Currency Symbol Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if (validate == 1) {
        data = {
            CurrencyName: $("#txtCurrencyName").val().trim(),
            CurrencySymbol: $("#txtCurrencySymbol").val().trim(),
            CurrencyAutoId: $("#hdnCurrencyId").val(),
            Status: $("#ddlStatus").val(),
        }
        $.ajax({
            type: "POST",
            url: "/Pages/CurrencySymbol.aspx/UpdateCurrency",
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
                    $('#loading').hide();
                    swal("Success!", "Currency details updated successfully.", "success", { closeOnClickOutside: false });
                    BindCurrencyList(1);
                    Reset();
                    CloseModel();
                }
                else if (response.d == 'Session') {
                    $('#loading').hide();
                    window.location.href = '/Default.aspx'
                }
                else {
                    $('#loading').hide();
                    swal("Warning!", response.d, "warning", { closeOnClickOutside: false });
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
    $("#txtCurrencyName").val('');
    $("#txtCurrencySymbol").val('');
    $("#hdnCurrencyId").val('');
    $("#ddlStatus").val(1);
    $("#btnSave").show();
    $("#btnUpdate").hide();
}

function OpenModel() {
    Reset();
    $("#ModalTerminal").modal("show");
}

function CloseModel() {
    $("#ModalTerminal").modal("hide");
}
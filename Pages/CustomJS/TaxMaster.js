$(document).ready(function () {
    BindTaxList(1);

    $(".modal").on('shown.bs.modal', function () {
        $(this).find("input:visible:first").focus();
    });
});

function Pagevalue(e) {
    BindTaxList(parseInt($(e).attr("page")));
};

function InsertTax() {
    $('#loading').show();
    var validate = 1;
    debugger;
    if ($("#txtTaxName").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Tax Name Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtTaxPer").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Tax Percentage Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if (parseFloat($("#txtTaxPer").val().trim()) == 0) {
        $('#loading').hide();
        toastr.error('Tax Percentage can not be zero.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if (parseFloat($("#txtTaxPer").val().trim()) > 100) {
        $('#loading').hide();
        toastr.error('Tax Percentage can not greater than 100%.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if (validate == 1) {
        data = {
            TaxName: $("#txtTaxName").val().trim(),
            TaxPercentage: $("#txtTaxPer").val().trim(),
            Status: $("#ddlStatus").val(),
        }
        $.ajax({
            type: "POST",
            url: "/Pages/TaxMaster.aspx/InsertTax",
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
                    swal("Success!", "Tax added successfully.", "success", { closeOnClickOutside: false });
                    BindTaxList(1);
                    Reset();
                    CloseModel();
                }
                else if (response.d == 'Session') {
                    $('#loading').hide();
                    window.location.href = '/Default.aspx'
                }
                else {
                    $('#loading').hide();
                    swal("Error!", response.d, "error", { closeOnClickOutside: false });
                }
                $('#loading').hide();
            },
            error: function (err) {
                $('#loading').hide();
                swal("Error!", err.d, "error", { closeOnClickOutside: false });
            },
            failure: function (err) {
                $('#loading').hide();
                swal("Error!", err.d, "error", { closeOnClickOutside: false });
            }
        })
    }
    $('#loading').hide();
}

function BindTaxList(pageIndex) {
    debugger;
    $('#loading').show();
    var taxSPer = -1;
    if ($("#txtSTaxPer").val().trim() != '' && !isNaN(parseFloat($("#txtSTaxPer").val().trim()))) {
        taxSPer = $("#txtSTaxPer").val().trim();
    }
    data = {
        TaxName: $("#txtSTaxName").val().trim(),
        TaxPercentage: taxSPer,
        Status: $("#ddlSStatus").val(),
        pageIndex: pageIndex,
        PageSize: $("#ddlPageSize").val(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/TaxMaster.aspx/BindTaxList",
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
                var TaxList = xml.find("Table1");
                var pager = xml.find("Table");
                var status = "";
                if (TaxList.length > 0) {
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
                    $("#tblTaxList tbody tr").remove();
                    var row = $("#tblTaxList thead tr:first-child").clone(true);
                    $.each(TaxList, function () {
                        debugger;
                        status = '';
                        $(".TaxAutoId", row).html($(this).find("AutoId").text());
                        $(".TaxName", row).html($(this).find("TaxName").text());
                        $(".TaxPercentage", row).html($(this).find("TaxPer").text() + '%').css('text-align', 'right');
                        if ($(this).find("Status").text() == '1') {
                            status = "<span class='badge badge badge-pill' style='background-color:#40992b'>Active</span>"
                        }
                        else {
                            status = "<span class='badge badge badge-pill' style='background-color:#e52525'>Inactive</span>"
                        }
                        debugger;
                        $(".Status", row).html(status);

                       //$(".Action", row).html("<a id='btnDeleteTax' onclick='isDeleteTax(" + $(this).find("AutoId").text() + ")' title='Delete' style='cursor: pointer'><i class='fa fa-trash' style='color:red'></i></a>&nbsp;&nbsp;&nbsp;<a style='' Onclick='editTax(" + $(this).find("AutoId").text() + ")'><img src='/Style/img/edit.png' title='Edit' class='imageButton' /></a>");
                        $(".Action", row).html("<a style='' Onclick='editTax(" + $(this).find("AutoId").text() + ")'><img src='/Style/img/edit.png' title='Edit' class='imageButton' /></a>&nbsp;&nbsp;&nbsp;<a id='btnDeleteTax' onclick='isDeleteTax(" + $(this).find("AutoId").text() + ")' title='Delete' style='cursor: pointer'><i class='fa fa-trash' style='color:red'></i></a>");
                        $("#tblTaxList").append(row);
                        row = $("#tblTaxList tbody tr:last-child").clone(true);
                    });
                    $("#tblTaxList").show();
                }
                else {
                    $("#EmptyTable").show();
                    $("#tblTaxList").hide();
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

function isDeleteTax(id) {
    $('#loading').show();
    debugger;
    swal({
        title: "Are you sure?",
        text: "You want to delete this Tax.",
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
                closeModal: false
            }
        },
    }).then((isConfirm) => {
        if (isConfirm) {
            data = {
                TaxAutoId: id,
            }
            $.ajax({
                type: "POST",
                url: "/Pages/TaxMaster.aspx/DeleteTax",
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
                        Reset();
                        BindTaxList(1);
                        swal("Success!", "Tax deleted successfully.", "success", { closeOnClickOutside: false });
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
            //swal("", "Cancelled.", "error", { closeOnClickOutside: false });
            $('#loading').hide();
        }
    });
}

function editTax(id) {
    debugger;
    $('#loading').show();
    data = {
        TaxAutoId: id,
    }
    $.ajax({
        type: "POST",
        url: "/Pages/TaxMaster.aspx/editTax",
        data: JSON.stringify({ dataValue: JSON.stringify(data) }),
        dataType: "json",
        contentType: "application/json;charset=utf-8",
        //async: false,
        success: function (response) {
            if (response.d == 'Session') {
                window.location.href = '/Default.aspx'
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var TaxDetail = xml.find("Table");
                OpenModel();
                $("#hdnTaxId").val($(TaxDetail).find('AutoId').text());
                $("#txtTaxName").val($(TaxDetail).find('TaxName').text());
                $("#txtTaxPer").val($(TaxDetail).find('TaxPer').text());
                $("#ddlStatus").val($(TaxDetail).find('Status').text());
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

function UpdateTax() {
    $('#loading').show();
    var validate = 1;
    debugger;
    if ($("#txtTaxName").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Tax Name Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtTaxPer").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Tax Percentage Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if (parseFloat($("#txtTaxPer").val().trim()) == 0) {
        $('#loading').hide();
        toastr.error('Tax Percentage can not be zero.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if (parseFloat($("#txtTaxPer").val().trim()) > 100) {
        $('#loading').hide();
        toastr.error('Tax Percentage can not greater than 100%.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if (validate == 1) {
        data = {
            TaxName: $("#txtTaxName").val().trim(),
            TaxPer: $("#txtTaxPer").val().trim(),
            TaxAutoId: $("#hdnTaxId").val(),
            Status: $("#ddlStatus").val(),
        }
        $.ajax({
            type: "POST",
            url: "/Pages/TaxMaster.aspx/UpdateTax",
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
                    BindTaxList(1);
                    Reset();
                    CloseModel();
                    swal("Success!", "Tax updated successfully.", "success", { closeOnClickOutside: false });

                }
                else if (response.d == 'Session') {
                    $('#loading').hide();
                    window.location.href = '/Default.aspx'
                }
                else {
                    $('#loading').hide();
                    swal("Error!", response.d, "error", { closeOnClickOutside: false });
                }
                $('#loading').hide();
            },
            error: function (err) {
                $('#loading').hide();
                swal("Error!", err.d, "error", { closeOnClickOutside: false });
                $('#loading').hide();
            },
            failure: function (err) {
                $('#loading').hide();
                swal("Error!", err.d, "error", { closeOnClickOutside: false });
                $('#loading').hide();
            }
        });
    }
}

function Reset() {
    $("#txtTaxName").val('');
    $("#hdnTaxId").val('');
    $("#txtTaxPer").val('');
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
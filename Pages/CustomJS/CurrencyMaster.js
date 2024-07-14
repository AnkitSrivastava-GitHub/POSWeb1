$(document).ready(function () {
    BindCurrencyList(1);

    jQuery('.numbersOnly').keyup(function () {
        this.value = this.value.replace(/[^0-9\.]/g, '');
    });
});

function Pagevalue(e) {
    BindCurrencyList(parseInt($(e).attr("page")));
};


function InsertCurrency() {
    $('#loading').show();
    var validate = 1;
    debugger;
    if (parseFloat($("#txtAmount").val()) == 0) {
        $('#loading').hide();
        toastr.error('Amount Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if (validate == 1) {
        data = {
            Amount: parseFloat($("#txtAmount").val()),
            Status: $("#ddlStatus").val()
        }
        $.ajax({
            type: "POST",
            url: "/Pages/CurrencyMaster.aspx/InsertCurrency",
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
    debugger
    $('#loading').show();
    data = {
        Amount: parseFloat($("#txtAmountT").val()),
        Status: $("#ddlSStatus").val(),
        pageIndex: pageIndex,
        PageSize: $("#ddlPageSize").val(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/CurrencyMaster.aspx/BindCurrencyList",
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
                var status = "";
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
                    $("#tblCurrencyList tbody tr").remove();
                    var row = $("#tblCurrencyList thead tr:first-child").clone(true);
                    $.each(ModuleList, function () {
                        debugger;
                        status = '';
                        $(".CurrencyAutoId", row).html($(this).find("AutoId").text());
                        $(".Amount", row).html($(this).find("Amount").text());
                        if ($(this).find("Status").text() == '1') {
                            status = "<span class='badge badge badge-pill' style='background-color:#40992b'>Active</span>"
                        }
                        else {
                            status = "<span class='badge badge badge-pill' style='background-color:#e52525'>Inactive</span>"
                        }
                        debugger;
                        $(".Status", row).html(status);
                        $(".Action", row).html("<a id='btnDeleteCurrency' onclick='isDeleteCurrency(" + $(this).find("AutoId").text() + ")' title='Delete' style='cursor: pointer'><i class='fa fa-trash' style='color:red'></i></a>&nbsp;&nbsp;&nbsp;<a style='' Onclick='editCurrency(" + $(this).find("AutoId").text() + ")'><img src='/Style/img/edit.png' title='Edit' class='imageButton' /></a>");
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
                url: "/Pages/CurrencyMaster.aspx/DeleteCurrency",
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
                        BindCurrencyList(1);
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

function editCurrency(id) {
    $('#loading').show();
    data = {
        CurrencyAutoId: id,
    }
    $.ajax({
        type: "POST",
        url: "/Pages/CurrencyMaster.aspx/editCurrency",
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
                var CurrencyDetail = xml.find("Table");

                $("#hdnCurrencyId").val($(CurrencyDetail).find('AutoId').text());
                $("#txtAmount").val($(CurrencyDetail).find('Amount').text());
                $("#ddlStatus").val($(CurrencyDetail).find('Status').text()).change();
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
    $('#loading').hide();
    var validate = 1;
    if (parseFloat($("#txtAmount").val()) == 0) {
        toastr.error('Amount Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }

    if (validate == 1) {

        data = {
            Amount: parseFloat($("#txtAmount").val()),
            CurrencyAutoId: $("#hdnCurrencyId").val(),
            Status: $("#ddlStatus").val(),
        }
        $.ajax({
            type: "POST",
            url: "/Pages/CurrencyMaster.aspx/UpdateCurrency",
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
                    swal("Success!", "Currency details updated successfully.", "success", { closeOnClickOutside: false });
                    BindCurrencyList(1);
                    Reset();
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
    $("#txtAmount").val('0.00');
    $("#hdnCurrencyId").val('');
    $("#ddlStatus").val(1);
    $("#btnSave").show();
    $("#btnUpdate").hide();
}
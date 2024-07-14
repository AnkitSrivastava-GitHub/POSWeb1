$(document).ready(function () {
    BindExpenseList(1);

    jQuery('.numbersOnly').keyup(function () {
        this.value = this.value.replace(/[^0-9\.]/g, '');
    });

    $(".modal").on('shown.bs.modal', function () {
        $(this).find("input:visible:first").focus();
    });
});

function Pagevalue(e) {
    BindExpenseList(parseInt($(e).attr("page")));
};


function InsertExpense() {
    $('#loading').show();
    var validate = 1;
    debugger;
    if ($("#txtExpensesName").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Expense Name Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if (validate == 1) {
        data = {
            ExpenseName: $("#txtExpensesName").val().trim(),
            Status: $("#ddlStatus").val()
        }
        $.ajax({
            type: "POST",
            url: "/Pages/ExpenseMaster.aspx/InsertExpense",
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
                    swal("Success!", "Expense added successfully.", "success", { closeOnClickOutside: false });
                    BindExpenseList(1);
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

function BindExpenseList(pageIndex) {
    debugger
    $('#loading').show();
    data = {
        ExpenseName: $("#txtExpenseName").val().trim(),
        Status: $("#ddlSStatus").val(),
        pageIndex: pageIndex,
        PageSize: $("#ddlPageSize").val(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/ExpenseMaster.aspx/BindExpenseList",
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
                    $("#tblExpenseList tbody tr").remove();
                    var row = $("#tblExpenseList thead tr:first-child").clone(true);
                    $.each(ModuleList, function () {
                        debugger;
                        status = '';
                        $(".ExpenseAutoId", row).html($(this).find("AutoId").text());
                        $(".ExpenseName", row).html($(this).find("ExpenseName").text());
                        if ($(this).find("Status").text() == '1') {
                            status = "<span class='badge badge badge-pill' style='background-color:#40992b'>Active</span>"
                        }
                        else {
                            status = "<span class='badge badge badge-pill' style='background-color:#e52525'>Inactive</span>"
                        }
                        debugger;
                        $(".Status", row).html(status);
                        //$(".Action", row).html("<a id='btnDeleteExpense' onclick='isDeleteExpense(" + $(this).find("AutoId").text() + ")' title='Delete' style='cursor: pointer'><i class='fa fa-trash' style='color:red'></i></a>&nbsp;&nbsp;&nbsp;<a style='' Onclick='editExpense(" + $(this).find("AutoId").text() + ")'><img src='/Style/img/edit.png' title='Edit' class='imageButton' /></a>");
                        $(".Action", row).html("<a style='' Onclick='editExpense(" + $(this).find("AutoId").text() + ")'><img src='/Style/img/edit.png' title='Edit' class='imageButton' /></a>&nbsp;&nbsp;&nbsp;<a id='btnDeleteExpense' onclick='isDeleteExpense(" + $(this).find("AutoId").text() + ")' title='Delete' style='cursor: pointer'><i class='fa fa-trash' style='color:red'></i></a>");
                        $("#tblExpenseList").append(row);
                        row = $("#tblExpenseList tbody tr:last-child").clone(true);
                    });
                    $("#tblExpenseList").show();
                }
                else {
                    $("#EmptyTable").show();
                    $("#tblExpenseList").hide();
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

function isDeleteExpense(id) {
    $('#loading').show();
    swal({
        title: "Are you sure?",
        text: "You want to delete this Expense.",
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
                ExpenseAutoId: id,
            }
            $.ajax({
                type: "POST",
                url: "/Pages/ExpenseMaster.aspx/DeleteExpense",
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
                        swal("Success!", "Expense deleted successfully.", "success", { closeOnClickOutside: false });
                        BindExpenseList(1);
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

function editExpense(id) {
    $('#loading').show();
    data = {
        ExpenseAutoId: id,
    }
    $.ajax({
        type: "POST",
        url: "/Pages/ExpenseMaster.aspx/editExpense",
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
                var ModuleDetail = xml.find("Table");
                OpenModel();
                $("#hdnExpenseId").val($(ModuleDetail).find('AutoId').text());
                $("#txtExpensesName").val($(ModuleDetail).find('ExpenseName').text());
                $("#ddlStatus").val($(ModuleDetail).find('Status').text()).change();
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

function UpdateExpense() {
    $('#loading').hide();
    var validate = 1;
    if ($("#txtExpensesName").val().trim() == '') {
        toastr.error('Expense Name Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }


    if (validate == 1) {

        data = {
            ExpenseName: $("#txtExpensesName").val().trim(),
            ExpenseAutoId: $("#hdnExpenseId").val(),
            Status: $("#ddlStatus").val(),
        }
        $.ajax({
            type: "POST",
            url: "/Pages/ExpenseMaster.aspx/UpdateExpense",
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
                    swal("Success!", "Expense details updated successfully.", "success", { closeOnClickOutside: false });
                    BindExpenseList(1);
                    Reset();
                    CloseModel();
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

    $("#txtExpensesName").val('');
    $("#hdnExpenseId").val('');
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
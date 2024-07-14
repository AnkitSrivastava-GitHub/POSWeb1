$(document).ready(function () {
    BindModuleList(1);

    jQuery('.numbersOnly').keyup(function () {
        this.value = this.value.replace(/[^0-9\.]/g, '');
    });
});

function Pagevalue(e) {
    BindModuleList(parseInt($(e).attr("page")));
};


function InsertModule() {
    $('#loading').show();
    var validate = 1;
    debugger;
    if ($("#txtModuleName").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Module Name Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if (validate == 1) {
        data = {
            ModuleName: $("#txtModuleName").val().trim(),
            SeqNo: $("#txtSeqNo").val() || null,
            Status: $("#ddlStatus").val(),
        }
        $.ajax({
            type: "POST",
            url: "/Pages/ModuleMaster.aspx/InsertModule",
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
                    swal("Success!", "Module added successfully.", "success", { closeOnClickOutside: false });
                    BindModuleList(1);
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

function BindModuleList(pageIndex) {
    debugger
    $('#loading').show();
    data = {
        ModuleName: $("#txtModulesName").val().trim(),
        Status: $("#ddlSStatus").val(),
        pageIndex: pageIndex,
        PageSize: $("#ddlPageSize").val(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/ModuleMaster.aspx/BindModuleList",
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
                    $("#tblModuleList tbody tr").remove();
                    var row = $("#tblModuleList thead tr:first-child").clone(true);
                    $.each(ModuleList, function () {
                        debugger;
                        status = '';
                        $(".ModuleAutoId", row).html($(this).find("AutoId").text());
                        $(".ModuleName", row).html($(this).find("ModuleName").text());
                        $(".SequenceNo", row).html($(this).find("SequenceNo").text());
                        if ($(this).find("Status").text() == '1') {
                            status = "<span class='badge badge badge-pill' style='background-color:#40992b'>Active</span>"
                        }
                        else {
                            status = "<span class='badge badge badge-pill' style='background-color:#e52525'>Inactive</span>"
                        }
                        debugger;
                        $(".Status", row).html(status);
                        $(".Action", row).html("<a id='btnDeleteModule' onclick='isDeleteModule(" + $(this).find("AutoId").text() + ")' title='Delete' style='cursor: pointer'><i class='fa fa-trash' style='color:red'></i></a>&nbsp;&nbsp;&nbsp;<a style='' Onclick='editModule(" + $(this).find("AutoId").text() + ")'><img src='/Style/img/edit.png' title='Edit' class='imageButton' /></a>");
                        $("#tblModuleList").append(row);
                        row = $("#tblModuleList tbody tr:last-child").clone(true);
                    });
                    $("#tblModuleList").show();
                }
                else {
                    $("#EmptyTable").show();
                    $("#tblModuleList").hide();
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

function isDeleteModule(id) {
    $('#loading').show();
    swal({
        title: "Are you sure?",
        text: "You want to delete this Module.",
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
                Moduleid: id,
            }
            $.ajax({
                type: "POST",
                url: "/Pages/ModuleMaster.aspx/DeleteModule",
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
                        swal("Success!", "Module deleted successfully.", "success", { closeOnClickOutside: false });
                        BindModuleList(1);
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

function editModule(id) {
    $('#loading').show();
    data = {
        ModuleAutoId: id,
    }
    $.ajax({
        type: "POST",
        url: "/Pages/ModuleMaster.aspx/editModule",
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

                $("#hdnModuleId").val($(ModuleDetail).find('AutoId').text());
                $("#txtModuleName").val($(ModuleDetail).find('ModuleName').text());
                $("#txtSeqNo").val($(ModuleDetail).find('SequenceNo').text());
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

function UpdateModule() {
    $('#loading').hide();
    var validate = 1;
    if ($("#txtModuleName").val().trim() == '') {
        toastr.error('Module Name Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }


    if (validate == 1) {

        data = {
            ModuleName: $("#txtModuleName").val().trim(),
            SeqNo: $("#txtSeqNo").val() || null,
            ModuleAutoId: $("#hdnModuleId").val(),
            Status: $("#ddlStatus").val(),
        }
        $.ajax({
            type: "POST",
            url: "/Pages/ModuleMaster.aspx/UpdateModule",
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
                    swal("Success!", "Module details updated successfully.", "success", { closeOnClickOutside: false });
                    BindModuleList(1);
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

    $("#txtModuleName").val('');
    $("#hdnModuleId").val('');
    $("#txtSeqNo").val('');
    $("#ddlStatus").val(1);
    $("#btnSave").show();
    $("#btnUpdate").hide();
}
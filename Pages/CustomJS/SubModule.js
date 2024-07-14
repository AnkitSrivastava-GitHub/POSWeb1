$(document).ready(function () {
    BindSubModuleList(1);
    BindDropDowns();
});
function Pagevalue(e) {
    BindSubModuleList(parseInt($(e).attr("page")));
}
function BindDropDowns() {
    $('#loading').show();
    $.ajax({
        type: "POST",
        url: "/pages/SubModule.aspx/BindDropDowns",
        data: "{}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
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
            else if (response.d == 'false') {
                swal('Error!', 'Some error occured.', 'error', { closeOnClientOutside: false });
            }
            else {
                debugger;
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var AgeRestriction = xml.find("Table");
                $("#ddlModule option").remove();
                $("#ddlModule").append($("<option></option>").val('0').html('Select Module'));
                $.each(AgeRestriction, function () {
                    $("#ddlModule").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("ModuleName").text().trim()));
                });
                $("#ddlModule").select2();
                $('#loading').hide();
            }
        },
        failure: function (response) {
            alert(response.d);
            $('#loading').hide();
        },
        error: function (response) {
            alert(response.d);
            $('#loading').hide();
        }
    });
}

function InsertSubModule() {
    $('#loading').show();
    var validate = 1;
    debugger;
    if ($("#ddlModule").val().trim() == '' || $("#ddlModule").val().trim() == '0') {
        $('#loading').hide();
        toastr.error('Module Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtSubModuleName").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Sub Module Name Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtSubModuleURL").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Sub Module URL Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    
    if (validate == 1) {
        data = {
            ModuleId: $("#ddlModule").val(),
            SubModuleName: $("#txtSubModuleName").val().trim(),
            SubModuleURL: $("#txtSubModuleURL").val(),
            Status: $("#ddlStatus").val(),
        }
        $.ajax({
            type: "POST",
            url: "/Pages/SubModule.aspx/InsertSubModule",
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
                    swal("Success!", "Sub Module added successfully.", "success", { closeOnClickOutside: false });
                    BindSubModuleList(1);
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

function BindSubModuleList(pageIndex) {
    debugger
    $('#loading').show();
    data = {
        SubModuleName: $("#txtSubModulesName").val().trim(),
        Status: $("#ddlSStatus").val(),
        pageIndex: pageIndex,
        PageSize: $("#ddlPageSize").val(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/SubModule.aspx/BindSubModuleList",
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
                    $("#tblSubModuleList tbody tr").remove();
                    var row = $("#tblSubModuleList thead tr:first-child").clone(true);
                    $.each(ModuleList, function () {
                        debugger;
                        status = '';
                        $(".SubModuleAutoId", row).html($(this).find("AutoId").text());
                        $(".ModuleName", row).html($(this).find("ModuleName").text());
                        $(".SubModuleName", row).html($(this).find("PageName").text());
                        $(".SubModuleURL", row).html($(this).find("PageUrl").text());
                        if ($(this).find("Status").text() == '1') {
                            status = "<span class='badge badge badge-pill' style='background-color:#40992b'>Active</span>"
                        }
                        else {
                            status = "<span class='badge badge badge-pill' style='background-color:#e52525'>Inactive</span>"
                        }
                        debugger;
                        $(".Status", row).html(status);
                        $(".Action", row).html("<a id='btnDeleteModule' onclick='isDeleteModule(" + $(this).find("AutoId").text() + ")' title='Delete' style='cursor: pointer'><i class='fa fa-trash' style='color:red'></i></a>&nbsp;&nbsp;&nbsp;<a style='' Onclick='editModule(" + $(this).find("AutoId").text() + ")'><img src='/Style/img/edit.png' title='Edit' class='imageButton' /></a>");
                        $("#tblSubModuleList").append(row);
                        row = $("#tblSubModuleList tbody tr:last-child").clone(true);
                    });
                    $("#tblSubModuleList").show();
                }
                else {
                    $("#EmptyTable").show();
                    $("#tblSubModuleList").hide();
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
        text: "You want to delete this Sub Module.",
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
                SubModuleid: id,
            }
            $.ajax({
                type: "POST",
                url: "/Pages/SubModule.aspx/DeleteSubModule",
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
                        swal("Success!", "Sub Module deleted successfully.", "success", { closeOnClickOutside: false });
                        BindSubModuleList(1);
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
        SubModuleAutoId: id,
    }
    $.ajax({
        type: "POST",
        url: "/Pages/SubModule.aspx/editSubModule",
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
                var SubModuleDetail = xml.find("Table");
               
                $("#hdnSubModuleId").val($(SubModuleDetail).find('AutoId').text());
                $("#ddlModule").val($(SubModuleDetail).find('ParentModuleAutoId').text()).change();
                $("#txtSubModuleName").val($(SubModuleDetail).find('PageName').text());
                $("#txtSubModuleURL").val($(SubModuleDetail).find('PageUrl').text());
                $("#ddlStatus").val($(SubModuleDetail).find('Status').text()).change();
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

function UpdateSubModule() {
    $('#loading').hide();
    var validate = 1;
    if ($("#ddlModule").val().trim() == '' || $("#ddlModule").val().trim() == '0') {
        $('#loading').hide();
        toastr.error('Module Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtSubModuleName").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Sub Module Name Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtSubModuleURL").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Sub Module URL Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }

    if (validate == 1) {

        data = {
            SubModuleAutoId: $("#hdnSubModuleId").val(),
            ModuleId: $("#ddlModule").val(),
            SubModuleName: $("#txtSubModuleName").val().trim(),
            SubModuleURL: $("#txtSubModuleURL").val(),
            Status: $("#ddlStatus").val(),
        }
        $.ajax({
            type: "POST",
            url: "/Pages/SubModule.aspx/UpdateSubModule",
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
                    swal("Success!", "Sub Module details updated successfully.", "success", { closeOnClickOutside: false });
                    BindSubModuleList(1);
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

    $("#txtSubModuleName").val('');
    $("#hdnSubModuleId").val('');
    $("#txtSubModuleURL").val('');
    $("#ddlStatus").val(1);
    $("#ddlModule").val(0).change();
    $("#btnSave").show();
    $("#btnUpdate").hide();
}
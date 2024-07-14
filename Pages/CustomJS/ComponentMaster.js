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
        url: "/pages/ComponentMaster.aspx/BindDropDowns",
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

function BindSubModule() {
    $('#loading').show();
    data = {
        ModuleId: $("#ddlModule").val()        
    }
    $.ajax({
        type: "POST",
        url: "/pages/ComponentMaster.aspx/BindSubModule",
        data: JSON.stringify({ dataValue: JSON.stringify(data) }),
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
                $("#ddlSubModule option").remove();
                $("#ddlSubModule").append($("<option></option>").val('0').html('Select Sub Module'));
                $.each(AgeRestriction, function () {
                    $("#ddlSubModule").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("PageName").text().trim()));
                });
                $("#ddlSubModule").select2();
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

function InsertComponent() {
    $('#loading').show();
    var validate = 1;
    debugger;
    if ($("#ddlModule").val().trim() == '' || $("#ddlModule").val().trim() == '0') {
        $('#loading').hide();
        toastr.error('Module Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#ddlSubModule").val().trim() == '' || $("#ddlSubModule").val().trim() == '0') {
        $('#loading').hide();
        toastr.error('Sub Module Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtComponentName").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Component Name Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    

    if (validate == 1) {
        data = {
            ModuleId: $("#ddlModule").val(),
            SubModuleId: $("#ddlSubModule").val(),
            ComponentName: $("#txtComponentName").val().trim(),
            Status: $("#ddlStatus").val(),
        }
        $.ajax({
            type: "POST",
            url: "/Pages/ComponentMaster.aspx/InsertComponent",
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
                    swal("Success!", "Component added successfully.", "success", { closeOnClickOutside: false });
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
        ComponentName: $("#txtComponentsName").val().trim(),
        Status: $("#ddlSStatus").val(),
        pageIndex: pageIndex,
        PageSize: $("#ddlPageSize").val(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/ComponentMaster.aspx/BindComponentList",
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
                    $("#tblComponentList tbody tr").remove();
                    var row = $("#tblComponentList thead tr:first-child").clone(true);
                    $.each(ModuleList, function () {
                        debugger;
                        status = '';
                        $(".ComponentAutoId", row).html($(this).find("AutoId").text());
                        $(".ModuleName", row).html($(this).find("ModuleName").text());
                        $(".SubModuleName", row).html($(this).find("PageName").text());
                        $(".ComponentName", row).html($(this).find("ComponentName").text());
                        if ($(this).find("Status").text() == '1') {
                            status = "<span class='badge badge badge-pill' style='background-color:#40992b'>Active</span>"
                        }
                        else {
                            status = "<span class='badge badge badge-pill' style='background-color:#e52525'>Inactive</span>"
                        }
                        debugger;
                        $(".Status", row).html(status);
                        $(".Action", row).html("<a id='btnDeleteComponent' onclick='isDeleteComponent(" + $(this).find("AutoId").text() + ")' title='Delete' style='cursor: pointer'><i class='fa fa-trash' style='color:red'></i></a>&nbsp;&nbsp;&nbsp;<a style='' Onclick='editComponent(" + $(this).find("AutoId").text() + ")'><img src='/Style/img/edit.png' title='Edit' class='imageButton' /></a>");
                        $("#tblComponentList").append(row);
                        row = $("#tblComponentList tbody tr:last-child").clone(true);
                    });
                    $("#tblComponentList").show();
                }
                else {
                    $("#EmptyTable").show();
                    $("#tblComponentList").hide();
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

function isDeleteComponent(id) {
    $('#loading').show();
    swal({
        title: "Are you sure?",
        text: "You want to delete this Component.",
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
                ComponentId: id,
            }
            $.ajax({
                type: "POST",
                url: "/Pages/ComponentMaster.aspx/DeleteComponent",
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
                        swal("Success!", "Component deleted successfully.", "success", { closeOnClickOutside: false });
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

function editComponent(id) {
    $('#loading').show();
    data = {
        ComponentAutoId: id,
    }
    $.ajax({
        type: "POST",
        url: "/Pages/ComponentMaster.aspx/editComponent",
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
                window.location.href = '/Default.aspx'
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var ComponentDetail = xml.find("Table");
                var SubModule = xml.find("Table1");

                if (SubModule.length > 0) {
                    $("#ddlSubModule option").remove();
                    $("#ddlSubModule").append($("<option></option>").val('0').html('Select Sub Module'));
                    $.each(SubModule, function () {
                        if ($(ComponentDetail).find('SubModuleAutoId').text() == $(SubModule).find("AutoId").text()) {
                            $("#ddlSubModule").append($("<option selected></option>").val($(SubModule).find("AutoId").text()).html($(SubModule).find("PageName").text().trim()));
                        }
                        else {
                            $("#ddlSubModule").append($("<option></option>").val($(SubModule).find("AutoId").text()).html($(SubModule).find("PageName").text().trim()));
                        }
                        });
                    $("#ddlSubModule").select2();
                }

                $("#hdnComponentId").val($(ComponentDetail).find('AutoId').text());
                $("#ddlModule").val($(ComponentDetail).find('ModuleAutoId').text()).select2();
                $("#txtComponentName").val($(ComponentDetail).find('ComponentName').text());
                $("#ddlStatus").val($(ComponentDetail).find('Status').text()).change();
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

function UpdateComponent() {
    $('#loading').hide();
    var validate = 1;
    if ($("#ddlModule").val().trim() == '' || $("#ddlModule").val().trim() == '0') {
        $('#loading').hide();
        toastr.error('Module Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#ddlSubModule").val().trim() == '' || $("#ddlSubModule").val().trim() == '0') {
        $('#loading').hide();
        toastr.error('Sub Module Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtComponentName").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Component Name Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }

    if (validate == 1) {

        data = {
            ComponentAutoId: $("#hdnComponentId").val(),
            ModuleId: $("#ddlModule").val(),
            SubModuleId: $("#ddlSubModule").val(),
            ComponentName: $("#txtComponentName").val().trim(),
            Status: $("#ddlStatus").val(),
        }
        $.ajax({
            type: "POST",
            url: "/Pages/ComponentMaster.aspx/UpdateComponent",
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
                    swal("Success!", "Component details updated successfully.", "success", { closeOnClickOutside: false });
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
    $("#txtComponentName").val('');
    $("#hdnComponentId").val('');
    $("#ddlSubModule").val(0).change();
    $("#ddlStatus").val(1);
    $("#ddlModule").val(0).change();
    $("#btnSave").show();
    $("#btnUpdate").hide();
}
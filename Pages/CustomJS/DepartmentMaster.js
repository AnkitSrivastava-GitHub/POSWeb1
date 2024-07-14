$(document).ready(function () {
   
    BindDropDowns();
    BindDepartmentList(1);
    $(".modal").on('shown.bs.modal', function () {
        $(this).find("input:visible:first").focus();
    });
});
function Pagevalue(e) {
    BindDepartmentList(parseInt($(e).attr("page")));
};

function BindDropDowns() {
    $('#loading').show();
    $.ajax({
        type: "POST",
        url: "/pages/DepartmentMaster.aspx/BindDropDowns",
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
                $("#ddlAgeRestriction option").remove();
                $.each(AgeRestriction, function () {
                    $("#ddlAgeRestriction").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("AgeRestrictionName").text().trim()));
                });
                $("#ddlAgeRestriction").select2().css('width','402px');
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
function InsertDepartment() {
    /* $('#loading').show();*/
    var validate = 1;
    if ($("#txtDepartmentName").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Department Name Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#ddlAgeRestriction").val().trim() == '0') {
        $('#loading').hide();
        toastr.error('Age Restriction Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }

    if (validate == 1) {
        data = {
            DepartmentName: $("#txtDepartmentName").val().trim(),
            AgeRestrictionId: $("#ddlAgeRestriction").val(),
            Status: $("#ddlStatus").val(),
        }
        $.ajax({
            type: "POST",
            url: "/Pages/DepartmentMaster.aspx/InsertDepartment",
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
                    swal("Success!", "Department added successfully.", "success", { closeOnClickOutside: false });
                    BindDepartmentList(1);
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
function BindDepartmentList(pageIndex) {
    $('#loading').show();
    data = {
        DepartmentName: $("#txtSDepartmentName").val().trim(),
        Status: $("#ddlSStatus").val(),
        pageIndex: pageIndex,
        PageSize: $("#ddlPageSize").val(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/DepartmentMaster.aspx/BindDepartmentList",
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
                var DepartmentList = xml.find("Table1");
                var pager = xml.find("Table");
                var status = "";
                if (DepartmentList.length > 0) {
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
                    $("#tblDepartmentList tbody tr").remove();
                    var row = $("#tblDepartmentList thead tr:first-child").clone(true);
                    $.each(DepartmentList, function () {
                        debugger;
                        status = '';
                        $(".DepartmentAutoId", row).html($(this).find("AutoId").text());
                        $(".DepartmentName", row).html($(this).find("DepartmentName").text());
                        $(".AgeRestriction", row).html($(this).find("AgeRestrictionName").text());
                        if ($(this).find("Status").text() == '1') {
                            status = "<span class='badge badge badge-pill' style='background-color:#40992b'>Active</span>"
                        }
                        else {
                            status = "<span class='badge badge badge-pill' style='background-color:#e52525'>Inactive</span>"
                        }
                        debugger;
                        $(".Status", row).html(status);
                       // $(".Action", row).html("<a id='btnDeleteDepartment' onclick='isDeleteDepartment(" + $(this).find("AutoId").text() + ")' title='Delete' style='cursor: pointer'><i class='fa fa-trash' style='color:red'></i></a>&nbsp;&nbsp;&nbsp;<a style='' Onclick='editDepartment(" + $(this).find("AutoId").text() + ")'><img src='/Style/img/edit.png' title='Edit' class='imageButton' /></a>");
                        $(".Action", row).html("<a style='' Onclick='editDepartment(" + $(this).find("AutoId").text() + ")'><img src='/Style/img/edit.png' title='Edit' class='imageButton' /></a>&nbsp;&nbsp;&nbsp;<a id='btnDeleteDepartment' onclick='isDeleteDepartment(" + $(this).find("AutoId").text() + ")' title='Delete' style='cursor: pointer'><i class='fa fa-trash' style='color:red'></i></a>");
                        $("#tblDepartmentList").append(row);
                        row = $("#tblDepartmentList tbody tr:last-child").clone(true);
                    });
                    $("#tblDepartmentList").show();
                }
                else {
                    $("#EmptyTable").show();
                    $("#tblDepartmentList").hide();
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
function editDepartment(id) {
    $('#loading').show();
    data = {
        DepartmentAutoId: id,
    }
    $.ajax({
        type: "POST",
        url: "/Pages/DepartmentMaster.aspx/editDepartment",
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
                var DepartmentDetail = xml.find("Table");
                OpenModel();
                $("#hdnDepartmentId").val($(DepartmentDetail).find('AutoId').text());
                $("#txtDepartmentName").val($(DepartmentDetail).find('DepartmentName').text());
                $("#ddlAgeRestriction").val($(DepartmentDetail).find('AgeRestrictionId').text()).select2();
                $("#ddlStatus").val($(DepartmentDetail).find('Status').text());
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
function isDeleteDepartment(id) {
    
    $('#loading').show();
    swal({
        title: "Are you sure?",
        text: "You want to delete this Department.",
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
                DepartmentAutoId: id,
            }
            $.ajax({
                type: "POST",
                url: "/Pages/DepartmentMaster.aspx/DeleteDepartment",
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
                        swal("Success!", "Department deleted successfully.", "success", { closeOnClickOutside: false });
                        Reset();
                        BindDepartmentList(1);
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
            //swal("", "Cancelled.", "error", { closeOnClickOutside: false });
        }
    });
}
function UpdateDepartment() {
    $('#loading').show();
    var validate = 1;
    if ($("#txtDepartmentName").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Department Name Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if (validate == 1) {
        data = {
            DepartmentName: $("#txtDepartmentName").val().trim(),
            AgeRestrictionId: $("#ddlAgeRestriction").val(),
            Status: $("#ddlStatus").val(),
            DepartmentAutoId: $("#hdnDepartmentId").val(),

        }
        $.ajax({
            type: "POST",
            url: "/Pages/DepartmentMaster.aspx/UpdateDepartment",
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
                    swal("Success!", "Department details updated successfully.", "success", { closeOnClickOutside: false });
                    BindDepartmentList(1);
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
    $("#txtDepartmentName").val('');
    $("#hdnDepartmentId").val('');
    $("#ddlAgeRestriction").val(1).select2();
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
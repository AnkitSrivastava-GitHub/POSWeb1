$(document).ready(function () {
    BindTerminalList(1);
    /* BindDropDowns();*/
    $(".modal").on('shown.bs.modal', function () {
        $(this).find("input:visible:first").focus();
    });
});

function InsertTerminal() {
    /* $('#loading').show();*/
    var validate = 1;
    //if ($("#ddlCompanyName").val().trim() == '0') {
    //    toastr.error('Company Name Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
    //    validate = 0;
    //    return false;
    //}
    if ($("#txtTerminalName").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Terminal Name Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if (validate == 1) {
        data = {
           /* CompanyId: $("#ddlCompanyName").val(),*/
            TerminalName: $("#txtTerminalName").val().trim(),
            TerminalAddress: $("#txtTerminalAddress").val().trim(),
            Status: $("#ddlStatus").val(),
        }
        $.ajax({
            type: "POST",
            url: "/Pages/TerminalMaster.aspx/InsertTerminal",
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
                    swal("Success!", "Terminal added successfully.", "success", { closeOnClickOutside: false });
                    BindTerminalList(1);
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

function Pagevalue(e) {
    BindTerminalList(parseInt($(e).attr("page")));
};
//function BindDropDowns() {
//    $('#loading').show();
//    $.ajax({
//        type: "POST",
//        url: "/pages/TerminalMaster.aspx/BindDropDowns",
//        data: "{}",
//        contentType: "application/json; charset=utf-8",
//        dataType: "json",
//        beforeSend: function () {
//            $('#fade').show();
//        },
//        complete: function () {
//            $('#fade').hide();
//        },
//        success: function (response) {
//            if (response.d == 'Session') {
//                window.location.href = '/Default.aspx'
//            }
//            else if (response.d == 'false') {
//                swal('Error!', 'Some error occured.', 'error', { closeOnClickOutside: false });
//            }
//            else {
//                var xmldoc = $.parseXML(response.d);
//                var xml = $(xmldoc);
//                var CompanyList = xml.find("Table");
//                $("#ddlCompanyName option").remove();
//                $("#ddlCompanyName").append('<option value="0">Select Company Name</option>');
//                $.each(CompanyList, function () {
//                    $("#ddlCompanyName").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("CompanyId").text()));
//                });

//                $("#ddlSCompanyName option").remove();
//                $("#ddlSCompanyName").append('<option value="0">All Company</option>');
//                $.each(CompanyList, function () {
//                    $("#ddlSCompanyName").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("CompanyId").text()));
//                });

//                $('#loading').hide();
//            }
//        },
//        failure: function (response) {
//            alert(response.d);
//            $('#loading').hide();
//        },
//        error: function (response) {
//            alert(response.d);
//            $('#loading').hide();
//        }
//    });
//}
function BindTerminalList(pageIndex) {
    $('#loading').show();
    data = {
        /*CompanyId: $("#ddlSCompanyName").val(),*/
        TerminalName: $("#txtSTerminalName").val().trim(),
        CurrentUser: $("#txtCurrentUser").val().trim(),
        Status: $("#ddlSStatus").val(),
        pageIndex: pageIndex,
        PageSize: $("#ddlPageSize").val(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/TerminalMaster.aspx/BindTerminalList",
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
                var TerminalList = xml.find("Table1");
                var pager = xml.find("Table");
                var status = "";
                if (TerminalList.length > 0) {
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
                    $("#tblTerminalList tbody tr").remove();
                    var row = $("#tblTerminalList thead tr:first-child").clone(true);
                    $.each(TerminalList, function () {
                        debugger;
                        status = '';
                        $(".TerminalAutoId", row).html($(this).find("AutoId").text());
                        $(".CompanyName", row).html($(this).find("CompanyId").text());
                        $(".TerminalName", row).html($(this).find("TerminalName").text());
                        $(".CurrentUser", row).html($(this).find("CurrentUser").text());
                        $(".OccupyStatus", row).html($(this).find("OccupyStatus").text());
                        if ($(this).find("Status").text() == '1') {
                            status = "<span class='badge badge badge-pill' style='background-color:#40992b'>Active</span>"
                        }
                        else {
                            status = "<span class='badge badge badge-pill' style='background-color:#e52525'>Inactive</span>"
                        }
                        debugger;
                        $(".Status", row).html(status);
                        //$(".Action", row).html("<a id='btnDeleteTerminal' onclick='isDeleteTerminal(" + $(this).find("AutoId").text() + ")' title='Delete' style='cursor: pointer'><i class='fa fa-trash' style='color:red'></i></a>&nbsp;&nbsp;&nbsp;<a style='' Onclick='editTerminal(" + $(this).find("AutoId").text() + ")'><img src='/Style/img/edit.png' title='Edit' class='imageButton' /></a>");
                        $(".Action", row).html("<a style='' Onclick='editTerminal(" + $(this).find("AutoId").text() + ")'><img src='/Style/img/edit.png' title='Edit' class='imageButton' /></a>&nbsp;&nbsp;&nbsp;<a id='btnDeleteTerminal' onclick='isDeleteTerminal(" + $(this).find("AutoId").text() + ")' title='Delete' style='cursor: pointer'><i class='fa fa-trash' style='color:red'></i></a>");
                        $("#tblTerminalList").append(row);
                        row = $("#tblTerminalList tbody tr:last-child").clone(true);
                    });
                    $("#tblTerminalList").show();
                }
                else {
                    $("#EmptyTable").show();
                    $("#tblTerminalList").hide();
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
function isDeleteTerminal(id) {
    $('#loading').show();
    swal({
        title: "Are you sure?",
        text: "You want to delete this Terminal.",
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
                TerminalAutoId: id,
            }
            $.ajax({
                type: "POST",
                url: "/Pages/TerminalMaster.aspx/DeleteTerminal",
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
                        swal("Success!", "Terminal deleted successfully.", "success", { closeOnClickOutside: false });
                        BindTerminalList(1);
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
            $('#loading').hide();
            swal("", "Cancelled.", "error", { closeOnClickOutside: false });
        }
    });
}

function editTerminal(id) {
    $('#loading').show();
    data = {
        TerminalAutoId: id,
    }
    $.ajax({
        type: "POST",
        url: "/Pages/TerminalMaster.aspx/editTerminal",
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
                var TerminalDetail = xml.find("Table");
                var CompanyList = xml.find("Table1");
                OpenModel();
                //$("#ddlCompanyName option").remove();
                //$("#ddlCompanyName").append('<option value="0">Select Company</option>');
                //$.each(CompanyList, function () {
                //    $("#ddlCompanyName").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("CompanyId").text()));
                //});
                //$("#ddlCompanyName").val($(TerminalDetail).find('CompanyId').text());
                //$("#ddlCompanyName").change();

                $("#hdnTerminalId").val($(TerminalDetail).find('AutoId').text());
                $("#txtTerminalName").val($(TerminalDetail).find('TerminalName').text());
                $("#txtTerminalAddress").val($(TerminalDetail).find('TerminalAddress').text());
                $("#ddlStatus").val($(TerminalDetail).find('Status').text());
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

function UpdateTerminal() {
    $('#loading').show();
    var validate = 1;
    //if ($("#ddlCompanyName").val().trim() == '0') {
    //    toastr.error('Company Name Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
    //    validate = 0;
    //    return false;
    //}
    if ($("#txtTerminalName").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Terminal Name Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if (validate == 1) {
        debugger;
        data = {
            
           /* CompanyId: $("#ddlCompanyName").val(),*/
            TerminalName: $("#txtTerminalName").val().trim(),
            TerminalAddress: $("#txtTerminalAddress").val().trim(),
            Status: $("#ddlStatus").val(),
            TerminalAutoId: $("#hdnTerminalId").val(),

        }
        $.ajax({
            type: "POST",
            url: "/Pages/TerminalMaster.aspx/UpdateTerminal",
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
                    swal("Success!", "Terminal details updated successfully.", "success", { closeOnClickOutside: false });
                    BindTerminalList(1);
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
    $("#ddlCompanyName").val('0');
    $("#txtTerminalName").val('');
    $("#txtTerminalAddress").val('');
    $("#hdnTerminalId").val('');
    $("#ddlStatus").val(1);
    $("#btnSave").show();
    $("#btnUpdate").hide();
}

function OpenModel() {
    Reset();
    $("#ModalTerminal").modal("show");
    $("#txtTerminalName").focus();
}

function CloseModel() {
    $("#ModalTerminal").modal("hide");
}
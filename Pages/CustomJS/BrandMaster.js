$(document).ready(function () {
    BindBrandList(1);
    $(".modal").on('shown.bs.modal', function () {
        $(this).find("input:visible:first").focus();
    });
});

function Pagevalue(e) {
    BindBrandList(parseInt($(e).attr("page")));
};

function InsertBrand() {
   /* $('#loading').show();*/
    var validate = 1;
    if ($("#txtBrandName").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Brand Name Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if (validate == 1) {
        data = {
            BrandName: $("#txtBrandName").val().trim(),
            Status: $("#ddlStatus").val(),
        }
        $.ajax({
            type: "POST",
            url: "/Pages/BrandMaster.aspx/InsertBrand",
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
                    swal("Success!", "Brand added successfully.", "success", { closeOnClickOutside: false });
                    BindBrandList(1);
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

function BindBrandList(pageIndex) {
    $('#loading').show();
    data = {
        BrandName: $("#txtSBrandName").val().trim(),
        Status: $("#ddlSStatus").val(),
        pageIndex: pageIndex,
        PageSize: $("#ddlPageSize").val(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/BrandMaster.aspx/BindBrandList",
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
                var BrandList = xml.find("Table1");
                var pager = xml.find("Table");
                var status = "";
                if (BrandList.length > 0) {
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
                    $("#tblBrandList tbody tr").remove();
                    var row = $("#tblBrandList thead tr:first-child").clone(true);
                    $.each(BrandList, function () {
                        debugger;
                        status = '';
                        $(".BrandAutoId", row).html($(this).find("AutoId").text());
                        $(".BrandName", row).html($(this).find("BrandName").text());
                        if ($(this).find("Status").text() == '1') {
                            status = "<span class='badge badge badge-pill' style='background-color:#40992b'>Active</span>"
                        }
                        else {
                            status = "<span class='badge badge badge-pill' style='background-color:#e52525'>Inactive</span>"
                        }
                        debugger;
                        $(".Status", row).html(status);
                       // $(".Action", row).html("<a id='btnDeleteBrand' onclick='isDeleteBrand(" + $(this).find("AutoId").text() + ")' title='Delete' style='cursor: pointer'><i class='fa fa-trash' style='color:red'></i></a>&nbsp;&nbsp;&nbsp;<a style='' Onclick='editBrand(" + $(this).find("AutoId").text() + ")'><img src='/Style/img/edit.png' title='Edit' class='imageButton' /></a>");
                        $(".Action", row).html("<a style='' Onclick='editBrand(" + $(this).find("AutoId").text() + ")'><img src='/Style/img/edit.png' title='Edit' class='imageButton' /></a>&nbsp;&nbsp;&nbsp;<a id='btnDeleteBrand' onclick='isDeleteBrand(" + $(this).find("AutoId").text() + ")' title='Delete' style='cursor: pointer'><i class='fa fa-trash' style='color:red'></i></a>");
                        $("#tblBrandList").append(row);
                        row = $("#tblBrandList tbody tr:last-child").clone(true);
                    });
                    $("#tblBrandList").show();
                }
                else {
                    $("#EmptyTable").show();
                    $("#tblBrandList").hide();
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

function isDeleteBrand(id) {
    $('#loading').show();
    swal({
        title: "Are you sure?",
        text: "You want to delete this Brand.",
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
                BrandAutoId: id,
            }
            $.ajax({
                type: "POST",
                url: "/Pages/BrandMaster.aspx/DeleteBrand",
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
                        swal("Success!", "Brand deleted successfully.", "success", { closeOnClickOutside: false });
                        Reset();
                        BindBrandList(1);
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
        }
    });
}

function editBrand(id) {
    $('#loading').show();
    data = {
        BrandAutoId: id,
    }
    $.ajax({
        type: "POST",
        url: "/Pages/BrandMaster.aspx/editBrand",
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
                var BrandDetail = xml.find("Table");
                OpenModel();
                $("#hdnBrandId").val($(BrandDetail).find('AutoId').text());
                $("#txtBrandName").val($(BrandDetail).find('BrandName').text());
                $("#ddlStatus").val($(BrandDetail).find('Status').text());
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

function UpdateBrand() {
    $('#loading').show();
    var validate = 1;
    if ($("#txtBrandName").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Brand Name Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if (validate == 1) {
        data = {
            BrandName: $("#txtBrandName").val().trim(),
            BrandAutoId: $("#hdnBrandId").val(),
            Status: $("#ddlStatus").val(),
        }
        $.ajax({
            type: "POST",
            url: "/Pages/BrandMaster.aspx/UpdateBrand",
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
                    swal("Success!", "Brand details updated successfully.", "success", { closeOnClickOutside: false });
                    BindBrandList(1);
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
    $("#txtBrandName").val('');
    $("#hdnBrandId").val('');
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
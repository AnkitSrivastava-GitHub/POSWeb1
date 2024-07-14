
$(document).ready(function () {
    BindAgeList(1);
    $(".modal").on('shown.bs.modal', function () {
        $(this).find("input:visible:first").focus();
    });
});

function Pagevalue(e) {
    BindAgeList(parseInt($(e).attr("page")));
};

function InsertAge() {
    $('#loading').show();
    var validate = 1;
    if ($("#txtrestriction").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Age Restriction Name Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtage").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Age Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if (parseInt($("#txtage").val().trim()) == 0) {
        $('#loading').hide();
        toastr.error('Age can not be zero.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if (validate == 1) {
        data = {
            AgeRestriction: $("#txtrestriction").val(),
            Age: $("#txtage").val(),
        }
        $.ajax({
            type: "POST",
            url: "/Pages/AgeRestrictionMaster.aspx/InsertAge",
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
                    swal("Success!", "Age Restriction added successfully.", "success", { closeOnClickOutside: false });
                    BindAgeList(1);
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
        });
    }
}
function BindAgeList(pageIndex) {
    $('#loading').show();
    data = {
        AgeRestriction: $("#txtSAgeRestrict").val().trim(),
        Age: $("#txtSAge").val(),
        pageIndex: pageIndex,
        PageSize: $("#ddlPageSize").val(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/AgeRestrictionMaster.aspx/BindAgeList",
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
                var AgeList = xml.find("Table1");
                var pager = xml.find("Table");
                var status = "";
                if (AgeList.length > 0) {
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
                    $("#tblAgeList tbody tr").remove();
                    var row = $("#tblAgeList thead tr:first-child").clone(true);
                    $.each(AgeList, function () {
                        status = '';
                        $(".AgeAutoId", row).html($(this).find("AutoId").text());
                        $(".AgeRestriction", row).html($(this).find("AgeRestrictionName").text());
                        $(".Age", row).html($(this).find("Age").text());

                       //$(".Action", row).html("<a id='btnDeleteAge' onclick='isDeleteAge(" + $(this).find("AutoId").text() + ")' title='Delete' style='cursor: pointer'><i class='fa fa-trash' style='color:red'></i></a>&nbsp;&nbsp;&nbsp;<a style='' Onclick='editAge(" + $(this).find("AutoId").text() + ")'><img src='/Style/img/edit.png' title='Edit' class='imageButton' /></a>");
                        $(".Action", row).html("<a style='' Onclick='editAge(" + $(this).find("AutoId").text() + ")'><img src='/Style/img/edit.png' title='Edit' class='imageButton' /></a>&nbsp;&nbsp;&nbsp;<a id='btnDeleteAge' onclick='isDeleteAge(" + $(this).find("AutoId").text() + ")' title='Delete' style='cursor: pointer'><i class='fa fa-trash' style='color:red'></i></a>");
                        $("#tblAgeList").append(row);
                        row = $("#tblAgeList tbody tr:last-child").clone(true);
                    });
                    $("#tblAgeList").show();
                }
                else {
                    $("#EmptyTable").show();
                    $("#tblAgeList").hide();
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
function isDeleteAge(id) {
    $('#loading').show();
    swal({
        title: "Are you sure?",
        text: "You want to delete this Age Restriction.",
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
                AgeAutoId: id,
            }
            $.ajax({
                type: "POST",
                url: "/Pages/AgeRestrictionMaster.aspx/DeleteAge",
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
                        swal("Success!", "Age Restriction deleted successfully.", "success", { closeOnClickOutside: false });
                        BindAgeList(1);
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
            //swal("", "Cancelled.", "error", { closeOnClickOutside: false });
        }
    });
}
function editAge(id) {
    $('#loading').show();
    data = {
        AgeAutoId: id,
    }
    $.ajax({
        type: "POST",
        url: "/Pages/AgeRestrictionMaster.aspx/editAge",
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
                var AgeDetail = xml.find("Table");
                $("#hdnAgeId").val($(AgeDetail).find('AutoId').text());
                $("#txtrestriction").val($(AgeDetail).find('AgeRestrictionName').text());
                $("#txtage").val($(AgeDetail).find('Age').text());
                $("#btnSave").hide();
                $("#btnUpdate").show();
                OpenModel();
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
function UpdateAge() {
    $('#loading').show();
    var validate = 1;
    debugger;
    if ($("#txtrestriction").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Age Restriction Name Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#txtage").val().trim() == '') {
        $('#loading').hide();
        toastr.error('Age Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if (parseInt($("#txtage").val().trim()) == 0) {
        $('#loading').hide();
        toastr.error('Age can not be zero.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if (validate == 1) {
        data = {
            AgeRestriction: $("#txtrestriction").val().trim(),
            AgeAutoId: $("#hdnAgeId").val(),
            Age: $("#txtage").val(),
        }
        $.ajax({
            type: "POST",
            url: "/Pages/AgeRestrictionMaster.aspx/UpdateAge",
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
                    $('#loading').hide();
                    swal("Success!", "Age Restriction details updated successfully.", "success", { closeOnClickOutside: false });
                    BindAgeList(1);
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
    $("#txtrestriction").val('');
    $("#hdnAgeId").val('');
    $("#txtage").val('');
    $("#btnSave").show();
    $("#btnUpdate").hide();
}

function OpenForInsert() {
    Reset();
    OpenModel();
}
function OpenModel() {
    $("#ModalTerminal").modal("show");
}

function CloseModel() {
    $("#ModalTerminal").modal("hide");
}
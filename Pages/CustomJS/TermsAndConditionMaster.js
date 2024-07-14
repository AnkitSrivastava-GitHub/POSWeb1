
$(document).ready(function () {
    BindDropdowns();
    BindTermsList(1);
});

function BindDropdowns() {
    debugger;
    $("#loading").show();
    $.ajax({
        type: "POST",
        data: "{}",
        url: "/pages/TermAndConditionMaster.aspx/BindDropdowns",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        beforeSend: function () {
            $("#fade").show();
        },
        complete: function () {
            $("#fade").hide();
        },
        success: function (response) {
            if (response.d == 'Session') {
                window.location.href = '/Default.aspx'
            }
            else if (response.d == 'false') {
                swal('Error!', 'Some error occured.', 'error');
            }
            else
            {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var OrderList = xml.find("Table");
                $("#ddlOrder option").remove();
                $("#ddlOrder").append('<option value="0">Select Order</option>');
                $.each(OrderList, function () {
                    $("#ddlOrder").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("OrderType").text()));
                    $("#ddlSOrder").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("OrderType").text()));
                });
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

    })
}
function InsertTerms() {
    $('#loading').show();
    var validate = 1;
    if ($("#txtConditions").val().trim() == '') {
        toastr.error('Terms And Conditions Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#ddlOrder").val().trim() == '0') {
        toastr.error('Order Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if (validate == 1) {
        data = {
            Terms: $("#txtConditions").val(),
            Order: $("#ddlOrder").val(),
        }
        $.ajax({
            type: "POST",
            url: "/Pages/TermAndConditionMaster.aspx/InsertTerms",
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
                    swal("Success!", "Terms Added Successfully.", "success");
                    BindTermsList(1);
                    Reset();
                }
                else if (response.d == 'Session') {
                    window.location.href = '/Default.aspx'
                }
                else {
                    swal("Error!", response.d, "error");
                }
                $('#loading').hide();
            },
            error: function (err) {
                swal("Error!", err.d, "error");
                $('#loading').hide();
            },
            failure: function (err) {
                swal("Error!", err.d, "error");
                $('#loading').hide();
            }
        })
    }
}
function BindTermsList(pageIndex) {
    debugger;
    $('#loading').show();
    data = {
        Terms: $("#txtSTerms").val(),
        Order: $("#ddlSOrder").val(),
        pageIndex: pageIndex,
        PageSize: $("#ddlPageSize").val(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/TermAndConditionMaster.aspx/BindTermsList",
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
                var OrderList = xml.find("Table1");
                var pager = xml.find("Table");
                /*var status = "";*/
                if (OrderList.length > 0) {
                    if (pager.length > 0) {
                        $("#spSortBy").text($(pager).find("SortByString").text());
                    }
                    $("#spSortBy").show();
                    $("#ddlPageSize").show();
                    $("#EmptyTable").hide();
                    $("#tblOrderList tbody tr").remove();
                    var row = $("#tblOrderList thead tr:first-child").clone(true);
                    $.each(OrderList, function () {
                        debugger;
                        /*status = '';*/
                        $(".termsAutoId", row).html($(this).find("AutoId").text());
                        $(".Terms", row).html($(this).find("Term").text());
                        $(".Order", row).html($(this).find("OrderType").text());
                        $(".Action", row).html("<a id='btnDeleteTerms' onclick='isDeleteTerms(" + $(this).find("AutoId").text() + ")' title='Delete Brand' style='cursor: pointer'><i class='fa fa-trash' style='color:red'></i></a>&nbsp;&nbsp;&nbsp;<a style='' Onclick='editTerms(" + $(this).find("AutoId").text() + ")'><img src='/Style/img/edit.png' title='Edit' class='imageButton' /></a>");
                        $("#tblOrderList").append(row);
                        row = $("#tblOrderList tbody tr:last-child").clone(true);
                    });
                    $("#tblOrderList").show();
                }
                else {
                    $("#EmptyTable").show();
                    $("#tblOrderList").hide();
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
            }
            $('#loading').hide();
        },
        error: function (err) {
            swal("Error!", err.d, "error");
            $('#loading').hide();
        },
        failure: function (err) {
            swal("Error!", err.d, "error");
            $('#loading').hide();
        }
    });
}
function isDeleteTerms(id) {
    $('#loading').show();
    swal({
        title: "Are you sure?",
        text: "You want to delete this Terms.",
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
                AutoId: id,
            }
            $.ajax({
                type: "POST",
                url: "/Pages/TermAndConditionMaster.aspx/DeleteTerms",
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
                        swal("Success!", "Terms Deleted Successfully.", "success");
                        BindTermsList(1);
                    }
                    else if (response.d == 'Session') {
                        window.location.href = '/Default.aspx'
                    }
                    else {
                        swal("Error!", response.d, "error");
                    }
                    $('#loading').hide();
                },
                error: function (err) {
                    swal("Error!", err.d, "error");
                    $('#loading').hide();
                },
                failure: function (err) {
                    swal("Error!", err.d, "error");
                    $('#loading').hide();
                }
            });
        }
        else {
            swal("", "Cancelled.", "error");
            $('#loading').show();
        }
    });
}
function editTerms(id) {
    $('#loading').show();
    data = {
        AutoId: id,
    }
    $.ajax({
        type: "POST",
        url: "/Pages/TermAndConditionMaster.aspx/EditTerms",
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
                var TermsDetail = xml.find("Table");
                $("#hdntermsId").val($(TermsDetail).find('AutoId').text());
                $("#txtConditions").val($(TermsDetail).find('Term').text());
                $("#ddlOrder").val($(TermsDetail).find('Type').text());
                $("#btnSave").hide();
                $("#btnUpdate").show();
            }
            $('#loading').hide();
        },
        error: function (err) {
            swal("Error!", err.d, "error");
            $('#loading').hide();
        },
        failure: function (err) {
            swal("Error!", err.d, "error");
            $('#loading').hide();
        }
    });
}
function UpdateTerms() {
    $('#loading').show();
    var validate = 1;
    debugger;
    if ($("#txtConditions").val().trim() == '') {
        toastr.error('Terms And Conditions Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    if ($("#ddlOrder").val().trim() == '0') {
        toastr.error('Order Required.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    debugger;
    if (validate == 1) {
        data = {
            AutoId: $("#hdntermsId").val(),
            Terms: $("#txtConditions").val(),
            Order: $("#ddlOrder").val(),
        }
        $.ajax({
            type: "POST",
            url: "/Pages/TermAndConditionMaster.aspx/UpdateTerms",
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
                    swal("Success!", "Terms updated Successfully.", "success");
                    BindTermsList(1);
                    Reset();
                }
                else if (response.d == 'Session') {
                    window.location.href = '/Default.aspx'
                }
                else {
                    swal("Error!", response.d, "error");
                }
                $('#loading').hide();
            },
            error: function (err) {
                swal("Error!", err.d, "error");
                $('#loading').hide();
            },
            failure: function (err) {
                swal("Error!", err.d, "error");
                $('#loading').hide();
            }
        })
    }
}
function Reset() {
    $("#txtConditions").val('');
    $("#hdntermsId").val('');
    $("#ddlOrder").val(0);
    $("#btnSave").show();
    $("#btnUpdate").hide();
}


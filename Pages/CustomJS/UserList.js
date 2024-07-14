$(document).ready(function () {
        BindDropDowns();
        BindUserList(1);
});

function Pagevalue(e) {
    BindUserList(parseInt($(e).attr("page")));
};

function BindDropDowns() {
    $('#loading').show();
    $.ajax({
        type: "POST",
        url: "/pages/UserMaster.aspx/BindDropDowns",
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
                swal('Error!', 'Some error occured.', 'error', { closeOnClickOutside: false });
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var UserList = xml.find("Table");
                var CompanyList = xml.find("Table1");
                $("#ddlSCompanyName option").remove();
                $("#ddlSCompanyName").append('<option value="0">All Company</option>');
                $.each(CompanyList, function () {
                    $("#ddlSCompanyName").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("CompanyId").text()));
                });

                $("#txtSUserType option").remove();
                $("#txtSUserType").append('<option value="0">All User Type</option>');
                $.each(UserList, function () {
                    $("#txtSUserType").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("UserType").text()));
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
    });
}

function BindUserList(pageIndex) {
    $('#loading').show();
    data = {
        CompanyId: $("#ddlSCompanyName").val(),
        FirstName: $("#txtSname").val(),
        UserType: $("#txtSUserType").val(),
        LoginId: $("#txtSUser").val(),
        EmailId: $("#txtSEmailid").val(),
        PhoneNo: $("#txtSMob").val(),
        Status: $("#txtSstatus").val(),
        pageIndex: pageIndex,
        PageSize: $("#ddlPageSize").val(),
    }
    $.ajax({
        type: "POST",
        url: "/Pages/ShowUserMaster.aspx/BindUserList",
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
                debugger;
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var UserList = xml.find("Table1");
                var pager = xml.find("Table");
                var status = "";
                if (UserList.length > 0) {
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
                    $("#tblUserList tbody tr").remove();
                    var row = $("#tblUserList thead tr:first-child").clone(true);
                    $.each(UserList, function () {
                        debugger;
                        status = '';
                        $(".UserAutoId", row).html($(this).find("UserAutoId").text());
                        $(".UserFName", row).html($(this).find("FirstName").text());
                        if ($(this).find("Status").text() == '1') {
                            status = "<span class='badge badge badge-pill' style='background-color:#40992b'>Active</span>"
                        }
                        else {
                            status = "<span class='badge badge badge-pill' style='background-color:#e52525'>Inactive</span>"
                        }
                        $(".status", row).html(status);
                        debugger;
                        $(".CompanyName", row).html($(this).find("CompanyId").text());
                        $(".LoginId", row).html($(this).find("LoginID").text());
                        $(".UserType", row).html($(this).find("UserType").text());
                        $(".EmailId", row).html($(this).find("EmailId").text());
                        $(".Mob", row).html($(this).find("PhoneNo").text());
                       //$(".Action", row).html("<a id='btnDeleteAge' onclick='isDeleteUser(" + $(this).find("UserAutoId").text() + ")' title='Delete' style='cursor: pointer'><i class='fa fa-trash' style='color:red'></i></a>&nbsp;&nbsp;&nbsp;<a style='' href='/Pages/UserMaster.aspx?PageId=" + $(this).find("UserAutoId").text() + "'><img src='/Style/img/edit.png' title='Edit' class='imageButton' /></a>");
                        $(".Action", row).html("<a style='' href='/Pages/UserMaster.aspx?PageId=" + $(this).find("UserAutoId").text() + "'><img src='/Style/img/edit.png' title='Edit' class='imageButton' /></a>&nbsp;&nbsp;&nbsp;<a id='btnDeleteAge' onclick='isDeleteUser(" + $(this).find("UserAutoId").text() + ")' title='Delete' style='cursor: pointer'><i class='fa fa-trash' style='color:red'></i></a>");
                        $("#tblUserList").append(row);
                        row = $("#tblUserList tbody tr:last-child").clone(true);
                    });
                    $("#tblUserList").show();
                }
                else {
                    $("#EmptyTable").show();
                    $("#tblUserList").hide();
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

function isDeleteUser(id) {
    $('#loading').show();
    swal({
        title: "Are you sure?",
        text: "You want to delete this user.",
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
                UserAutoId: id,
            }
            $.ajax({
                type: "POST",
                url: "/Pages/ShowUserMaster.aspx/DeleteUser",
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
                        swal("Success!", "User deleted successfully.", "success", { closeOnClickOutside: false });
                        BindUserList(1);
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

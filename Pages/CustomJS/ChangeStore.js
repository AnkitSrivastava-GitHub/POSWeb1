$(document).ready(function () {
    BindStoreList();
});

function BindStoreList() {
    debugger;
    $.ajax({
        type: "POST",
        url: "/Pages/ChangeStore.aspx/BindStoreList",
        data: "{}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (response) {
            if (response.d == 'false') {
                swal("", "No Store Found!", "warning", { closeOnClickOutside: false });
            } else if (response.d == "Session") {
                location.href = '/';
            }
            else {
                var xmldoc = $.parseXML(response.d);
                var xml = $(xmldoc);
                var StoreList = xml.find("Table");
                $("#ddlStore option").remove();
                $("#ddlStore").append('<option value="0">Select Store</option>');
                $.each(StoreList, function () {
                    $("#ddlStore").append($("<option></option>").val($(this).find("AutoId").text()).html($(this).find("CompanyName").text()));
                });
                $("#ddlStore").select2();
            }
        },
        failure: function (result) {
            console.log(result.d);
        },
        error: function (result) {
            console.log(result.d);
        }
    });
}

function ChangeStore() {
    if ($("#ddlStore").val() == '' || $("#ddlStore").val() == '0') {
        toastr.error('Please Select Store.', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
        validate = 0;
        return false;
    }
    else {
        $.ajax({
            type: "POST",
            url: "/Pages/ChangeStore.aspx/ChangeStore",
            data: "{'CompanyId':'" + $("#ddlStore").val() + "'}",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: false,
            success: function (response) {
                if (response.d == 'false') {
                    swal("", "No Store Found!", "warning", { closeOnClickOutside: false });
                } else if (response.d == "Session") {
                    location.href = '/';
                }
                else if (response.d == 'true') {
                    window.location.href ='/Pages/DashBoard.aspx'
                }
            },
            failure: function (result) {
                console.log(result.d);
            },
            error: function (result) {
                console.log(result.d);
            }
        });
    }    
}

function GoBack() {
    window.history.go(-1);
    return false;
}
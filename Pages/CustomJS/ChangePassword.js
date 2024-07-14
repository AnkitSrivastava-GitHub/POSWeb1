$(document).ready(function () {

    $('#btnUpdate').click(function () {
        debugger;
        var validate = 1;
        if ($('#txtCurrentPassword').val().trim() == '') {
            validate = 0;
            toastr.error('Please enter current password!', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
            $('#txtCurrentPassword').focus();
            return;
        }
        if ($('#txtNewPassword').val().trim() == '') {
            validate = 0;
            toastr.error('Please enter new password!', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
            $('#txtNewPassword').focus();
            return;
        }
        if ($('#txtConfirmPassword').val().trim() == '') {
            validate = 0;
            toastr.error('Please enter Confirm password!', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
            $('#txtConfirmPassword').focus();
            return;
        }
        if ($('#txtConfirmPassword').val().trim() != $('#txtNewPassword').val().trim()) {
            validate = 0;
            toastr.error('New Password and Confirm New Password must be same.!', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
            return;
        }
        if ($('#txtCurrentPassword').val().trim() == $('#txtNewPassword').val().trim()) {
            validate = 0;
            toastr.error('Current Password and New Password can not be same!', 'Warning', { positionClass: 'toast-top-center', containerId: 'toast-top-center' });
            return;
        }
        if (validate==1) {
            var data = {
                OldPassword: $('#txtCurrentPassword').val(),
                NewPassword: $('#txtNewPassword').val(),
            }
            $.ajax({
                type: "POST",
                url: "/Pages/ChangePassword.aspx/changePassword",
                data: JSON.stringify({ dataValue: JSON.stringify(data) }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d == 'true') {
                        swal("", "Password Updated successfully.Please sign in again.", "success", { closeOnClickOutside: false }).then(function () {
                            window.location.href = "/Default.aspx"
                        });
                    }
                    else if (response.d == 'Session') {
                        window.location.href = "/Default.aspx"
                    }
                    else {
                        swal("Error!", response.d, "error", { closeOnClickOutside: false })
                    }
                },
                error: function (result) {
                    swal("Error", JSON.parse(result.responseText).d, "error");
                },
                failure: function (result) {
                    console.log(JSON.parse(result.responseText).d);
                }
            });
        }
       
    });
});


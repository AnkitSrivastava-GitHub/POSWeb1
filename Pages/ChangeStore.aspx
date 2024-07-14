<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ChangeStore.aspx.cs" Inherits="Pages_ChangeStore" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title></title>
    <link rel="icon" href="logo.ico" />
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport" />
    <link rel="stylesheet" href="/Style/bootstrap/css/bootstrap.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.5.0/css/font-awesome.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css" />
    <script src="/Style/plugins/jQuery/jquery-2.2.3.min.js"></script>
    <script src="/Style/js/select2.min.js"></script>
    <link href="/Style/js/toastr.css" rel="stylesheet" />
    <link href="/Style/css/toastr.css" rel="stylesheet" />
    <script src="/Style/js/toastr.min.js"></script>

    <%--<link href="/Style/css/select2.min.css" rel="stylesheet" />--%>
    <link href="/Style/customCSS/Style.css?v=203" rel="stylesheet" />
    <link href="/Style/customCSS/Loaders.css" rel="stylesheet" />

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.3/js/select2.min.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.3/css/select2.min.css" rel="stylesheet" />

    <asp:Literal ID="gt" runat="server"></asp:Literal>
    <style>
        .back-btn {
            width: 100%;
            height: 35px;
            font-size: 17px;
            vertical-align: middle;
            background: #ff0000;
            border: 1px solid #ff0000;
            font-weight: 500;
            box-shadow: -1px 1px 5px rgb(133 133 133 / 34%);
            color: #fff;
        }

            .back-btn:hover {
                width: 100%;
                height: 35px;
                font-size: 17px;
                vertical-align: middle;
                background: #fff;
                border: 1px solid #ff0000;
                font-weight: 500;
                box-shadow: -1px 1px 5px rgb(133 133 133 / 34%);
                color: #ff0000;
            }

        .login1-btn {
            width: 100%;
            height: 35px;
            font-size: 17px;
            vertical-align: middle;
            background: #4cbb9f;
            border: 1px solid #4cbb9f;
            font-weight: 500;
            box-shadow: -1px 1px 5px rgb(133 133 133 / 34%);
            color: #fff;
        }

            .login1-btn:hover {
                width: 100%;
                height: 35px;
                font-size: 17px;
                vertical-align: middle;
                background: #fff;
                border: 1px solid #4cbb9f;
                font-weight: 500;
                box-shadow: -1px 1px 5px rgb(133 133 133 / 34%);
                color: #4cbb9f;
            }

        .Store-Header {
            /*background-color:aquamarine;*/
            color: black;
            font-size: 24px;
            font-weight: 600;
            text-align: center;
            padding: 20px;
            font-family: 'Arial Rounded MT';
            text-align: center;
        }

        body {
            background: #eee;
        }

        .form-control {
            border-radius: 0;
            box-shadow: none;
            border-color: #d2d6de
        }

        .select2-hidden-accessible {
            border: 0 !important;
            clip: rect(0 0 0 0) !important;
            height: 1px !important;
            margin: -1px !important;
            overflow: hidden !important;
            padding: 0 !important;
            position: absolute !important;
            width: 1px !important
        }

        .form-control {
            display: block;
            width: 100%;
            height: 34px;
            padding: 6px 12px;
            font-size: 14px;
            line-height: 1.42857143;
            color: #555;
            background-color: #fff;
            background-image: none;
            border: 1px solid #ccc;
            border-radius: 4px;
            -webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075);
            box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075);
            -webkit-transition: border-color ease-in-out .15s, -webkit-box-shadow ease-in-out .15s;
            -o-transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
            transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s
        }

        .select2-container--default .select2-selection--single,
        .select2-selection .select2-selection--single {
            border: 1px solid #d2d6de;
            border-radius: 0;
            padding: 6px 12px;
            height: 34px
        }

        .select2-container--default .select2-selection--single {
            background-color: #fff;
            border: 1px solid #aaa;
            border-radius: 4px
        }

        .select2-container .select2-selection--single {
            box-sizing: border-box;
            cursor: pointer;
            display: block;
            height: 28px;
            user-select: none;
            -webkit-user-select: none
        }

            .select2-container .select2-selection--single .select2-selection__rendered {
                padding-right: 10px
            }

            .select2-container .select2-selection--single .select2-selection__rendered {
                padding-left: 0;
                padding-right: 0;
                height: auto;
                margin-top: -3px
            }

        .select2-container--default .select2-selection--single .select2-selection__rendered {
            color: #444;
            line-height: 28px
        }

        .select2-container--default .select2-selection--single,
        .select2-selection .select2-selection--single {
            border: 1px solid #d2d6de;
            border-radius: 0 !important;
            padding: 6px 12px;
            height: 40px !important
        }

            .select2-container--default .select2-selection--single .select2-selection__arrow {
                height: 26px;
                position: absolute;
                top: 6px !important;
                right: 1px;
                width: 20px
            }
    </style>
</head>
<body class="hold-transition login-page login-bodybg">
    <form id="form1" runat="server">
        <div class="custome-login" style="width: 36% !important; border: 0px; border-radius: 8px">
            <div class="row">

                <div class="col-md-12">
                    <div>
                        <h1 class="Store-Header">Select Store</h1>
                    </div>
                    <div class="login-rightsied login-rightsied" id="login">

                        <div class="form-group" style="padding: 0px 23px 44px 23px;">
                            <select id="ddlStore" class="form-control">
                                <option value="0">Select Store</option>
                            </select>
                        </div>

                        <div class="row">
                            <div class="col-md-2">
                            </div>
                            <div class="col-md-4">
                                <button type="button" class="back-btn" onclick="GoBack()"><i class="fa fa-arrow-circle-left" title="Back" style="font-size: 30px; vertical-align: middle;"></i>&nbsp;&nbsp;Go Back</button>
                            </div>
                            <div class="col-md-4">
                                <button type="button" class="login1-btn" onclick="ChangeStore()">Proceed&nbsp;&nbsp;<i class="fa fa-arrow-circle-right" title="Back" style="font-size: 30px; vertical-align: middle;"></i></button>
                            </div>
                            <div class="col-md-2">
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-lg-12" style="background-color: transparent; color: white; border-top: none; position: fixed; bottom: 0px;">
                <center><strong>Design & Developed by <a href="http://www.priorware.com/" target="_blank"><span style="color: orange">Priorware IT Solutions</span></a>.</strong> All rights reserved.</center>
            </div>
        </div>
    </form>
    <%-- <script src="/Style/js/jquery-3.7.0.min.js"></script>--%>
    <script src="/Style/bootstrap/js/bootstrap.min.js"></script>
    <script src="/Style/plugins/iCheck/icheck.min.js"></script>
    <script src="/Style/js/sweetalert.min.js"></script>
    <script>
        //$(function () {
        //    $('input').iCheck({
        //        checkboxClass: 'icheckbox_square-blue',
        //        radioClass: 'iradio_square-blue',
        //        increaseArea: '20%' // optional
        //    });
        //});
    </script>
    <script>
        $("input[type=text]").focus(function () {
            $(this).select();
        });
        $("#password").focus(function () {
            $(this).select();
        })

    </script>
</body>
</html>

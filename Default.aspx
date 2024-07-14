<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title></title>
    <link rel="icon" href="logo.ico" />
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport" />
    <link rel="stylesheet" href="Style/bootstrap/css/bootstrap.min.css" />
    <link href="Style/customCSS/Style.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.5.0/css/font-awesome.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css" />
    <link rel="stylesheet" href="Style/dist/css/AdminLTE1.min.css" />
    <link rel="stylesheet" href="Style/plugins/iCheck/square/blue.css" />
    <script src="Style/plugins/jQuery/jquery-2.2.3.min.js"></script>
    <script src="Style/js/select2.min.js"></script>
    <link href="Style/js/toastr.css" rel="stylesheet" />
    <link href="Style/css/toastr.css" rel="stylesheet" />
    <script src="Style/js/toastr.min.js"></script>
    <asp:Literal ID="gt" runat="server"></asp:Literal>

     <script>
         history.pushState(null, document.title, location.href);
         history.back();
         history.forward();
         window.onpopstate = function () {
             history.go(1);
         };
     </script>
</head>
<body class="hold-transition login-page login-bodybg">
    <form id="form1" runat="server" class="mainform">
        <div class="custome-login2   LoginTerminal">
            <div class="row">
                <div class="col-md-6">
                    <img src="/images/pos.png" class="custome-loginimg" />
                </div>
                <div class="col-md-6" style="padding: 80px 15px 20px 15px;">
                    <div class="logo-cl">
                        <img src="/images/logo.png" class="logoimg">
                    </div>
                    <div class="login-rightsied login-rightsied" id="login">
                        <p class="lg-p">Sign in to start your session</p>
                        <div class="form-group has-feedback lg-m">
                            <input type="text" id="txtusername" class="form-control" placeholder="Username" />
                        </div>
                        <div class="form-group has-feedback lg-m">
                            <input type="password" id="txtpassword" class="form-control" placeholder="Password" />
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <input type="button" class="login-btn" id="btnlogin" value="Login" />
                            </div>
                        </div>
                    </div>

                    <div class="login-rightsied login-rightsied" id="DivTerminal" style="display: None">
                        <div class="form-group has-feedback lg-m" style="text-align: center;">
                            <h5 id="StoreName" style="font-size: 25px;font-weight: 700;"></h5>
                            <p class="lg-p">Select Login Terminal</p>
                        </div>
                        <div class="form-group has-feedback lg-m">
                            <select id="ddlTerminal" class="form-control">
                                <option value="0">Select Terminal</option>
                            </select>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <input type="button" class="login-btn" value="Proceed" onclick="ProceedCashier()" />
                            </div>
                        </div>
                        <div class="row" style="margin-top: 10px">
                            <div class="col-md-12">
                                <button type="button" class="back-btn" value="Go Back" onclick="BackLogin()"><i class="fa fa-arrow-left"></i>&nbsp;&nbsp;Go Back</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="OpeningBalance form-group" style="display: none">
            <div class="row" style="padding: 0px 15px 15px 15px;">
                <div class="cardm-Heading" style="white-space: nowrap;">
                    <span class="modal-title" id="BalanceStatusHeader" style="text-align: left">Shift Opening </span>
                    <span class="modal-title" style="text-align: right" id="txtTodayDate"></span>
                </div>
                <input type="hidden" id="BalanceStatus" />
                <div class="div-body" style="font-size:19px;">
                    <div class="row form-group" style="margin-top: 3px">
                        <div class="col-md-3">
                            <label style="white-space: nowrap;">Previous Closing Date:</label>
                        </div>
                        <div class="col-md-3">
                            <input type="text" id="txtClosingDate" disabled="disabled" class="form-control input-sm" readonly="readonly" style="font-size:19px" />
                        </div>
                        <div class="col-md-3">
                            <label id="lbl_ClosingBal" style="white-space: nowrap;">Previous Closing Balance:</label>
                        </div>
                        <div class="col-md-3">
                            <div class="input-group">
                                <span class="input-group-addon input-md symbol" style="font-weight:600"></span>
                                <input type="text" id="txtClosingBalance" placeholder="0.00" style="text-align: right;font-size:19px" class="form-control input-sm" disabled="disabled" />
                            </div>
                        </div>
                        <%--<div class="col-md-2">
                        <label>Time:</label>
                    </div>
                    <div class="col-md-4">
                        <input type="text" id="txtCurrentTime" class="form-control input-sm" readonly="readonly" />
                    </div>--%>
                    </div>
                    <div class="row form-group" >
                        <div class="col-md-3" style="display:none">
                            <label>Date & Time:</label>
                        </div>
                        <div class="col-md-3" style="display:none">
                            <input type="text" class="form-control input-sm" style="font-size:19px" readonly="readonly" />
                        </div>
                        <div class="col-md-3">
                            <label id="balanceStatusText">Opening Balance:</label>
                        </div>
                        <div class="col-md-3">
                            <div class="input-group">
                                <span class="input-group-addon input-md symbol" style="font-weight:600"></span>
                                <input type="text" id="txtBalance" onkeypress="return isNumberDecimalKey(event,this)" disabled="disabled" style="text-align: right;font-size:19px" class="form-control input-sm" placeholder="0.00" />
                            </div>
                        </div>
                    </div>
                    <hr />
                    <div class="row form-group">
                        <style>
                            #tableCurrency {
                                border: 1px solid Black;
                                border-collapse: collapse;
                                text-align: center;
                            }

                                #tableCurrency tr {
                                    border: 1px solid Black;
                                    border-collapse: collapse;
                                    text-align: center;
                                }

                                    #tableCurrency tr th {
                                        border: 1px solid Black;
                                        border-collapse: collapse;
                                        text-align: center;
                                        padding-left: 5px;
                                        padding-right: 5px;
                                        font-size: 20px
                                    }

                            #txtTodayDate {
                                float: right;
                                text-align: right;
                                font-weight: bold;
                                font-size: 24px;
                            }
                            #txtQTY {
                                background-color: antiquewhite;
                            }
                        </style>
                        <div class="col-md-12" style="overflow-x: auto;">
                            <table id="tableCurrency" style="width: 100%;">
                                <thead style="background-color: #96D4D4;">
                                    <tr>
                                        <th class="CCode" style="display: none; text-align: center">Currency Code</th>
                                        <th class="Amount" style="width: 33.33%; text-align: center">Amount(<span class="symbol"></span>)</th>
                                        <th class="QTY" style="width: 33.33%; text-align: center">QTY</th>
                                        <th class="TotalA" style="width: 33.33%; text-align: center">Total(<span class="symbol"></span>)</th>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>

                        </div>
                    </div>

                    <div class="row" style="text-align: center; margin-bottom: -10px;">
                        <button type="button" class="btn btn-sm btn-danger btnBack" style="display: none;" id="btnOpeningBack" onclick="BackLogin2();">Back</button>
                        <button type="button" class="btn btn-sm btn-success btnBack" style="display: none;" id="btnOpeningProceed" onclick="ProceedOpeningBalanceModal()">Start Shift</button>

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
    <script src="Style/js/jquery-3.7.0.min.js"></script>
    <script src="Style/bootstrap/js/bootstrap.min.js"></script>
    <script src="Style/plugins/iCheck/icheck.min.js"></script>
    <script src="Style/js/sweetalert.min.js"></script>
    <script>
        $(function () {
            $('input').iCheck({
                checkboxClass: 'icheckbox_square-blue',
                radioClass: 'iradio_square-blue',
                increaseArea: '20%' // optional
            });
        });
    </script>
    <script>
        $("input[type=text]").focus(function () {
            $(this).select();
        });
        $("#password").focus(function () {
            $(this).select();
        })

    </script>
    <style>
        .OpeningBalance {
            background: #fff;
            border-radius: 25px;
            border: 15px solid #f1f1f1;
            box-shadow: 0 10px 20px rgba(0,0,0,0.19), 0 6px 6px rgba(0,0,0,0.23);
            width: 58%;
            margin: 2% auto;
            position: absolute;
            left: 22%;
            right: 50%;
        }

        .minus-no {
            width: 170px;
            border: 1px solid black;
        }

        .cardm-Heading {
            background-color: cadetblue;
        }

        #BalanceStatusHeader {
            font-size: 26px;
            font-weight: 700;
        }

        .btnBack {
            width: 140px;
            height: 41px;
            font-size: 20px;
            font-weight: bolder;
        }

        .div-body {
            padding: 4px;
        }
    </style>
</body>
</html>

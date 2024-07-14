<%@ Page Language="C#" AutoEventWireup="true" CodeFile="POSScreen.aspx.cs" Inherits="Pages_POSScreen" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <link rel="icon" href="/logo.ico" />
    <title>POSWeb</title>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport" />
    <link rel="stylesheet" href="/Style/bootstrap/css/bootstrap.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.5.0/css/font-awesome.min.css" />
    <link rel="stylesheet" href="/Style/dist/css/AdminLTE.min.css" />
    <link rel="stylesheet" href="/Style/dist/css/skins/_all-skins.min.css" />
    <link href="/Style/customCSS/jquery-ui.css" rel="stylesheet" />
    <link href="/Style/css/select2.min.css" rel="stylesheet" />
    <link href="/Style/customCSS/Style.css?v=202" rel="stylesheet" />
    <link href="/Style/customCSS/Loaders.css" rel="stylesheet" />
    <link href="/Style/customCSS/Radiotoggle.css" rel="stylesheet" />
    <script src="/Style/plugins/jQuery/jquery-2.2.3.min.js"></script>
    <script src="/Style/js/select2.min.js"></script>
    <script src="/Style/js/sweetalert.min.js"></script>
    <link href="/Style/js/toastr.css" rel="stylesheet" />
    <link href="/Style/css/toastr.css" rel="stylesheet" />
    <script src="/Style/js/toastr.min.js"></script>
    <script src="/js/Calculator.js"></script>

    <script type="text/javascript" src="/Style/js/picker.js"></script>
    <script type="text/javascript" src="/Style/js/picker.time.js"></script>
    <script type="text/javascript" src="/Style/js/picker.date.js"></script>
    <link rel="stylesheet" type="text/css" href="/Style/css/pickadate.css" />
    <link rel="stylesheet" type="text/css" href="/Style/css/daterangepicker.css" />

    <%-- <script src="/Style/js/sweetalert2.min.js"></script>--%> <%--sweet alert 2--%>
    <%--<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script> --%><%--sweet alert 2--%>
    <script>
        history.pushState(null, document.title, location.href);
        history.back();
        history.forward();
        window.onpopstate = function () {
            history.go(1);
        };
    </script>
    <style>
        .disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        body {
            padding-right: 0 !important
        }

        .modal {
            padding-right: 0px !important;
        }

        .btn-headerclose {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 0px;
        }

        .spnUnitPrice {
            padding-left: 0px !important;
        }

        .spntax {
            padding-left: 0px !important;
        }

        .tableFixHead {
            overflow-y: auto; /* make the table scrollable if height is more than 200 px  */
            height: 430px; /* gives an initial height of 200px to the table */
        }

            .tableFixHead > .force-overflow {
                position: sticky; /* make the table heads sticky */
                top: 0px; /* table head will be placed from the top of the table and sticks to it */
            }

        .AddToHomeFixHead {
            overflow-y: auto; /* make the table scrollable if height is more than 200 px  */
            height: 428px; /* gives an initial height of 200px to the table */
            overflow-x: hidden;
        }

            .AddToHomeFixHead > .force-overflow {
                position: sticky; /* make the table heads sticky */
                top: 0px; /* table head will be placed from the top of the table and sticks to it */
            }

        .Focus {
            outline: none;
            box-shadow: none !important;
        }



        .btn-info:hover {
            background-color: #5bc0de;
            border: none;
        }

        #btnSearch:hover {
            background-color: #5bc0de;
            border: none;
            color: white;
        }

        .swal-text {
            /*background-color: #FEFAE3;*/
            /*padding: 17px;
            border: 1px solid #F0E1A1;*/
            display: block;
            margin: 35px !important;
            text-align: center;
            font-size: 35px !important;
            /*color: #61534e;*/
        }

        .swal-modal {
            width: 524px !important;
        }

        #btnSave, #btnUpdate, #btnDeposit1, #btnWithdraw1 {
            border: 1px solid #3eb750;
            color: #fff;
            font-weight: 600;
            font-size: 20px;
            padding: 1px 20px;
            background: #3eb750;
            width: 120px;
            height: 40px;
        }

        #btnReset, #btnDReset {
            background: #ff6868;
            border: 1px solid #ff6868;
            font-weight: 600;
            font-size: 20px;
            color: #fff;
            padding: 1px 15px;
            width: 120px;
            height: 40px;
        }

            #btnReset:hover, #btnDReset:hover {
                background: #fff;
                color: #ff6868;
                border: 1px solid #ff6868;
            }

        #btnUpdate:hover, #btnSave:hover, #btnDeposit1:hover, #btnWithdraw1:hover {
            border: 1px solid #3eb750;
            color: #3eb750;
            background: #fff;
        }

        #Fscreen:hover {
            background-color: #ff6868;
        }

        .symbol {
            margin: 0px;
            margin-right: -2px;
        }
    </style>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#fullscreen").on("click", function () {
                document.fullScreenElement && null !== document.fullScreenElement || !document.mozFullScreen && !document.webkitIsFullScreen ? document.documentElement.requestFullScreen ? document.documentElement.requestFullScreen() : document.documentElement.mozRequestFullScreen ? document.documentElement.mozRequestFullScreen() : document.documentElement.webkitRequestFullScreen && document.documentElement.webkitRequestFullScreen(Element.ALLOW_KEYBOARD_INPUT) : document.cancelFullScreen ? document.cancelFullScreen() : document.mozCancelFullScreen ? document.mozCancelFullScreen() : document.webkitCancelFullScreen && document.webkitCancelFullScreen()
            });
        });
    </script>
    <script>
        var index = 1;

        $("input select button").each(function () {
            debugger
            $(this).attr("tabindex", index);
        });
    </script>
</head>
<body id="bdy">
    <form id="form1" runat="server">
        <div class="panel panel-default" style="margin-bottom: 0px">

            <div class="panel-heading" style="background-color: #3b8981; border-bottom-color: #3b8981; color: #fff;">
                <div class="row">
                    <div class="col-md-4" id="spnUserName" style="font-size: 24px; font-weight: 600;">
                    </div>
                    <div class="col-md-4" id="spnCompany" style="font-size: 24px; font-weight: 600; text-align: center; white-space: nowrap;">
                    </div>
                    <div class="col-md-4" id="spnTimer" style="font-size: 24px; font-weight: 600; text-align: right;">
                    </div>
                    <a id="fullscreen" title="Fullscreen" style="display: none">
                        <img src="../Style/img/fullscreen.png" id="Fscreen" style="height: 25px;" /></a>


                    <%--<div class="col-md-1" id="" style="margin-top: 3px">
                        <input type="button" class="btn btn-info" onclick="ClockInOutPopUp();" value="Clock In/Out" />
                    </div>--%>
                    <%--<div class="col-md-4" style="text-align: right">
                        <a class="btn btn-sm btn-headerclose" id="btnClosePOS" visible="false" runat="server" href="DashBoard.aspx">Close</a>
                        <a class="btn btn-sm btn-headerclose" id="btnAdminPOS" visible="false" onclick="AdminModal()" runat="server" href="#">Admin</a>
                        <a class="btn btn-sm btn-headerclose" id="btnLogout" onclick="Logout()" visible="false" runat="server" href="#">Log Out</a>
                    </div>--%>
                </div>
            </div>
            <div class="panel-body" style="padding-bottom: 0px; padding-top: 10px;">
                <div class="row">
                    <div class="col-md-4">
                        <input type="hidden" runat="server" id="hdnEmpId" value="1" />
                        <input type="hidden" runat="server" id="hdnEmpAutoId" value="" />
                        <input type="hidden" runat="server" id="hdnMinOrderAmtToReedemReward" value="" />
                        <input type="hidden" runat="server" id="hdnReedemRewardStatus" value="0" />
                        <input type="hidden" runat="server" id="hdnOrderId" value="" />
                        <input type="hidden" runat="server" id="hdnOrderNo" value="" />
                         <input type="hidden" runat="server" id="hdnMaxRedeemHappyPoints" value="0" />

                        <div class="row">
                            <div class="col-md-12 form-group" style="margin-bottom: 10px">
                                <input type="text" class="form-control input-sm" tabindex="1" maxlength="30" aria-autocomplete="none" autocomplete="off" id="txtBarcode" runat="server" onfocus="this.select()" placeholder="Enter Barcode" autofocus="autofocus" onchange="readBarcode()" onpaste="var e=this; setTimeout(function(){readBarcodeOnPaste(e)}, 4);" />
                            </div>
                        </div>

                        <div class="row scrollbar tableFixHead style-3">
                            <div class="col-md-12 force-overflow" id="tblProductDetail"></div>
                        </div>
                        <hr />
                        <div class="row" style="margin-top: -17px; margin-bottom: -20px;">
                            <div class="col-md-6 form-group" style="margin-bottom: 0px">
                                <label>Product Count :</label><span style="margin-left: 10px" id="totalProductCnt"></span>
                            </div>
                            <div class="col-md-6 form-group" style="margin-bottom: 0px">
                                <label>Quantity :</label><span style="margin-left: 10px" id="totalQuantityCnt">0</span>
                            </div>
                        </div>
                        <hr />
                        <div class="row" style="margin-top: -15px;">
                            <div class="col-md-5">
                                <div class="row">
                                    <div class="col-md-5">Subtotal</div>
                                    <div class="col-md-7 text-right">
                                        <label style="display: none;" id="lblsubtotal">0.00</label>
                                        <strong>
                                            <span id="lblsubtotal1">
                                                <span class="symbol"></span>
                                                0.00</span>
                                        </strong>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-5">Tax</div>
                                    <div class="col-md-7 text-right">
                                        <strong>
                                            <span class="symbol"></span>
                                            <label id="lbltax">0.00</label></strong>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-5">Discount<span id="DiscType"></span></div>
                                    <div class="col-md-7 text-right" style="white-space: nowrap;">
                                        <strong><span id="lbldiscount1" style="margin-left: 27px;"><span class="symbol" style="margin-right: 1px;"></span>0.00</span><img src="../Images/del.png" id="DiscRemove" title="Remove Discount" style="margin-top: -23px; margin-right: -42px; display: none;"
                                            class="del-btnp" onclick="CancelDiscount()" /></strong><label style="display: none" id="lbldiscount">0.00</label>
                                    </div>
                                </div>
                                <div class="row" id="Lotterylbl" style="display: none">
                                    <div class="col-md-5" style="white-space: nowrap;">Lottery Total</div>
                                    <div class="col-md-7 text-right">
                                        <strong>
                                            <label id="lblLottery">0.00</label></strong>
                                    </div>
                                </div>
                                <div class="row" style="display: none;">
                                    <div class="col-md-5">Lotto Payout</div>
                                    <div class="col-md-7 text-right">
                                        <strong>
                                            <span class="symbol"></span>
                                            <label id="lblLottoPayout">0.00</label></strong>
                                    </div>
                                </div>
                                <div class="row Gift" style="display: none">
                                    <div class="col-md-5">Coupon</div>
                                    <label id="lblcoupanType" style="display: none"></label>
                                    <label id="lblcoupanDisc" style="display: none"></label>
                                    <label id="lblcoupanId" style="display: none"></label>
                                    <label id="lblcoupanMin" style="display: none"></label>
                                    <div class="col-md-7 text-right">-<span class="symbol"></span><label id="lblcoupan">0.00</label><img src="../Images/del.png" title="Remove" class="del-btnp" style="position: initial;" onclick="RemoveGift()" /></div>
                                </div>
                                <div class="row" id="DivGiftCard" style="display: none">
                                    <div class="col-md-5" style="white-space: nowrap;">Gift Card<span id="spnGiftCardNo"></span></div>
                                    <div class="col-md-7 text-right">
                                        <label style="display: none" id="lblGiftCardAmt">0.00</label><strong><span id="lblGiftCardAmt1"><span class="symbol"></span>0.00</span></strong>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-7">
                                <div class="row">
                                    <div class="col-md-12" style="font-size: 20px; font-weight: 800; color: green; text-align: center" id="lblOdrTotal">
                                        Order Total
                                    </div>

                                </div>
                                <div class="row">

                                    <div class="col-md-12 text-right" style="font-size: 42px; font-weight: 800; color: green; text-align: center">
                                        <label style="display: none" id="lblgrandtotal">0.00</label>
                                        <span id="lblgrandtotal1">0.00</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-8">
                        <div class="row form-group">
                            <div class="col-md-1 form-group" style="vertical-align: middle; margin-bottom: 1px">
                                <label class="labelgenaretinvoice" style="margin-bottom: 0px; margin-left: -15px; font-size: 19px">
                                    Customer
                                </label>
                            </div>
                            <div class="col-md-3 form-group" style="margin-bottom: 0px">
                                <div class="input-group">
                                    <input type="hidden" id="hdnCustomerId" value="1" />
                                    <input type="hidden" id="hdnCustomerDOB" value="1" />
                                    <input type="hidden" id="hdnRoyaltyPoints" value="0" />
                                    <input name="ctl00$ddlCustomer" type="text" id="ddlCustomer" class="form-control input-sm Focus" style="width: 100% !important;" readonly="readonly" />
                                    <div class="cig input-group-addon cus_style" style="padding: 0px">
                                        <a id="hrefAddName" class="custo-icon pull-right btn btn-info btn-sm" onclick="openCustomerModal()" style="height: 29px;">
                                            <img src="/Images/Cust2.png" style="height: 22px; width: 22px; margin-top: 2px;" />
                                        </a>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-1 form-group" style="margin-right: -10px">
                                <label class="labelgenaretinvoice" style="margin-bottom: 0px; font-size: 19px;">
                                    Search 
                                </label>
                            </div>
                            <div class="col-md-7 form-group">
                                <div class="input-group">
                                    <input type="text" id="txtSearchProduct" tabindex="2" maxlength="100" class="form-control input-sm" onchange="BindProductList(0);" placeholder="Enter Product Name" style="width: 100% !important;" />  
                                    <div class="cig input-group-addon" style="padding: 0px">
                                        <button id="btnSearch" tabindex="3" type="button" onclick="BindProductList(0);"
                                            style="height: 29px; padding: 0px; width: 70px;"
                                            class="btn-sm catsearch-btn">
                                            Search</button>
                                    </div>
                                </div>

                            </div>
                            <div class="col-md-12 form-group" style="padding: 0px; margin-bottom: 0px">
                                <ul class="abc" id="ScreenList" style="height: 50px !important; overflow-y: scroll;">
                                </ul>
                            </div>
                        </div>
                        <div class="row scrollbar style-3" style="height: 450px !important; scroll-behavior: auto;">
                            <style>
                                .abc {
                                    list-style-type: none;
                                    margin: 0;
                                    padding: 0;
                                    overflow: hidden;
                                    background-color: white;
                                }

                                    .abc input {
                                        float: left;
                                        text-align: center;
                                        margin: 1px 2px;
                                        border-radius: 0px;
                                        padding: 6px 12px 7px 12px;
                                        min-width: 120px;
                                        border-radius: 24px;
                                        font-size: 22px;
                                    }

                                .Active {
                                    background-color: #ffc42e;
                                    border: 2px dotted #e4b02a;
                                }

                                .abc li :hover {
                                    border: 2px dotted #ffc42e;
                                    color: azure;
                                    background-color: #ffc42e;
                                }

                                .Category {
                                    font-size: 19px !important;
                                }

                                #loading {
                                    position: fixed;
                                    display: flex;
                                    justify-content: center;
                                    align-items: center;
                                    width: 100%;
                                    height: 100%;
                                    top: 0;
                                    left: 0;
                                    opacity: 0.7;
                                    background-color: #fff;
                                    z-index: 99;
                                }
                            </style>
                            
                            <div class="col-md-12 form-group force-overflow" style="padding: 0px; margin-bottom: 0px;">
                                <div id="ProductList" style="margin-top: 3px">
                                </div>
                            </div>
                        </div>
                        <hr />
                        <div class="row">
                            <div class="col-md-4">
                                <button type="button" onclick="OpenModalAction()" class="exact-btn btn btn-primary">Action</button>
                            </div>
                            <div class="col-md-4">
                                <button type="button" onclick="NewOrder()" class="reset-btn btn btn-primary">Reset</button>
                            </div>

                            <div class="col-md-4">
                                <button type="button" id="txt_PayNow" onclick="OpenCashModal()" disabled="disabled" class="cash-btn btn btn-primary">Pay Now</button>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
    <script src="https://code.jquery.com/ui/1.11.4/jquery-ui.min.js"></script>
    <!-- Resolve conflict in jQuery UI tooltip with Bootstrap tooltip -->
    <script>
        $.widget.bridge('uibutton', $.ui.button);
    </script>
    <%-- <script src="/js/POS.js?v=5"></script>--%>
    <script type="text/javascript">
        document.write('<scr' + 'ipt defer type="text/javascript" src="/js/POS.js?v=' + new Date() + '"></scr' + 'ipt>');
    </script>
    <script src="/Style/bootstrap/js/bootstrap.min.js"></script>
    <!-- daterangepicker -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.11.2/moment.min.js"></script>
    <!-- datepicker -->
    <script src="/Style/js/jquery-ui.js"></script>
    <!-- Bootstrap WYSIHTML5 -->
    <script src="/Style/plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.all.min.js"></script>
    <!-- Slimscroll -->
    <script src="/Style/plugins/slimScroll/jquery.slimscroll.min.js"></script>
    <!-- FastClick -->
    <script src="/Style/plugins/fastclick/fastclick.js"></script>
    <!-- AdminLTE App -->
    <script src="/Style/dist/js/app.min.js"></script>
    <!-- AdminLTE for demo purposes -->
    <script src="/Style/dist/js/demo.js"></script>
    <!-- DataTables -->
    <script src="/Style/js/commonFunction.js"></script>
    <script src="/js/Calculator.js"></script>

    <div id="loading" style="z-index: 9999;">
        <img id="loading-image" src="/Style/img/spinner.gif" alt="Loading..." />
    </div>

    <script>
        $(window).load(function () {
            $('#loading').hide();
        });
    </script>

    <div class="modal fade" id="ModalAction" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-dialog-centered actionb-p" role="document">
            <div class="modal-content card-p">
                <div class="modal-header cardm-head">
                    <h5 class="modal-title">Action
                        <img src="../Images/del.png" class="del-btnp" onclick="CloseModalAction()" />
                    </h5>
                </div>
                <div class="modal-body" style="padding: 15px 0 0 0;">
                    <div class="row">
                        <div class="col-md-4">
                            <button type="button" onclick="NoSalePopUp()" class="nosale-btn btn btn-primary">No Sale</button>
                        </div>
                        <div class="col-md-4">
                            <button type="button" onclick="OpenDraftModal()" class="savedraft-btn btn btn-primary">Save as Draft Order</button>
                        </div>
                        <div class="col-md-4">
                            <button type="button" onclick="BindOrderDraftLogList()" class="draft-btn btn btn-primary">Draft List</button>
                        </div>
                    </div>
                    <div class="clearfix"></div>
                    <div class="row form-group ac-rp">
                        <div class="col-md-4">
                            <button type="button" id="DiscBTN" onclick="openDisc()" class="disc-btn btn btn-primary">Discount</button>
                        </div>
                        <div class="col-md-4">
                            <button type="button" onclick="OpenScreenList()" class="addhome-btn btn btn-primary">Add Screen</button>
                        </div>
                        <div class="col-md-4">
                            <button type="button" onclick="OpenAddtoHome()" class="addhome-btn btn btn-primary">Add To Screen</button>
                        </div>
                    </div>

                    <div class="row form-group ac-rp">
                        <div class="col-md-4">
                            <button type="button" id="btnDeposit" onclick="Deposit();" runat="server" class="Deposit-btn btn btn-primary col-md-4">Deposit</button>
                        </div>
                        <div class="col-md-4">
                            <button type="button" id="btnWithdraw" onclick="Withdraw();" runat="server" class="Withdraw-btn btn btn-primary col-md-4">Withdraw</button>
                        </div>
                        <div class="col-md-4">
                            <button type="button" id="btnSafe" class="Safe-btn btn btn-primary col-md-4" onclick="SafeCashList();" value="Clock In/Out">Safe Cash List</button>
                        </div>
                        <%--<div class="col-md-4">
                            <button type="button" onclick="OpenLottoPaout()" class="disc-btn btn btn-primary">Lotto Payout</button>
                        </div>--%>
                    </div>
                    <div class="row form-group ac-rp">
                        <div class="col-md-4">
                            <button type="button" onclick="PayoutModal()" class="PayList-btn btn btn-primary">Payout</button>
                        </div>
                        <div class="col-md-4" id="PayoutList">
                            <button type="button" onclick="ViewPayoutList()" class="PayList-btn btn btn-primary">Payout List</button>
                        </div>
                        <div class="col-md-4" id="DivClose">
                            <button type="button" id="btnClosePOS" visible="false" onclick="GoToDashBoard()" runat="server" class="Close-btn btn btn-primary col-md-4">Close</button>
                        </div>
                        <div class="col-md-4" id="DivAdmin">
                            <button type="button" onclick="ViewInvoiceList()" class="card-btn btn btn-primary">Invoice List</button>
                        </div>
                    </div>
                    <div class="row form-group ac-rp">
                        <div class="col-md-4">
                            <button type="button" id="btnAdminPOS" visible="false" onclick="AdminModal()" runat="server" class="Admin-btn btn btn-primary col-md-4">Admin</button>
                        </div>
                        <div class="col-md-4">
                            <button type="button" id="btnLogout" visible="false" onclick="Logout()" runat="server" class="logout-btn btn btn-primary col-md-4">End Shift</button>
                        </div>
                        <div class="col-md-4" id="DivLogout">
                            <button type="button" class="PayOut-btn btn btn-primary col-md-4" onclick="ClockInOutPopUp();" value="Clock In/Out">Clock In/Out</button>
                        </div>

                    </div>
                    <div class="row form-group ac-rp">
                        <div class="col-md-4">
                            <button type="button" id="btn_GiftCard" onclick="GiftCard();" runat="server" class="PayOut-btn btn btn-primary col-md-4">Sale Gift Card</button>
                        </div>
                        <div class="col-md-4">
                            <button type="button" id="btn_GiftCardLook" onclick="GiftCardLookUp();" runat="server" class="PayOut-btn btn btn-primary col-md-4">Gift Card Look Up</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="ModalDeposit" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-dialog-centered actionb-p modal-md" role="document">
            <div class="modal-content card-p">
                <div class="modal-header cardm-head Deposit">
                    <h5 class="modal-title">Safe Cash Deposit 
                        <img src="../Images/del.png" class="del-btnp" id="CloseModalD" onclick="FocusOnBarCode()" data-dismiss="modal" />
                    </h5>
                </div>
                <div style="display: none" class="modal-header cardm-head Withdraw">
                    <h5 class="modal-title">Safe Cash Withdraw 
        <img src="../Images/del.png" class="del-btnp" id="CloseModalDD" onclick="FocusOnBarCode()" data-dismiss="modal" />
                    </h5>
                </div>
                <div class="modal-body" style="padding: 15px 0 0 60px; font-size: 18px">
                    <div class="row">
                        <label class="col-md-3 form-group">
                            Date
                        </label>
                        <div class="col-md-9 form-group">
                            <input type="text" id="texDate" disabled="disabled" style="width: 340px" value="0.00" class="form-control input-sm" />
                        </div>
                    </div>
                    <div class="row">
                        <label class="col-md-3 form-group">
                            Amount<span class="required"> *</span>
                        </label>
                        <div class="col-md-9 form-group">
                            <div class="input-group">
                                <span class="input-group-addon input-sm symbol"></span>
                                <input type="text" id="txtDAmount" maxlength="12" style="width: 314px; text-align: right" value="0.00" oncopy="return false" onpaste="return false" oncut="return false" onkeypress="return isNumberDecimalKey(event, this)" class="form-control input-sm" placeholder="0.00" />
                            </div>

                        </div>
                    </div>
                    <div class="row">
                        <label class="col-md-3 form-group">
                            Remark</label>
                        <div class="col-md-9 form-group">
                            <textarea type="text" maxlength="250" style="min-width: 340px; min-height: 78px; max-width: 340px; max-height: 78px;"
                                id="txtDRemark" class="form-control input-sm" placeholder="Remark"> </textarea>
                        </div>
                    </div>
                    <div class="row">
                        <label class="col-md-3 form-group">
                            Status</label>
                        <div class="col-md-9 form-group">
                            <select id="ddlSStatus" disabled="disabled" style="width: 340px; height: 35px;"
                                class="form-control input-sm">
                                <option value="0" selected="selected">Open</option>
                            </select>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-lg-12" style="margin-top: 3px">
                            <div class="pull-right">
                                <button type="button" class="btn btn-sm catsave-btn Deposit" id="btnDeposit1" onclick="this.disabled = true;SaveDeposit();">Save</button>
                                <button type="button" class="btn btn-sm catsave-btn Withdraw" id="btnWithdraw1" onclick="this.disabled=true;SaveWithdraw();">Save</button>
                                <button type="button" id="btnDReset" onclick="DepositReset();" class="btn btn-sm catreset-btn">Reset</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="GiftCardLookUp" role="dialog" data-backdrop="static" data-keyboard="false" style="overflow-y: scroll; overflow-x: hidden;">
        <div class="modal-dialog modal-dialog-centered modal-lg" style="width: 1000px;" role="document">
            <div class="modal-content card-p">
                <div class="modal-header cardm-head">
                    <h5 class="modal-title">Gift Card Look Up
             <img src="../Images/del.png" class="del-btnp" onclick="CloseGiftList()" />
                    </h5>
                </div>
                <div class="modal-body" style="padding: 0px; margin-top: 15px">
                    <div class="row" style="margin-bottom: 10px;">
                        <div class="col-md-4">
                            <label>Gift Card Code</label>
                            <input type="text" id="txtGiftCode" maxlength="30" class="form-control input-sm" placeholder="Gift Card Code" />
                        </div>
                        <div class="col-md-4">
                            <label>Invoice No.</label>
                            <input type="text" id="txtInvoice" maxlength="30" onkeypress="return isNumberKey(event)" class="form-control input-sm" placeholder="Invoice No." />
                        </div>
                        <div class="col-md-4">
                            <label>Mobile No.</label>
                            <input type="text" id="txtMobile" maxlength="10" class="form-control input-sm" onkeypress="return isNumberKey(event)" placeholder="Mobile No." />
                        </div>
                    </div>
                    <div class="row text-left">
                        <div class="col-md-4">
                            <label>Email ID</label>
                            <input type="text" id="txtEmail" maxlength="80" class="form-control input-sm" placeholder="Email ID" />
                        </div>

                        <div class="col-md-8 text-right">
                            <button id="btnSearchGift" style="margin-top: 29px" type="button" onclick="BindGiftCardSearch(1);" class="btn btn-sm catsearch-btn pull-right">Search</button>
                        </div>
                    </div>
                    <div class="table-responsive" style="padding-top: 10px;">
                        <table id="tblGiftList" class="table table-striped table-bordered well" style="margin-bottom: 0px; display: none; width: 100%; overflow: hidden;">
                            <thead>
                                <tr class="thead">
                                    <td class="AutoId" style="white-space: nowrap; text-align: center; display: none;">AutoId</td>
                                    <td class="GiftCardCode" style="white-space: nowrap; text-align: center">Gift Card<br />
                                        Code</td>
                                    <td class="TotalAmt" style="white-space: nowrap; text-align: center">Total
                                        <br />
                                        Amount (<span class="symbol"></span>)</td>
                                    <td class="LeftAmt" style="white-space: nowrap; text-align: center">Left
                                        <br />
                                        Amount (<span class="symbol"></span>)</td>
                                    <td class="GiftCardPurchaseInvoice" style="white-space: nowrap; text-align: center">Purchase<br />
                                        Invoice No.</td>
                                    <td class="SoldDate" style="white-space: nowrap; text-align: center">Sold<br />
                                        Date</td>
                                    <td class="Customer" style="white-space: nowrap; text-align: center">Customer</td>
                                    <td class="Mobile" style="white-space: nowrap; text-align: center">Mobile No.</td>
                                    <td class="Email" style="white-space: nowrap; text-align: center">Email Id</td>
                                    <td class="Status" style="white-space: nowrap; text-align: center">Status</td>
                                    <td class="CompanyName" style="white-space: nowrap; display: none; text-align: center">Store Name</td>
                                    <td class="TerminalName" style="white-space: nowrap; text-align: center">Terminal<br />
                                        Name</td>
                                    <td class="SoldBy" style="white-space: nowrap; text-align: center">Sold By</td>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>

                        </table>
                        <h5 class="well text-center" id="GiftEmptyTable" style="display: none;">No data available.</h5>
                    </div>
                    <div class="form-group row" style="padding-bottom: 0px; margin-bottom: 0px; margin-top: 10px;">
                        <div class="col-md-2">
                            <select class="form-control border-primary input-sm" id="ddlPageSizeGift" style="display: none" onchange="BindGiftCardSearch(1)">
                                <option value="10">10</option>
                                <option value="50">50</option>
                                <option value="100">100</option>
                                <option value="500">500</option>
                                <option value="1000">1000</option>
                                <option value="0">All</option>
                            </select>
                        </div>
                        <div class="col-md-7" >
                            <div style="display:none" class="Pager SaleInvoiceList SaleInvoiceListPager" id="BindGiftListPager"></div>
                        </div>
                        <div class="col-md-3 text-right">
                            <span id="GiftListSortBy" style="color: red; font-size: small;"></span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="SafeCashList" role="dialog" data-backdrop="static" data-keyboard="false" style="overflow-y: scroll; overflow-x: hidden;">
        <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
            <div class="modal-content card-p">
                <div class="modal-header cardm-head">
                    <h5 class="modal-title">Safe Cash List
                 <img src="../Images/del.png" class="del-btnp" onclick="CloseSafeCashList()" />
                    </h5>
                </div>
                <div class="modal-body" style="padding: 0px; margin-top: 15px">
                    <div class="row" style="margin-bottom: 10px;">
                        <div class="col-md-3">
                            <label>Amount </label>
                            <div class="input-group">
                                <span class="input-group-addon input-sm symbol"></span>
                                <input type="text" id="txtAmount1" maxlength="12" style="text-align: right" class="form-control input-sm" placeholder="0.00" value="0.00" oncopy="return false" onpaste="return false" oncut="return false" onkeypress="return isNumberDecimalKey(event, this)" />
                                <input type="hidden" id="hdnPayoutAmt" />
                            </div>
                        </div>
                        <div class="col-md-3">
                            <label>Mode </label>
                            <select id="ddlMode2" class="form-control input-sm" style="font-size: 17px">
                                <option value="0">All </option>
                                <option value="1">Deposit</option>
                                <option value="2">Withdraw</option>
                            </select>
                        </div>

                        <div class="col-md-3">
                            <label>From Date </label>
                            <input type="text" id="txtStartDate" class="form-control input-sm date" placeholder="From Date" />
                        </div>
                        <div class="col-md-3">
                            <label>To Date </label>
                            <input type="text" id="txtEndDate" class="form-control input-sm date" placeholder="To Date" />
                        </div>

                    </div>
                    <div class="row">
                        <label class="col-md-3 form-group">Total Safe Cash Amount</label>
                        <div class="col-md-2">
                            <label style="margin-left: 0px"><span id="Total">0.00</span></label>
                        </div>
                        <div class="col-md-7 text-right">
                            <button id="btnSearchSafe" style="margin-top: -5px" type="button" onclick="BindSafeCashList(1);" class="btn btn-sm catsearch-btn pull-right">Search</button>
                        </div>
                    </div>
                    <div class="table-responsive" style="padding-top: 5px;">
                        <table id="tblSafeList" class="table table-striped table-bordered well" style="margin-bottom: 0px;">
                            <thead>
                                <tr class="thead">
                                    <td class="Action" style="width: 50px;">Action</td>
                                    <td class="SafeCashAutoId" style="display: none;">SafeCashAutoId</td>
                                    <td class="Mode" style="white-space: nowrap; text-align: center;">Mode</td>
                                    <td class="Amount" style="white-space: nowrap; text-align: right;">Amount(<span class="symbol"></span>)</td>
                                    <td class="Remark" style="text-align: center;">Remark</td>
                                    <td class="CreatedDate" style="white-space: nowrap; text-align: center;">Date & Time</td>
                                    <td class="CreatedBy" style="white-space: nowrap; text-align: center;">Created By</td>
                                    <td class="Terminal" style="white-space: nowrap; text-align: center;">Terminal</td>
                                    <td class="Status" style="white-space: nowrap; text-align: center;">Status</td>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                            <tfoot>
                                <tr>
                                    <td colspan="2" style="white-space: nowrap; text-align: right; font-weight: 600">Total</td>
                                    <td style="white-space: nowrap; text-align: right; font-weight: 600"><span id="spn_TotalSafe"><span class="symbol"></span>0.00</span></td>
                                </tr>
                            </tfoot>
                        </table>
                        <h5 class="well text-center" id="SafeEmptyTable" style="display: none">No data available.</h5>
                    </div>
                    <div class="form-group row" style="padding-bottom: 0px; margin-bottom: 0px; margin-top: 10px;">
                        <div class="col-md-2">
                            <select class="form-control border-primary input-sm" id="ddlPageSizePS" onchange="BindSafeCashList(1)">
                                <option value="10">10</option>
                                <option value="50">50</option>
                                <option value="100">100</option>
                                <option value="500">500</option>
                                <option value="1000">1000</option>
                                <option value="0">All</option>
                            </select>
                        </div>
                        <div class="col-md-10">
                            <div class="Pager SaleInvoiceList SaleInvoiceListPager" id="BindSafeCashListPager"></div>
                        </div>
                        <%--<div class="col-md-3 text-right">
                            <span id="SafeCashListSortBy" style="color: red; font-size: small;"></span>
                        </div>--%>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="ModalDraftOrder" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-dialog-centered actionb-p" role="document">
            <div class="modal-content card-p">
                <div class="modal-header cardm-head">
                    <h5 class="modal-title">Draft Order
                        <img src="../Images/del.png" class="del-btnp" id="CloseModal" onclick="CloseDraft();" data-dismiss="modal" />
                    </h5>
                </div>
                <div class="modal-body" style="padding: 15px 0 0 0;">
                    <div class="row">
                        <div class="col-lg-12 form-group">
                            <label>Draft Name<span style="color: red;">*</span></label>
                            <input type="text" id="txtDraftName" class="input-sm form-control" maxlength="50" />
                            <input type="hidden" id="hdnDraftId" />
                            <input type="hidden" id="hdnDraftName" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <button type="button" class="cash-btn btn btn-primary" id="btnDraft" onclick="SaveDraft();">Save Draft Order</button>
                            <button type="button" class="cash-btn btn btn-primary" style="display: none" id="btnDraftUpdate" onclick="UpdateDraft();">Update Draft Order</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="ModalDraftLog" role="dialog" data-backdrop="static" data-keyboard="false" style="overflow-y: scroll; overflow-x: hidden;">
        <div class="modal-dialog modal-dialog-centered actionb-p" role="document">
            <div class="modal-content card-p">
                <div class="modal-header cardm-head">
                    <h5 class="modal-title">Draft Order List
                        <img src="../Images/del.png" class="del-btnp" id="CloseModalLog" onclick="FocusOnBarCode()" data-dismiss="modal" />
                    </h5>
                </div>
                <div class="modal-body" style="padding: 0px; margin-top: 15px">
                    <div class="row">
                        <div class="col-md-12">
                            <div class="table-responsive" style="padding-top: 5px;">
                                <table id="tblOrderLog" class="table table-striped table-bordered well" style="margin-bottom: 0px;">
                                    <thead>
                                        <tr class="thead">

                                            <td class="Action1 text-center" style="width: 10%;">Action</td>
                                            <td class="OrderId text-center" style="display: none;">Order Id.</td>
                                            <td class="OrderNo text-center">Order No.</td>
                                            <td class="CustName text-center">Customer Name</td>
                                            <td class="DraftName text-center">Draft Name </td>
                                            <td class="DraftDate text-center" style="width: 20%;"> Time & Date</td>
                                            <td class="Type text-center" style="display:none;">Type</td>
                                            <td class="User text-center" style="text-align:center;">User Name</td>
                                        </tr>
                                    </thead>
                                    <tbody id="tblOrderLogBody" style="max-height: 400px !important; scroll-behavior: auto; overflow: scroll;">
                                    </tbody>
                                </table>
                                <h5 class="well text-center" id="emptyTable1">No draft orders are available.</h5>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="ModalCalculator" role="dialog" data-backdrop="static" data-keyboard="false">
        <center>
            <div class="modal-dialog" style="width: 300px; padding: 0px;">
                <div class="modal-content">
                    <div class="modal-header cardm-head2" id="Calcu_Header">
                        <h5 class="modal-title" id="Cal_Head" style="color: #367fa9; margin-top: 2px; font-size: 24px; font-weight: 600"></h5>
                        <div class="container" id="TR_Disc">
                            <div class="switches-container">
                                <input type="radio" id="switchMonthly" onchange="RefreshCal();" name="DiscType" value="Per" checked="checked" />
                                <input type="radio" id="switchYearly" onchange="RefreshCal();" name="DiscType" value="Fixed" />
                                <label for="switchMonthly">%</label>
                                <label for="switchYearly"><span class="symbol"></span></label>
                                <div class="switch-wrapper">
                                    <div class="switch">
                                        <div style="font-weight: 700">%</div>
                                        <div style="font-weight: 700"><span class="symbol"></span></div>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>
                    <div class="modal-body" style="padding: 5px 20px 5px 20px">
                        <div class="row">
                            <table id="calcu">
                                <%--<tr id="TR_Disc">
                                    <td colspan="3">
                                        <input type="radio" checked="checked" onchange="CancelDiscount();" id="red_Dol" name="DiscType" value="Dol" style="margin-left: 20px; height: 35px; width: 35px; font-weight: 600">
                                        <label for="Dol" style="font-size: 50px; font-weight: 600; margin-left: 6px; color: #3f7fbe;">$</label>
                                        <input type="radio" id="red_Per" onchange="CancelDiscount();" name="DiscType" value="Per" style="height: 35px; width: 35px; font-weight: 600; margin-left: 73px;">
                                        <label for="Per" style="font-weight: 600; font-size: 50px; margin-left: 6px; color: #3f7fbe;">%</label>
                                    </td>
                                </tr>--%>
                                <tr>
                                    <td colspan="3">
                                        <input type="text" maxlength="9" style="height: 50px; width: 261px; border: 2px solid #3c8dbc; text-align: right; font-size: 50px; margin: 4px"
                                            class="form-control" id="result" readonly="false" /></td>
                                </tr>

                                <tr>
                                    <td>
                                        <input type="button" value="1" class="btn btn-primary" style="width: 80px; height: 80px; font-size: 60px; margin: 5px; line-height: 1"
                                            onclick="dis('1')" onkeydown="myFunction(event)" />
                                    </td>
                                    <td>
                                        <input type="button" value="2" class="btn btn-primary" style="width: 80px; height: 80px; font-size: 60px; margin: 5px; line-height: 1"
                                            onclick="dis('2')" onkeydown="myFunction(event)" />
                                    </td>
                                    <td>
                                        <input type="button" value="3" class="btn btn-primary" style="width: 80px; height: 80px; font-size: 60px; margin: 5px; line-height: 1"
                                            onclick="dis('3')" onkeydown="myFunction(event)" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <input type="button" value="4" class="btn btn-primary" style="width: 80px; height: 80px; font-size: 60px; margin: 5px; line-height: 1"
                                            onclick="dis('4')" onkeydown="myFunction(event)" />
                                    </td>
                                    <td>
                                        <input type="button" value="5" class="btn btn-primary" style="width: 80px; height: 80px; font-size: 60px; margin: 5px; line-height: 1"
                                            onclick="dis('5')" onkeydown="myFunction(event)" />
                                    </td>
                                    <td>
                                        <input type="button" value="6" class="btn btn-primary" style="width: 80px; height: 80px; font-size: 60px; margin: 5px; line-height: 1"
                                            onclick="dis('6')" onkeydown="myFunction(event)" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <input type="button" value="7" class="btn btn-primary" style="width: 80px; height: 80px; font-size: 60px; margin: 5px; line-height: 1"
                                            onclick="dis('7')" onkeydown="myFunction(event)" />
                                    </td>
                                    <td>
                                        <input type="button" value="8" class="btn btn-primary" style="width: 80px; height: 80px; font-size: 60px; margin: 5px; line-height: 1"
                                            onclick="dis('8')" onkeydown="myFunction(event)" />
                                    </td>
                                    <td>
                                        <input type="button" value="9" class="btn btn-primary" style="width: 80px; height: 80px; font-size: 60px; margin: 5px; line-height: 1"
                                            onclick="dis('9')" onkeydown="myFunction(event)" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <input type="button" value="0" class="btn btn-primary" style="width: 80px; height: 80px; font-size: 60px; margin: 5px; line-height: 1"
                                            onclick="dis('0')" onkeydown="myFunction(event)" />
                                    </td>
                                    <td>
                                        <input type="button" value="." class="btn btn-primary" style="width: 80px; height: 80px; font-size: 60px; margin: 5px; line-height: 1"
                                            onclick="dis('.')" onkeydown="myFunction(event)" />
                                    </td>
                                    <td>
                                        <input type="button" value="C" class="btn btn-primary" style="width: 80px; height: 80px; font-size: 60px; margin: 5px; line-height: 1"
                                            onclick="clr()" onkeydown="myFunction(event)" />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <input type="button" value="Submit" class="btn btn-primary" id="btnCalButton" style="width: 170px; height: 80px; font-size: 28px; margin: 5px"
                                            onclick="this.disabled = true;SubmitDsicount()" onkeydown="" />
                                    </td>
                                    <td>
                                        <input type="button" value="Close" class="btn btn-primary" style="width: 80px; height: 80px; font-size: 28px; margin: 5px; padding-left: 6px"
                                            onclick="closeCalModal()" onkeydown="" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </center>
    </div>

    <div class="modal fade" id="ClockInOutModal" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-dialog-centered modal-md" role="document">
            <div class="modal-content card-p">
                <div class="modal-header cardm-head">
                    <h5 class="modal-title h5clockIn">Clock In
                    <img src="../Images/del.png" class="del-btnp" data-dismiss="modal" onclick="CloseAddScrModal()" />
                    </h5>
                    <h5 class="modal-title h5clockOut" style="display: none">Clock Out
                        <img src="../Images/del.png" class="del-btnp" data-dismiss="modal" onclick="CloseAddScrModal()" />
                    </h5>
                </div>

                <div class="modal-body" style="padding: 15px 0 0 0;">
                    <div class="row">
                        <div class="col-md-12 form-group ClockInDate" style="display: none">
                            <label class="col-md-4 form-group">Clock In Date & Time</label>
                            <input id="txtClockInDate" class="col-md-6 form-group" disabled="disabled" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12 form-group">
                            <label class="col-md-4 form-group">Current Date & Time</label>
                            <input id="spnTimer2" class="col-md-6 form-group" disabled="disabled" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12 form-group">
                            <label class="col-md-4 form-group">Employee Name</label>
                            <input type="text" id="spnUserName2" class="col-md-6 form-group" disabled="disabled" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12 form-group">
                            <label class="col-md-4 form-group">Remark</label>
                            <textarea type="text" id="txtremarkClock" style="max-width: 284px; max-height: 118px; min-width: 284px; min-height: 70px;"
                                class="col-md-6 form-group" maxlength="250"></textarea>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-12 form-group text-right">
                        <button type="button" class="btn btn-primary" id="Clockin" onclick="ClockIn();">Clock In</button>
                        <button type="button" id="clockout" onclick="ClockOut();" style="display: none" class="btn btn-primary">Clock Out</button>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <div class="modal fade" id="AddScreenModal" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
            <div class="modal-content card-p">
                <div class="modal-header cardm-head">
                    <h5 class="modal-title">Add New Screen
                    <img src="../Images/del.png" class="del-btnp" data-dismiss="modal" onclick="CloseAddScrModal()" />
                    </h5>
                </div>

                <div class="modal-body" style="padding: 15px 0 0 0;">
                    <div class="row">
                        <div class="col-md-4 form-group">
                            <label>Screen Name <span style="color: red;">*</span></label>
                            <input type="text" id="txtScreenSName" onkeypress="return /[0-9a-zA-Z ]/i.test(event.key)" maxlength="50" class="input-sm form-control" placeholder="Enter First Name" />
                        </div>
                        <div class="col-md-4 form-group">
                            <label>Status</label>
                            <select id="ddlStatusS" class="form-control input-sm">
                                <option selected="selected" value="1">Active</option>
                                <option value="0">Inactive</option>
                            </select>
                        </div>

                    </div>
                </div>

                <div class="row">
                    <div class="col-md-12 form-group text-right">
                        <button type="button" class="btn btn-sm cataddnew-btn" id="btnAddScreen" onclick="AddScreen();">Save</button>
                        <button type="button" id="btnUpdateScreen" onclick="UpdateScreen();" class="btn btn-sm catsave-btn" style="display: none">Update</button>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <div class="modal fade" id="AddCustomerModal" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
            <div class="modal-content card-p">
                <div class="modal-header cardm-head" id="NewCustomer">
                    <h5 class="modal-title">Add New Customer
                        <img src="../Images/del.png" class="del-btnp" data-dismiss="modal" onclick="CloseAddCustModal()" />
                    </h5>
                </div>
                <div class="modal-header cardm-head GiftSection" style="display: none">
                    <h5 class="modal-title">Sale Gift Card
                        <img src="../Images/del.png" class="del-btnp" data-dismiss="modal" onclick="CloseAddCustModal()" />
                    </h5>
                </div>
                <div class="modal-body" style="padding: 15px 0 0 0;">
                    <div class="row GiftSection" style="display: none">
                        <div class="col-md-4 form-group">
                            <label>Gift Card Code <span style="color: red;">*</span></label>
                            <input type="text" id="txtGiftNo" onkeypress="return /[0-9a-zA-Z]/i.test(event.key)" maxlength="50" class="input-sm form-control" placeholder="Enter Gift Card Code" />
                        </div>
                        <div class="col-md-4 form-group">
                            <label>Gift Card Amount <span style="color: red;">*</span></label>
                            <div class="input-group">
                                <span class="input-group-addon input-sm symbol"></span>
                                <input type="text" id="txtGiftAmount" value="0.00" oncopy="return false" ondrag="return false" ondrop="return false" onpaste="return false" oncut="return false" onkeypress="return isNumberDecimalKey(event, this)" style="text-align: right" maxlength="6" class="input-sm form-control" placeholder="0.00" />
                            </div>
                        </div>
                    </div>
                    <%--<div class="row GiftSection" style="display: none">
                        <hr />
                    </div>--%>
                    <div class="row">
                        <div class="col-md-4 form-group">
                            <label>First Name <span style="color: red;">*</span></label>
                            <input type="text" id="txtFirstName" maxlength="50" onkeypress="return /[0-9a-zA-Z ]/i.test(event.key)" class="input-sm form-control" placeholder="Enter First Name" />
                        </div>
                        <div class="col-md-4 form-group">
                            <label>Last Name</label>
                            <input type="text" id="txtLastName" maxlength="50" onkeypress="return /[0-9a-zA-Z ]/i.test(event.key)" class="input-sm form-control" placeholder="Enter Last Name" />
                        </div>
                        <div class="col-md-4 form-group">
                            <label>Mobile No. <span style="color: red;">*</span></label>
                            <input type="text" id="txtMobileNo" onkeypress="return /[0-9]/i.test(event.key)" oncopy="return false" oninput="process(this)" oncut="return false" onkeypress="return isNumberKey(event)" maxlength="10"
                                class="input-sm form-control" placeholder="Enter Mobile No." />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4 form-group">
                            <label>DOB</label>
                            <input type="text" id="txtDOB" readonly="readonly" class="input-sm form-control" placeholder="DOB" />
                        </div>
                        <div class="col-md-8 form-group">
                            <label>Email ID <%--<span style="color: red;">*</span>--%></label>
                            <input type="text" id="txtEmailId" maxlength="100" class="input-sm form-control" placeholder="Enter Email ID" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4 form-group">
                            <label>Address</label>
                            <textarea type="text" rows="4" style="max-height: 96px; max-width: 270px; min-height: 96px; min-width: 270px;"
                                id="txtAddress" maxlength="300" class="input-sm form-control" placeholder="Address"></textarea>
                        </div>
                        <div class="col-md-8">
                            <div class="row">
                                <div class="col-md-12 form-group">
                                    <label>City</label>
                                    <input type="text" id="txtCity" onkeypress="return /[a-zA-Z ]/i.test(event.key)" maxlength="60" placeholder="City" class="input-sm form-control" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6 form-group">
                                    <label>State</label>
                                    <select id="txtState" style="width: 100%" class="input-sm form-control">
                                        <option value="0">Select State</option>
                                    </select>
                                </div>
                                <div class="col-md-6 form-group">
                                    <label>Zip Code</label>
                                    <input type="text" id="txtZipCode" minlength="5" oncopy="return false" onpaste="return false" oncut="return false" onkeypress="return /[0-9]/i.test(event.key)" placeholder="Zip Code" onkeypress="return isNumberKey(event)" class="input-sm form-control" maxlength="5" />
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-12 form-group text-right">
                            <button type="button" class="btn btn-sm cataddnew-btn" id="btnAddCustomer" onclick="AddCustomer();">Save</button>
                            <button type="button" class="btn btn-sm cataddnew-btn GiftSection" style="display: none" id="btnAddGiftCard" onclick="AddGiftCard();">Save</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <style>
        .cataddnew-btn {
            background: #008f41;
            border: 1px solid #008f41;
            color: #fff;
            font-weight: 600;
            padding: 5px 20px;
        }

            .cataddnew-btn:hover {
                background: #fff;
                border: 1px solid #008f41;
                color: #008f41;
            }
    </style>

    <div class="modal fade" id="SearchScreenModal" role="dialog" data-backdrop="static" data-keyboard="false" style="overflow-y: scroll; overflow-x: hidden;">
        <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
            <div class="modal-content card-p">
                <div class="modal-header cardm-head">
                    <h5 class="modal-title">Screen List
                    <img src="../Images/del.png" class="del-btnp" data-dismiss="modal" onclick="CloseCustomerSearchModal()" />
                    </h5>
                </div>
                <div class="modal-body" style="padding: 0px; margin-top: 15px">
                    <div class="row">
                        <div class="col-md-3">
                            <input type="text" id="txtScreenName" maxlength="60" class="input-sm form-control" placeholder="Screen Name" />
                        </div>
                        <div class="col-md-3">
                            <select id="ddlStatus" class="form-control input-sm">
                                <option value="1">Active</option>
                                <option value="0">Inactive</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <div class="row">
                                <div class="col-md-3">
                                    <button type="button" onclick="BindScreenList(1);" class="btn btn-sm catsearch-btn">Search</button>
                                </div>
                                <div class="col-md-4">
                                    <button type="button" id="btnAddNewScreen" onclick="OpenAddScreenModal()" class="btn btn-sm cataddnew-btn">Add New Screen</button>
                                </div>
                                <div class="col-md-5"></div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="table-responsive">
                                <table id="tblScreenList" class="table table-striped table-bordered well" style="margin-bottom: 5px; margin-top: 5px; display: none;">
                                    <thead>
                                        <tr class="thead">
                                            <td class="ScreenAutoId text-center" style="display: none;">ScreenAutoId</td>
                                            <td class="ScreenAction text-center" style="width: 4%;">Action</td>
                                            <td class="ScreenN text-center">Screen Name</td>
                                            <td class="SStatus text-center">Status</td>
                                        </tr>
                                    </thead>
                                    <tbody id="tblSearchListScreen" style="max-height: 400px !important; scroll-behavior: auto; overflow: scroll;">
                                    </tbody>
                                </table>
                                <h5 class="well text-center" id="SearchScreenEmptyTable" style="display: none;">No Screen Found!</h5>
                            </div>
                            <div class="form-group row" style="padding-bottom: 0px; margin-bottom: 0px; margin-top: 10px;"
                                id="DivPagerS">
                                <div class="col-md-2">
                                    <select class="form-control border-primary input-sm" id="ddlPageSizeS" onchange="BindScreenList(1)">
                                        <option value="10">10</option>
                                        <option value="50">50</option>
                                        <option value="100">100</option>
                                        <option value="500">500</option>
                                        <option value="1000">1000</option>
                                        <option value="0">All</option>
                                    </select>
                                </div>
                                <div class="col-md-7">
                                    <div class="Pager" id="SearchScreenPager"></div>
                                </div>
                                <div class="col-md-3 text-right">
                                    <span id="spSearchScreenSortBy" style="color: red; font-size: small;"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="SearchNoSaleModal" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-dialog-centered modal-md" role="document">
            <div class="modal-content card-p">
                <div class="modal-header cardm-head">
                    <h5 class="modal-title">No Sale
                <img src="../Images/del.png" class="del-btnp" data-dismiss="modal" onclick="CloseNoSaleModal()" />
                    </h5>
                </div>
                <div class="modal-body" style="padding: 0px; margin-top: 15px">
                    <div class="row form-group">
                        <div class="col-md-2">
                            <label>Remark<span class="required">*</span></label>
                        </div>
                        <div class="col-md-10">
                            <textarea type="text" style="min-width: 468px; min-height: 90px; max-width: 468px; max-height: 180px;"
                                id="txtNoSaleRemarkName" maxlength="300" class="input-sm form-control" placeholder="Remark "></textarea>
                        </div>
                    </div>
                    <div class="row form-group">
                        <div class="col-md-12">
                            <button type="button" style="float: right" onclick="this.disabled = true;NoSale(this);" class="btn btn-sm catsearch-btn DbPrevent">Save</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="SearchCustomerModal" role="dialog" data-backdrop="static" data-keyboard="false" style="overflow-y: scroll; overflow-x: hidden;">
        <div class="modal-dialog modal-dialog-centered modal-lg" role="document" style="width: 1020px">
            <div class="modal-content card-p">
                <div class="modal-header cardm-head">
                    <h5 class="modal-title">Search Customer
                        <img src="../Images/del.png" class="del-btnp" data-dismiss="modal" onclick="CloseCustomerSearchModal()" />
                    </h5>
                </div>
                <div class="modal-body" style="padding: 0px; margin-top: 15px">
                    <div class="row">
                        <div class="col-md-2">
                            <input type="text" id="txtCustId" onkeypress="return /[0-9a-zA-Z]/i.test(event.key)" maxlength="30" class="input-sm form-control" placeholder="Customer ID" />
                        </div>
                        <div class="col-md-2">
                            <input type="text" id="txtSName" maxlength="60" class="input-sm form-control" placeholder="Name" />
                        </div>
                        <div class="col-md-2">
                            <input type="text" id="txtSMobileNo" onkeypress="return isNumberKey(event)" maxlength="10" class="input-sm form-control" placeholder="Mobile No" />
                        </div>
                        <div class="col-md-3">
                            <input type="text" id="txtSEmailId" maxlength="100" class="input-sm form-control" placeholder="Email ID" />
                        </div>
                        <div class="col-md-3">
                            <div class="row">
                                <div class="col-md-4">
                                    <button type="button" onclick="SearchCustomer(1);" class="btn btn-sm catsearch-btn">Search</button>
                                </div>
                                <div class="col-md-8">
                                    <button type="button" id="btnAddNewCustomer" onclick="OpenAddCustomerModal()" class="btn btn-sm cataddnew-btn">Add New Customer</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="table-responsive">
                                <table id="tblCustomerList" class="table table-striped table-bordered well" style="margin-bottom: 5px; margin-top: 5px; display: none;">
                                    <thead>
                                        <tr class="thead">
                                            <td class="CustomerAction text-center" style="width: 4%;">Action</td>
                                            <td class="CustomerId text-center" style="display: none;">CustomerId</td>
                                            <td class="DOBC text-center" style="display: none;">DOB</td>
                                            <td class="CustomerIdG text-center">Customer ID</td>
                                            <td class="CustomerName text-center">Customer Name </td>
                                            <td class="MobileNo text-center" style="white-space: nowrap;">Mobile No</td>
                                            <td class="EmailId text-center" style="">Email ID</td>
                                            <td class="TotalPurchase text-center" style="">Purchase Amount(<span class="symbol"></span>)</td>
                                            <td class="RoyaltyPoints text-center" style="">Reward Points</td>
                                        </tr>
                                    </thead>
                                    <tbody id="tblSearchListBody" style="max-height: 400px !important; scroll-behavior: auto; overflow: scroll;">
                                    </tbody>
                                </table>
                                <h5 class="well text-center" id="SearchListemptyTable" style="display: none;">No Customer Found!</h5>
                            </div>
                            <div class="form-group row" style="padding-bottom: 0px; margin-bottom: 0px; margin-top: 10px;"
                                id="DivPager1">
                                <div class="col-md-2">
                                    <select class="form-control border-primary input-sm" id="ddlPageSize1" onchange="SearchCustomer(1)">
                                        <option value="10">10</option>
                                        <option value="50">50</option>
                                        <option value="100">100</option>
                                        <option value="500">500</option>
                                        <option value="1000">1000</option>
                                        <option value="0">All</option>
                                    </select>
                                </div>
                                <div class="col-md-7">
                                    <div class="Pager" id="SearchCustomerPager"></div>
                                </div>
                                <div class="col-md-3 text-right">
                                    <span id="spSearchCustomerSortBy" style="color: red; font-size: small;"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="ProductVarientModal" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-dialog-centered modal-lg" style="float: right; right: 39px;"
            role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title"><strong><span id="productName" style="font-size: 21px"></span></strong>
                        <img src="../Images/del.png" class="del-btnp" data-dismiss="modal" onclick="FocusOnBarCode()" aria-label="Close" />

                    </h4>
                </div>
                <div class="modal-body">
                    <div class="row" id="DivProductVarient">
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="ModalAddToHome" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
            <div class="modal-content card-p">
                <div class="modal-header cardm-head">
                    <h5 class="modal-title">Add To Screen
                        <img src="../Images/del.png" class="del-btnp" onclick="CloseAddToHome()" />
                    </h5>
                </div>
                <div class="modal-body" style="padding: 15px 0 0;">
                    <div class="row">
                        <div class="col-md-4">
                            <select class="form-control border-primary input-md" id="ddlScreen" onchange="AddToHomeProduct(1)">
                                <option value="0">Select Screen</option>
                            </select>
                            <hr style="margin-top: 10px; margin-bottom: 10px;" />
                        </div>
                        <div class="col-md-4">
                            <input type="text" class="form-control input-sm" id="txtAddToHomeProduct" maxlength="100" placeholder="Enter Product Name" onkeyup="AddToHomeProduct(1)" />

                        </div>

                        <div class="col-md-4">
                            <select class="form-control border-primary input-md" id="ddlDepartment" onchange="AddToHomeProduct(1)">
                                <option value="0">Select Department</option>
                            </select>
                            <hr style="margin-top: 10px; margin-bottom: 10px;" />
                        </div>
                    </div>
                    <div id="divAddToHomeProductList" class="AddToHomeFixHead style-3" style="display: none">
                        <div class="col-md-12 force-overflow">
                        </div>
                    </div>
                    <div class="row" id="AddToHomeEmptyTable" style="display: none">
                        <div class="col-md-12">
                            <h5 class="well text-center">No data available.</h5>
                        </div>
                    </div>
                    <div class="row" id="DivPager">
                        <div class="col-md-2">
                            <select class="form-control border-primary input-sm" id="ddlAddToHomePageSize" onchange="AddToHomeProduct(1)">
                                <option value="10">10</option>
                                <option value="50">50</option>
                                <option value="100">100</option>
                                <option value="500">500</option>
                                <option value="1000">1000</option>
                                <option value="0">All</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <div class="Pager" id="AddToHomePager"></div>
                        </div>
                        <div class="col-md-4">
                            <span id="spAddToHomeSortBy" style="color: red; font-size: small;"></span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="ModalCash" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-dialog-centered actionb-p" role="document">
            <div class="modal-content card-p">
                <div class="modal-header cardm-head">
                    <h5 class="modal-title">Transaction
                        <%--<img src="../Images/del.png" class="del-btnp" onclick="CloseModalCash()" />--%>
                    </h5>
                </div>
                <div class="modal-body" style="padding: 15px 0 0 0;">
                    <div class="row form-group">
                        <div class="col-md-3">
                            <label>Order Amount </label>
                            <div class="input-group">
                                <span class="input-group-addon input-sm symbol"></span>
                                <input type="text" class="form-control input-sm border-primary" style="text-align: right; font-size: 18px; font-weight: 700;"
                                    onfocus="this.select()" id="PayGOrdertotal" readonly="readonly" value="0.00" onkeypress="return isNumberDecimalKey(event,this)" />
                            </div>
                        </div>
                        <div class="col-md-3">
                            <label>Due Amount </label>
                            <div class="input-group">
                                <span class="input-group-addon input-sm symbol"></span>
                                <input type="text" class="form-control input-sm border-primary" style="text-align: right; font-size: 18px; font-weight: 700;"
                                    onfocus="this.select()" id="PayGtotal" readonly="readonly" value="0.00" onkeypress="return isNumberDecimalKey(event,this)" />
                            </div>
                        </div>
                        <div class="col-md-3">
                            <label>Paid Amount </label>
                            <div class="input-group">
                                <span class="input-group-addon input-sm symbol"></span>
                                <input type="text" class="form-control input-sm border-primary" style="text-align: right; font-size: 18px; font-weight: 700;"
                                    onfocus="this.select()" id="PaidAmt" readonly="readonly" value="0.00" onkeypress="return isNumberDecimalKey(event,this)" maxlength="9" />
                            </div>
                        </div>
                        <div class="col-md-3">
                            <label>Return Amount </label>
                            <div class="input-group">
                                <span class="input-group-addon input-sm symbol"></span>
                                <input type="text" class="form-control input-sm border-primary" style="text-align: right; font-size: 20px; font-weight: 900;"
                                    onfocus="this.select()" id="LeftAmt" readonly="readonly" value="0.00" onkeypress="return isNumberDecimalKey(event,this)" />
                            </div>
                        </div>
                    </div>
                    <div class="row form-group" style="margin-top: 25px; margin-bottom: 25px">
                        <div class="col-md-2">
                            <button type="button" onclick="Cal_Cash(1)" class="savedraft-btn btn btn-primary LotteryB"><span class="symbol"></span>1</button>
                        </div>
                        <div class="col-md-2">
                            <button type="button" onclick="Cal_Cash(5)" class="draft-btn btn btn-primary LotteryB" value=""><span class="symbol"></span>5</button>
                        </div>
                        <div class="col-md-2">
                            <button type="button" onclick="Cal_Cash(10)" class="disc-btn btn btn-primary LotteryB"><span class="symbol"></span>10</button>
                        </div>
                        <div class="col-md-2">
                            <button type="button" onclick="Cal_Cash(20)" class="addhome-btn btn btn-primary LotteryB"><span class="symbol"></span>20</button>
                        </div>
                        <div class="col-md-2">
                            <button type="button" onclick="Cal_Cash(50)" class="card-btn btn btn-primary LotteryB"><span class="symbol"></span>50</button>
                        </div>
                        <div class="col-md-2">
                            <button type="button" onclick="Cal_Cash(100)" class="nosale-btn btn btn-primary LotteryB"><span class="symbol"></span>100</button>
                        </div>
                    </div>
                    <div class="row form-group" style="margin-bottom: 14px">
                        <div class="col-md-6">
                            <button type="button" onclick="openCal('CustomPay')" class="addhome-btn btn btn-primary LotteryB">Custom Pay</button>
                        </div>
                        <div class="col-md-6">
                            <button type="button" onclick="Cal_Cash(this)" id="btnExactCash" class="card-btn btn btn-primary">Exact</button>
                        </div>
                        <%-- <div class="col-md-4">
                              <button type="button" id="btnCreditCard" onclick="CreditcardPay1()" class="nosale-btn btn btn-primary">Credit Card</button>
                        </div>--%>
                    </div>
                    <div class="row form-group">
                        <div class="col-md-4">
                            <button type="button" onclick="OpenCouponModal()" id="btnApplyCoupon" class="draft-btn btn btn-primary LotteryB">Coupon</button>
                        </div>
                        <div class="col-md-4">
                            <button type="button" onclick="OpenGiftCard1()" id="btnApplyGift" class="savedraft-btn btn btn-primary LotteryB">Gift Card</button>
                        </div>
                        <div class="col-md-4">
                            <button type="button" onclick="ValidateRedeemHappyPoints();" class="disc-btn btn btn-primary LotteryB" id="btnRewardReedem">Reward Points</button>
                        </div>
                    </div>
                    <div class="row form-group">
                        <div class="col-md-2">
                        </div>
                        <div class="col-md-8">
                            <table style="width: 100%; align-items: center; font-size: 24px; margin-top: 20px;"
                                id="tblTransaction">
                                <%--<tr style="text-align: center;">
                                    <td colspan="2">Credit Card</td>
                                    <td colspan="1">20.00</td>
                                    <td colspan="1"><a>Remove</a></td>
                                </tr>
                                <tr style="text-align: center;">
                                    <td colspan="2">Gift Card</td>
                                    <td colspan="1">20.00</td>
                                    <td colspan="1"><a>Remove</a></td>
                                </tr>
                                <tr style="text-align: center;">
                                    <td colspan="2">Coupon</td>
                                    <td colspan="1">20.00</td>
                                    <td colspan="1"><a>Remove</a></td>
                                </tr>--%>
                            </table>
                        </div>
                        <div class="col-md-2">
                        </div>
                    </div>
                </div>
                <style>
                    .TransactionProceed-btn {
                        width: 100%;
                        height: 40px;
                        font-size: 22px;
                        padding: 0px 0px;
                        vertical-align: middle;
                        background: #4cbb9f;
                        border: 1px solid #4cbb9f;
                        font-weight: 600;
                        box-shadow: -1px 1px 5px rgb(133 133 133 / 34%);
                        color: #fff;
                    }

                        .TransactionProceed-btn:hover {
                            width: 100%;
                            height: 40px;
                            font-size: 22px;
                            vertical-align: middle;
                            background: #fff;
                            padding: 0px 0px;
                            border: 1px solid #4cbb9f;
                            font-weight: 600;
                            box-shadow: -1px 1px 5px rgb(133 133 133 / 34%);
                            color: #4cbb9f;
                        }

                    .Transaction-btn {
                        width: 100%;
                        height: 40px;
                        /*padding:0px 0px;*/
                        font-size: 22px;
                        vertical-align: middle;
                        background: #ff0000;
                        border: 1px solid #ff0000;
                        font-weight: 600;
                        box-shadow: -1px 1px 5px rgb(133 133 133 / 34%);
                        color: #fff;
                    }

                        .Transaction-btn:hover {
                            width: 100%;
                            height: 40px;
                            /* padding:0px 0px;*/
                            font-size: 22px;
                            vertical-align: middle;
                            background: #fff;
                            border: 1px solid #ff0000;
                            font-weight: 600;
                            box-shadow: -1px 1px 5px rgb(133 133 133 / 34%);
                            color: #ff0000;
                        }
                </style>
                <div class="modal-footer text-center" style="text-align: center">
                    <div class="row">
                        <div class="col-lg-4">
                            <button type="button" class="Transaction-btn" id="btnTransactionPopupBack" onclick="CloseModalCash()"><i class="fa fa-arrow-circle-left" title="Back" style="font-size: 30px; vertical-align: middle;"></i>&nbsp;&nbsp;Go Back</button>
                        </div>
                        <div class="col-lg-4">
                            <button type="button" id="btnCreditCard" style="font-size: 22px !important; font-weight: 600;" onclick="CreditcardPay1()" class="nosale-btn btn btn-primary">Credit Card</button>
                        </div>
                        <div class="col-lg-4">
                            <button type="button" class=" btn TransactionProceed-btn" id="btnTransactionProceed" disabled="disabled" onclick="ProceedOpeningBalanceModal()">Proceed&nbsp;&nbsp;<i class="fa fa-arrow-circle-right" title="Back" style="font-size: 30px; vertical-align: middle;"></i></button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="ModalWithdraw" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-dialog-centered actionb-p" style="width: 400px !important" role="document">
            <div class="modal-content card-p">
                <div class="modal-header cardm-head">
                    <h5 class="modal-title">Withdraw Security PIN
                        <img src="../Images/del.png" class="del-btnp" onclick="CloseModalWithdraw()" />
                    </h5>
                </div>
                <div class="modal-body" style="padding: 15px 0 0 0;">
                    <div class="row">
                        <label class="col-md-4 form-group">
                            Security PIN
                        </label>
                        <div class="col-md-8 form-group">
                            <div class="input-group">
                                <input type="password" id="txtpasswordW" maxlength="15" autocomplete="new-password" class="form-control input-sm" placeholder="Enter Security PIN" />
                                <span class="input-group-addon input-sm" id="chkViewPasswordWith" style="background-color: azure;" onclick="ViewPasswordWith();">
                                    <img src="/Images/icons8-password.gif" height="18" /></span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer text-center">
                    <button type="button" onclick="WithdrawSec()" class="draft-btn btn btn-primary">Confirm</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="ModalDiscount" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-dialog-centered actionb-p" style="width: 400px !important" role="document">
            <div class="modal-content card-p">
                <div class="modal-header cardm-head">
                    <h5 class="modal-title">Discount Security PIN
                        <img src="../Images/del.png" class="del-btnp" onclick="CloseModalDiscount()" />
                    </h5>
                </div>
                <div class="modal-body" style="padding: 15px 0 0 0;">
                    <div class="row">
                        <label class="col-md-4 form-group">
                            Security PIN
                        </label>
                        <div class="col-md-8 form-group">
                            <div class="input-group">
                                <input type="password" id="txtpasswordD" autocomplete="new-password" class="form-control input-sm" placeholder="Enter Security PIN" />
                                <span class="input-group-addon input-sm" id="chkViewPasswordDisc" style="background-color: azure;" onclick="ViewPasswordDisc();">
                                    <img src="/Images/icons8-password.gif" height="18" /></span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer text-center">
                    <button type="button" onclick="GiveDiscount()" class="draft-btn btn btn-primary">Confirm</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="ModalAdmin" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-dialog-centered actionb-p" style="width: 400px !important" role="document">
            <div class="modal-content card-p">
                <div class="modal-header cardm-head">
                    <h5 class="modal-title">Admin Security PIN
                        <img src="../Images/del.png" class="del-btnp" onclick="CloseAdminModal()" />
                    </h5>
                </div>
                <div class="modal-body" style="padding: 15px 0 0 0;">
                    <div class="row">
                        <label class="col-md-4 form-group">
                            Security PIN
                        </label>
                        <div class="col-md-8 form-group">
                            <div class="input-group">
                                <input type="password" id="txtpassword" autocomplete="new-password" class="form-control input-sm" placeholder="Enter Security PIN" />
                                <span class="input-group-addon input-sm" id="chkViewPassword" style="background-color: azure;" onclick="ViewPassword();">
                                    <img src="/Images/icons8-password.gif" height="18" /></span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer text-center">
                    <button type="button" onclick="LoginAsAdmin()" class="draft-btn btn btn-primary">Login as Admin</button>
                </div>
            </div>
        </div>
    </div>
    <input type="hidden" id="hdnPayoutId" />
    <div class="modal fade" id="ModalPayoutList" role="dialog" data-backdrop="static" data-keyboard="false" style="overflow-y: scroll; overflow-x: hidden;">
        <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
            <div class="modal-content card-p">
                <div class="modal-header cardm-head">
                    <h5 class="modal-title">Payout List
                    <img src="../Images/del.png" class="del-btnp" onclick="CloseModalPayoutList()" />
                    </h5>
                </div>
                <div class="modal-body" style="padding: 0px; margin-top: 15px">
                    <div class="row" style="margin-bottom: 10px;">
                        <div class="col-md-1" style="display: none">
                            <select id="ddlSCompanyName" style="padding-top: 2px;" class="form-control input-sm">
                                <option value="0">All Company</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <select id="ddlPayoutType1" onchange="BindDDLExpenseVendor1();" class="form-control input-sm" style="padding-top: 2px;">
                                <option value="0">Select</option>
                            </select>
                        </div>

                        <div class="col-md-3 Expense1" style="display: none">
                            <select id="ddlExpense1" class="form-control input-sm" style="padding-top: 2px;">
                                <option value="0">Select Expense</option>
                            </select>
                        </div>

                        <div class="col-md-3 Vendor1" style="display: none">
                            <select id="ddlVendor1" class="form-control input-sm" style="padding-top: 2px;">
                                <option value="0">Select Vendor</option>
                            </select>
                        </div>
                        <div class="col-md-1" style="display: none">
                            <input type="text" id="txtSFromDate" class="form-control input-sm date" placeholder="From Date" readonly="readonly" />
                        </div>
                        <div class="col-md-1" style="display: none">
                            <input type="text" id="txtSToDate" class="form-control input-sm date" placeholder="To Date" readonly="readonly" />
                        </div>
                        <div class="col-md-3">
                            <input type="text" id="txtSPayTo" maxlength="80" class="form-control input-sm" placeholder="Pay To" />
                        </div>
                        <div class="col-md-3">
                            <div class="input-group">
                                <span class="input-group-addon input-sm symbol"></span>
                                <input type="text" id="txtSAmount" maxlength="9" onpaste="return false;" ondrop="return false;" class="form-control input-sm" placeholder="0.00" onkeypress="return isNumberDecimalKey(event,this)" style="text-align: right;" />
                            </div>
                        </div>
                        <div class="col-md-3">
                            <button id="btnPaySearch" type="button" onclick="BindPayoutList(1);" class="btn btn-sm catsearch-btn pull-right">Search</button>
                        </div>
                    </div>
                    <%--<div class="row">
                        <div class="col-md-12">
                            <button id="btnPaySearch" type="button" onclick="BindPayoutList(1);" class="btn btn-sm catsearch-btn pull-right">Search</button>
                        </div>
                    </div>--%>
                    <div class="table-responsive" style="padding-top: 5px;">
                        <table id="tblPayoutList" class="table table-striped table-bordered well" style="margin-bottom: 0px;">
                            <thead>
                                <tr class="thead">
                                    <td class="Action" style="width: 50px;">Action</td>
                                    <td class="PayoutAutoId" style="display: none;">PayoutAutoId</td>
                                    <td class="CompanyName" style="white-space: nowrap; text-align: center; display: none">Company Name</td>
                                    <td class="PayTo" style="white-space: nowrap; text-align: center;">Pay To</td>
                                    <td class="PaymentMode" style="width: 150px; text-align: center;">Payment Mode</td>
                                    <td class="Amount" style="width: 100px; text-align: right;">Amount(<span class="symbol"></span>)</td>
                                    <td class="PayoutType" style="width: 100px; text-align: center;">Payout Type</td>
                                    <td class="Expenses" style="width: 100px; text-align: center;">Expense</td>
                                    <td class="Vendors" style="width: 100px; text-align: center;">Vendor</td>
                                    <td class="Remark" style="width: 150px; text-align: center;">Remark</td>
                                    <td class="createdby" style="width: 150px; text-align: center;">Paid by</td>
                                    <td class="Createddate" style="width: 150px; text-align: center;">Paid Date
                                        <br />
                                        & Time</td>
                                    <%-- <td class="PayTime" style="width: 150px; text-align: center;">Paid Time</td>--%>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                            <tfoot>
                                <tr>
                                    <td colspan="2"></td>
                                    <td style="text-align: right"><b>Total</b></td>
                                    <td style="text-align: right"><b><span class="symbol"></span></b>
                                        <label id="lblTotal"></label>
                                    </td>
                                    <td></td>
                                </tr>
                            </tfoot>
                        </table>
                        <h5 class="well text-center" id="PayoutEmptyTable" style="display: none">No data available.</h5>
                    </div>
                    <div class="form-group row" style="padding-bottom: 0px; margin-bottom: 0px; margin-top: 10px;">
                        <div class="col-md-2">
                            <select class="form-control border-primary input-sm" id="ddlPageSizeP" onchange="BindPayoutList(1)">
                                <option value="10">10</option>
                                <option value="50">50</option>
                                <option value="100">100</option>
                                <option value="500">500</option>
                                <option value="1000">1000</option>
                                <option value="0">All</option>
                            </select>
                        </div>
                        <div class="col-md-7">
                            <div class="Pager SaleInvoiceList SaleInvoiceListPager" id="SalePayoutListPager"></div>
                        </div>
                        <div class="col-md-3 text-right">
                            <span id="spPayoutSortBy" style="color: red; font-size: small;"></span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="ModalInvoiceList" role="dialog" data-backdrop="static" data-keyboard="false" style="overflow-y: scroll; overflow-x: hidden;">
        <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
            <div class="modal-content card-p">
                <div class="modal-header cardm-head">
                    <h5 class="modal-title">Invoice List
                        <img src="../Images/del.png" class="del-btnp" onclick="CloseModalInvoiceList()" />
                    </h5>
                </div>
                <div class="modal-body" style="padding: 0px; margin-top: 15px;">
                    <div class="row">
                        <div class="col-md-2 form-group">
                            <label>Invoice Number</label>
                            <input type="text" id="txtInvoiceNumber" onkeypress="return/[0-9 ]/i.test(event.key)" maxlength="30" class="form-control input-sm" placeholder="Invoice No." />
                        </div>
                        <div class="col-md-2 form-group" style="width: 180px">
                            <label>Customer Name</label>
                            <input type="text" id="txtCustName" onkeypress="return /[a-zA-Z ]/i.test(event.key)" maxlength="50" class="form-control input-sm" placeholder="Customer Name" />
                        </div>
                        <div class="col-md-2 form-group">
                            <label>From Date</label>
                            <input type="text" id="txtInvoFromDate" class="form-control input-sm date" readonly="readonly" placeholder="select Date" />
                        </div>
                        <div class="col-md-2 form-group">
                            <label>To Date</label>
                            <input type="text" id="txtInvoToDate" class="form-control input-sm date" readonly="readonly" placeholder="select Date" />
                        </div>
                        <div class="col-md-1 form-group" style="width: 160px">
                            <label>Created From</label>
                            <select id="ddlCreatedFrom" class="form-control input-sm" style="width: 130px">
                                <option value="0">All</option>
                                <option value="Web">Web</option>
                                <option value="App">App</option>
                            </select>
                        </div>
                        <div class="col-md-2 form-group" style="text-align: right; padding-top: 27px; width: 80px">
                            <button type="button" id="btnSearchInvoice" onclick="BindSaleInvoiceList(1);" class="btn btn-sm catsearch-btn">Search</button>
                        </div>
                    </div>
                    <div class="table-responsive" style="padding-top: 5px;">
                        <table id="tblInvoiceList" class="table table-striped table-bordered well" style="margin-bottom: 0px;">
                            <thead>
                                <tr class="thead">
                                    <td class="Action" style="width: 50px; text-align: center;">Action</td>
                                    <td class="InvoiceAutoId" style="white-space: nowrap; text-align: center; display: none;">InvoiceAutoId</td>
                                    <td class="InvoiceNumber" style="white-space: nowrap; text-align: center">Invoice<br />
                                        Number</td>
                                    <td class="InvoiceDate" style="white-space: nowrap; text-align: center">Invoice Date<br />
                                        & Time</td>
                                    <td class="PaymentMethod" style="white-space: nowrap; display: none; text-align: center">Payment<br />
                                        Method</td>
                                    <td class="CustomerName" style="white-space: nowrap; text-align: center">Customer<br />
                                        Name</td>
                                    <td class="Tax" style="white-space: nowrap; text-align: center; display: none">Tax(<span class="symbol"></span>)</td>
                                    <td class="Discount" style="white-space: nowrap; text-align: center; display: none">Discount(<span class="symbol"></span>)</td>
                                    <td class="Coupon" style="white-space: nowrap; text-align: center; display: none">Coupon</td>
                                    <td class="CouponAmt" style="white-space: nowrap; text-align: center; display: none">Coupon<br />
                                        Amount(<span class="symbol"></span>)</td>
                                    <td class="Total" style="white-space: nowrap; text-align: center">Total(<span class="symbol"></span>)</td>
                                    <%--<td class="SaleInvoiceItems" style="white-space: nowrap; text-align: center;">View Invoice Items</td>--%>
                                    <td class="UpdationDetails" style="white-space: nowrap; text-align: center; display: none">Creation Details</td>
                                    <td class="CreatedFrom" style="white-space: nowrap; text-align: center;">Created<br />
                                        From</td>
                                    <td class="Status" style="white-space: nowrap; text-align: center; display: none">Status</td>
                                </tr>
                            </thead>
                        </table>
                        <h5 class="well text-center" id="InvoiceEmptyTable" style="display: none">No data available.</h5>
                    </div>
                    <div class="form-group row" style="padding-bottom: 0px; margin-bottom: 0px; margin-top: 10px;">
                        <div class="col-md-2">
                            <select class="form-control border-primary input-sm" id="ddlPageSize" onchange="BindSaleInvoiceList(1)">
                                <option value="10">10</option>
                                <option value="50">50</option>
                                <option value="100">100</option>
                                <option value="500">500</option>
                                <option value="1000">1000</option>
                                <option value="0">All</option>
                            </select>
                        </div>
                        <div class="col-md-7">
                            <div class="Pager SaleInvoiceList SaleInvoiceListPager" id="SaleInvoiceListPager"></div>
                        </div>
                        <div class="col-md-3 text-right">
                            <span id="spInvoiceSortBy" style="color: red; font-size: small;"></span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="ModalOpenBalance" role="dialog" data-backdrop="static" data-keyboard="false" style="overflow-y: scroll; overflow-x: hidden;">
        <div class="modal-dialog modal-dialog-centered" role="document" style="width: 600px !important">
            <div class="modal-content card-p">
                <div class="modal-header cardm-head">
                    <div class="row" style="font-size: 20px; font-weight: 700; white-space: nowrap;">
                        <div class="col-md-6 pull-left">
                            <span class="modal-title" id="BalanceStatusHeader">Shift Closing</span>
                        </div>
                        <div class="col-md-1"></div>
                        <div class="col-md-5 pull-right">
                            <span class="modal-title" id="txtTodayDate"></span>
                        </div>
                    </div>
                </div>
                <input type="hidden" id="BalanceStatus" />
                <div class="modal-body" style="padding: 0px; margin-top: 15px">
                    <%-- <div class="row form-group">
                        <div class="col-md-5">
                            <label>Date & Time:</label>
                        </div>
                        <div class="col-md-7">
                            <input type="text" id="txtTodayDate" disabled="disabled" class="form-control input-sm" readonly="readonly" />
                        </div>
                    </div>--%>
                    <%-- <div class="row form-group">
                        <div class="col-md-5">
                            <label>Time:</label>
                        </div>
                        <div class="col-md-7">
                            <input type="text" id="txtCurrentTime" class="form-control input-sm" readonly="readonly" />
                        </div>
                    </div>--%>
                    <%--<div class="row form-group ClosingDate" style="display: none">
                        <div class="col-md-5">
                            <label>Closing Date:</label>
                        </div>
                        <div class="col-md-7">
                            <input type="text" id="txtClosingDate" class="form-control input-sm" readonly="readonly" />
                        </div>
                    </div>--%>
                    <div class="row form-group OpenBalance" style="display: none">
                        <div class="col-md-5">
                            <label id="lbl_OpenBal" style="white-space: nowrap;">Opening Balance:</label>
                        </div>
                        <div class="col-md-7">
                            <div class="input-group">
                                <span style="font-weight: 600;" class="input-group-addon input-md symbol"></span>
                                <input type="text" id="txtOpenBalance" style="text-align: right" class="form-control input-sm" disabled="disabled" />
                            </div>
                        </div>
                    </div>
                    <div class="row form-group">
                        <div class="col-md-5">
                            <label id="balanceStatusText"></label>
                        </div>
                        <div class="col-md-7">
                            <div class="input-group">
                                <span style="font-weight: 600;" class="input-group-addon input-md symbol"></span>
                                <input type="text" id="txtBalance" value="0.00" onkeypress="return isNumberDecimalKey(event,this)" style="text-align: right" class="form-control input-sm" placeholder="0.00" />
                            </div>
                        </div>
                    </div>
                    <input type="hidden" runat="server" id="txtCurrentBal" value="0.00" />
                    <input type="hidden" runat="server" id="CurrentBalStatus" value="" />
                    <input type="hidden" runat="server" id="CurrentBaltxt" value="0.00" />
                    <div class="row form-group CurrentBal" style="display: none">
                        <div class="col-md-12 text-center">
                            <label id="CurrentBalanceText">Exact</label>
                        </div>
                    </div>

                    <hr style="margin-top: 4px; margin-bottom: 10px;" />
                    <div class="row form-group">
                        <style>
                            #btnClosingBack, #btnCloseBalanceProceed {
                                height: 40px;
                                font-size: 18px;
                                width: 120px;
                                font-weight: 700;
                            }

                            #CurrentBalanceText {
                                padding: 0px;
                                margin-bottom: -10px;
                                font-size: 22px;
                            }

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

                            .btnMinus {
                                width: 110px;
                                height: 37px;
                                border: 1px solid black;
                            }

                            .btnplus {
                                width: 110px;
                                height: 37px;
                                border: 1px solid black;
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
                </div>
                <div class="modal-footer text-center" style="text-align: center">
                    <button type="button" class="btn btn-sm btn-danger" style="display: none;" id="btnOpeningBack" onclick="BackfromOpeningBalanceModal()">Back</button>
                    <button type="button" class="btn btn-sm btn-success" style="display: none;" id="btnClosingBack" onclick="BackfromClosingBalanceModal()">Back</button>
                    <button type="button" class="btn btn-sm btn-success" style="display: none;" id="btnOpeningProceed" onclick="ProceedOpeningBalanceModal()">Start Shift</button>
                    <button type="button" class="btn btn-sm btn-danger" style="display: none;" id="btnCloseBalanceProceed" onclick="ProceedClosingBalanceModal()">End Shift</button>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="InvoiceProductListModal" role="dialog" data-backdrop="static" data-keyboard="false" style="overflow-y: scroll; overflow-x: hidden;">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content card-p">
                <div class="modal-header cardm-head">
                    <h5 class="modal-title" id="exampleModalLongTitle"><span id="spnIvvoiceNo"></span>
                        <img src="../Images/del.png" class="del-btnp" onclick="CloseModalInvoiceItemList()" />
                    </h5>
                </div>
                <div class="modal-body" id="DivProductList" style="padding: 0px;">
                    <div class="row">
                        <div class="col-md-6">
                            <b>Customer:</b>&nbsp;&nbsp;<span id="spnCustName"></span>
                        </div>
                        <div class="col-md-6">
                            <b>Invoice Date:</b> &nbsp;&nbsp;<span id="spnInvoceDate"></span>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <b>Item Count:</b>&nbsp;&nbsp;<span id="spnItemCount"></span>
                        </div>
                        <div class="col-md-6 Happy" style="display: none">
                            <b>Earned Reward Points:</b>&nbsp;&nbsp;<span id="spnPMode"></span>
                        </div>
                    </div>
                    <div class="row Happy" style="display: none">
                        <div class="col-md-6">
                            <b>Total Reward Points:</b>&nbsp;&nbsp;<span id="spnHappy"></span>
                        </div>
                    </div>
                    <div class="table-responsive" style="padding-top: 5px;">
                        <table id="tblInvoiceItemList" class="table table-striped table-bordered well" style="margin-bottom: 0px;">
                            <thead>
                                <tr class="thead">
                                    <td class="InvoiceItemAutoId" style="white-space: nowrap; text-align: center; display: none;">InvoiceItemAutoId</td>
                                    <td class="SKUName" style="white-space: nowrap; text-align: center; word-wrap: break-word; width: 50%">SKU Name/Product Name</td>
                                    <td class="SchemeName" style="white-space: nowrap; text-align: center; display: none;">Scheme Name</td>
                                    <td class="SchemeAutoId" style="white-space: nowrap; text-align: center; display: none;">UnitAutoId</td>
                                    <td class="Quantity" style="white-space: nowrap; text-align: center">Quantity</td>
                                    <td class="UnitPrice" style="white-space: nowrap; text-align: center">Unit Price(<span class="symbol"></span>)</td>
                                    <%-- <td class="Tax" style="white-space: nowrap; text-align: center">Tax($)</td>--%>
                                    <td class="Total" style="white-space: nowrap; text-align: center">Total(<span class="symbol"></span>)</td>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>

                            <%--<tfoot style="background-color: white;">
                                <tr class="thead">
                                    <td colspan="1"></td>
                                    <td colspan="2" style="text-align: left; border: 1px white black"><strong>Subtotal</strong></td>
                                    <td id="tdSubtotal" style="text-align: right;">$1.00</td>
                                </tr>
                                <tr class="thead">
                                    <td colspan="1"></td>
                                    <td colspan="2" style="text-align: left; border: 1px white black"><strong>Tax</strong></td>
                                    <td id="tdTax" style="text-align: right;">$ 1.00</td>
                                </tr>
                                <tr class="thead">
                                    <td colspan="1"></td>
                                    <td colspan="2" style="text-align: left; border: 1px white black"><strong>Discount</strong></td>
                                    <td id="tdDiscount" style="text-align: right;">$1.00</td>
                                </tr>
                                <tr class="thead">
                                    <td colspan="1"></td>
                                    <td colspan="2" style="text-align: left; border: 1px white black"><strong>Gift Card Amount</strong></td>
                                    <td id="tdCouponAmount" style="text-align: right;">$1.00</td>
                                </tr>
                                <tr class="thead">
                                    <td colspan="1"></td>
                                    <td colspan="2" style="text-align: left; border: 1px white black"><strong>Grand Total</strong></td>
                                    <td style="text-align: right;"><strong><span id="tdGrandTotal"></span></strong></td>
                                </tr>
                            </tfoot>--%>
                        </table>
                        <h5 class="well text-center" id="InvoiceItemEmptyTable" style="display: none">No data available.</h5>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="row">
                                <div class="col-md-6">
                                    <label style="white-space: nowrap">Subtotal</label>
                                </div>
                                <div class="col-md-1">
                                    <label>:</label>
                                </div>
                                <div class="col-md-4" style="text-align: right; white-space: nowrap;">
                                    <span id="tdSubtotal">1</span>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                    <label style="white-space: nowrap">Tax</label>
                                </div>
                                <div class="col-md-1">
                                    <label>:</label>
                                </div>
                                <div class="col-md-4" style="text-align: right; white-space: nowrap;">
                                    <span id="tdTax">1</span>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                    <label>Discount</label>
                                </div>
                                <div class="col-md-1">
                                    <label>:</label>
                                </div>
                                <div class="col-md-4" style="text-align: right;">
                                    <span id="tdDiscount">1</span>
                                </div>
                            </div>
                            <div class="row Lottery">
                                <div class="col-md-6">
                                    <label style="white-space: nowrap">Lottery Total</label>
                                </div>
                                <div class="col-md-1">
                                    <label>:</label>
                                </div>
                                <div class="col-md-4" style="text-align: right; white-space: nowrap;">
                                    <span id="tdLotteryTotal">1</span>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                    <label style="white-space: nowrap">Grand Total</label>
                                </div>
                                <div class="col-md-1">
                                    <label>:</label>
                                </div>
                                <div class="col-md-4" style="text-align: right; white-space: nowrap;">
                                    <span id="tdGrandTotal">1</span>
                                </div>
                            </div>
                            <div class="row ReturnAmt" style="display: none;">
                                <div class="col-md-6">
                                    <label style="white-space: nowrap">Return Amount</label>
                                </div>
                                <div class="col-md-1">
                                    <label>:</label>
                                </div>
                                <div class="col-md-4" style="text-align: right; white-space: nowrap;">
                                    <span id="tdreturnAmt">1</span>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="row">
                                <div class="col-md-12">
                                    <label style="white-space: nowrap">Payment Mode</label>
                                </div>

                            </div>
                            <div id="DivTransactionDetails">
                            </div>
                            <%--<div class="row">
                                <div class="col-md-6">
                                     <label style="white-space:nowrap">Discount</label>
                                </div>
                                <div class="col-md-1">
                                    <label>:</label>
                                </div>
                                <div class="col-md-4" style="text-align: right;white-space:nowrap;">
                                    <span id="tdDiscount">1</span>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                     <label style="white-space:nowrap">Gift Card Amount</label>
                                </div>
                                <div class="col-md-1">
                                    <label>:</label>
                                </div>
                                <div class="col-md-4" style="text-align: right;white-space:nowrap;">
                                    <span id="tdCouponAmount">1</span>
                                </div>
                            </div>--%>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="CardTypeModal" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-dialog-centered" role="document" style="width: 600px !important">
            <div class="modal-content card-p">
                <div class="modal-header cardm-head">
                    <h5 class="modal-title">Transaction Details 
                        <%--<img src="../Images/del.png" class="del-btnp" onclick="CloseCardTypeModal()" />--%>
                    </h5>
                </div>
                <div class="modal-body" style="padding: 20px 0px 24px 0px;">
                    <div class="row CardList" id="CardList">
                    </div>
                    <div class="row CreditCardDetails" style="display: none">
                        <label class="col-md-4 form-group">
                            Amount<span class="required"> *</span>
                        </label>
                        <div class="col-md-8 form-group">
                            <div class="input-group">
                                <span class="input-group-addon input-sm symbol"></span>
                                <input type="text" id="txtTransactionAmt" ondrop="return false;" onpaste="return false" disabled="disabled" class="form-control input-sm" placeholder="0.00" style="text-align: right" onkeypress="return isNumberDecimalKey(event,this)" />
                            </div>
                        </div>
                    </div>
                    <div class="row CreditCardDetails" style="display: none">
                        <label class="col-md-4 form-group">
                            Last 4 digits<span class="required"> *</span>
                        </label>
                        <div class="col-md-8 form-group">
                            <input type="text" id="txtLastfourDigits" ondrop="return false;" onpaste="return false" maxlength="4" class="form-control input-sm" placeholder="Last 4 digits" onkeypress="return isNumberKey(event)" />
                        </div>
                    </div>
                    <div class="row CreditCardDetails" style="display: none">
                        <label class="col-md-4 form-group">
                            Transaction ID<span class="required"> *</span>
                        </label>
                        <div class="col-md-8 form-group">
                            <input type="text" id="txtCreditCardTransactionID" ondrop="return false;" onpaste="return false" maxlength="30" class="form-control input-sm" placeholder="Transaction ID" onkeypress="return isNumberKey(event)" />
                        </div>
                    </div>
                </div>
                <div class="modal-footer text-center" style="text-align: center">
                    <button type="button" class="btn btn-sm btn-danger" id="btnCreditCardPayBack" style="width: 120px; height: 40px; font-size: 17px; font-weight: 600" onclick="CloseCardTypeModal()">Back</button>
                    <button type="button" class="btn btn-sm btn-success" id="btnCreditCardePayProceed" style="width: 120px; height: 40px; font-size: 17px; display: none;" onclick="CreditcardPay()">PROCEED</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade ModalPayout" id="PayoutModal" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
            <div class="modal-content card-p" style="font-size: 18px;">
                <div class="modal-header cardm-head">
                    <h5 class="modal-title">Payout
                        <img src="../Images/del.png" class="del-btnp" data-dismiss="modal" onclick="CloseAddCustModal()" />
                    </h5>
                </div>
                <div class="modal-body" style="padding: 15px 0 0 0;">
                    <%--<div class="row">
                        <label class="col-md-4 form-group">
                            Company Name&nbsp;<span class="required">*</span>
                        </label>
                        <div class="col-md-8 form-group">
                            <select id="ddlCompanyName" style="padding-top: 2px;" class="form-control input-sm">
                                <option value="1">Select Company</option>
                            </select>
                        </div>
                    </div>--%>
                    <div class="col-md-6">
                        <div class="row">
                            <label class="col-md-4 form-group">
                                Payout Type<span class="required"> *</span>
                            </label>
                            <div class="col-md-8 form-group">
                                <select id="ddlPayoutType" onchange="BindDDLExpenseVendor();" class="form-control input-sm" style="padding-top: 2px; height: 50px">
                                    <option value="0">Select</option>
                                </select>
                            </div>
                            <label class="col-md-4 form-group Expense" style="display: none">
                                Expense<span class="required"> *</span>
                            </label>
                            <div class="col-md-8 form-group Expense" style="display: none">
                                <select id="ddlExpense" class="form-control input-sm" style="padding-top: 2px;">
                                    <option value="0">Select Expense</option>
                                </select>
                            </div>
                            <label class="col-md-4 form-group Vendor" style="display: none">
                                Vendor<span class="required"> *</span>
                            </label>
                            <div class="col-md-8 form-group Vendor" style="display: none">
                                <select id="ddlVendor" class="form-control input-sm" style="padding-top: 2px;">
                                    <option value="0">Select Vendor</option>
                                </select>
                            </div>
                            <label class="col-md-4 form-group">
                                Pay To<span class="required"> *</span>
                            </label>
                            <div class="col-md-8 form-group">
                                <input type="text" id="txtPayTo" maxlength="60" class="form-control input-sm" placeholder="Pay To" />
                            </div>
                            <label class="col-md-4 form-group">
                                Amount<span class="required"> *</span>
                            </label>
                            <div class="col-md-8 form-group">
                                <div class="input-group">
                                    <span class="input-group-addon input-sm symbol"></span>
                                    <input type="text" id="txtAmount" ondrop="return false;" onpaste="return false" maxlength="9" class="form-control input-sm" placeholder="0.00" style="text-align: right" onkeypress="return isNumberDecimalKey(event,this)" />
                                </div>
                            </div>
                            <label class="col-md-4 form-group" style="white-space: nowrap">
                                Payment Mode
                            </label>
                            <div class="col-md-8 form-group">
                                <select id="ddlPayoutmode" class="form-control input-sm" onchange="OpenOnline();" style="padding-top: 2px;">
                                    <option value="Cash">Cash</option>
                                    <%-- <option value="Online">Online</option>--%>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="row">
                            <label class="col-md-4 form-group">
                                Date&nbsp;<span class="required">*</span>
                            </label>
                            <div class="col-md-4 form-group">
                                <input type="text" id="txtDate" style="text-align: left" placeholder="Select Date" class="form-control input-sm" readonly="readonly" />
                            </div>
                            <%--<label class="col-md-4 form-group">
                                Time&nbsp;<span class="required">*</span>
                            </label>--%>
                            <div class="col-md-4 form-group">
                                <input type="text" id="txtTime" style="text-align: left" placeholder="Select Time" class="form-control input-sm" readonly="readonly" />
                            </div>
                            <label class="col-md-4 form-group">
                                Remark<span class="required"> *</span>
                            </label>
                            <div class="col-md-8 form-group">
                                <textarea id="txtRemark" maxlength="300" class="form-control input-sm" style="resize: none;"
                                    rows="4" placeholder="Remark"></textarea>
                            </div>
                        </div>
                    </div>


                    <div class="row">
                        <div class="col-md-12 form-group">
                            <div class="pull-right">
                                <button type="button" id="btnSave" onclick="this.disabled=true;InsertPayout();" class="btn btn-sm catsave-btn">Save</button>
                                <button type="button" id="btnUpdate" onclick="UpdatePayout();" class="btn btn-sm catsave-btn" style="display: none">Update</button>
                                <button type="button" id="btnReset" onclick="PayoutReset();" class="btn btn-sm catreset-btn">Reset</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="GiftCardRedeemModal" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-dialog-centered" role="document" style="width: 600px !important">
            <div class="modal-content card-p">
                <div class="modal-header cardm-head">
                    <h5 class="modal-title">Apply Gift Card
                        <%--<img src="../Images/del.png" class="del-btnp" onclick="CloseCardTypeModal()" />--%>
                    </h5>
                </div>
                <div class="modal-body" style="padding-left: 0px; padding-right: 0px;">
                    <div class="row" style="font-size: 20px">
                        <%--<div class="col-md-4">
                            
                        </div>--%>
                        <div class="col-md-12">
                            <input id="txtGiftCardNo" class="form-control input-sm" style="height: 40px" maxlength="16" placeholder="Enter Gift Card Code" />
                        </div>
                    </div>

                </div>
                <div class="modal-footer text-center" style="text-align: center">

                    <button type="button" class="btn btn-sm btn-danger" style="width: 120px; height: 40px; font-size: 17px; font-weight: 600;"
                        onclick="CloseGiftCardRedeemModal()">
                        Back</button>
                    <button type="button" class="btn btn-sm cataddnew-btn" style="width: 120px; height: 40px; font-size: 17px; font-weight: 600;"
                        onclick="RedeemGiftCard()">
                        Apply</button>
                    <%--<button type="button" class="btn btn-sm btn-success" style="width: 100px" onclick="CreditcardPay()">PAY</button>--%>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="GiftModal" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-dialog-centered" role="document" style="width: 600px !important">
            <div class="modal-content card-p">
                <div class="modal-header cardm-head">
                    <h5 class="modal-title">Apply Coupon
                      <%--<img src="../Images/del.png" class="del-btnp" onclick="CloseCardTypeModal()" />--%>
                    </h5>
                </div>
                <div class="modal-body" style="padding: 20px; margin-top: 20px">
                    <div class="row">
                        <div class="col-md-12" style="text-align: center">
                            <input type="text" id="txtGift" maxlength="60" style="height: 40px" class="input-sm form-control" placeholder="Coupon Code" />
                        </div>
                    </div>
                </div>
                <div class="modal-footer text-center" style="text-align: center">
                    <button type="button" class="btn btn-sm btn-danger" style="width: 120px; height: 40px; font-size: 17px; font-weight: 600;"
                        onclick="CloseCouponModal()">
                        Back</button>
                    <button type="button" onclick="ApplyCoupon();" style="width: 120px; height: 40px; font-size: 17px" class="btn btn-sm cataddnew-btn">Apply</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="HappypointsRedeemModal" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content card-p" style="width: 600px">
                <div class="modal-header cardm-head">
                    <h5 class="modal-title">Redeem Reward Points
                        <%--<img src="../Images/del.png" class="del-btnp" onclick="CloseCardTypeModal()" />--%>
                    </h5>
                </div>
                <div class="modal-body" style="padding-left: 0px; padding-right: 0px;">
                    <div class="row">
                        <div class="col-md-5">
                            <label>Available Reward Points</label>
                        </div>
                        <div class="col-md-7">
                            <input id="txtAvlHappyPoints" class="form-control input-sm" maxlength="5" placeholder="Available Reward Points" value="0" readonly="readonly" />
                        </div>
                    </div>
                    <div class="row" style="margin-top: 10px">
                        <div class="col-md-5">
                            <label style="white-space: nowrap">Amount Per Reward Points</label>
                        </div>
                        <div class="col-md-7">
                            <div class="input-group">
                                <span class="input-group-addon input-sm symbol"></span>
                                <input type="text" id="txtAmtPerPoint" onclick="this.select();" onselectstart="return false" oncut="return false" oncopy="return false" onpaste="return false" style="text-align: right;" ondrag="return false" readonly="readonly" ondrop="return false" class="form-control input-sm text-right" maxlength="5" placeholder="Amount" value="0.00" onkeypress="return isNumberDecimalKey(event,this)" />
                                <%--                                <input id="txtAmtPerPoint" class="form-control input-sm" maxlength="5" placeholder="Amount Per Points" value="0" readonly="readonly" />--%>
                            </div>
                        </div>
                    </div>
                    <div class="row" style="margin-top: 10px">
                        <div class="col-md-5">
                            <label>Enter Points To Redeem <span style="color: red">*</span></label>
                        </div>
                        <div class="col-md-7">
                            <input type="text" id="txtRedeemHappyPoints" onclick="this.select()" onselectstart="return false" maxlength="5" oncut="return false" oncopy="return false" onpaste="return false" ondrag="return false" ondrop="return false" class="form-control input-sm text-right" placeholder="Enter No. of Points" value="0" onchange="return IsValidInteger(this);" onkeypress="return event.charCode >= 48 &amp;&amp; event.charCode <= 57" />
                        </div>
                    </div>
                </div>
                <div class="modal-footer text-center" style="text-align: center">

                    <button type="button" class="btn btn-sm btn-danger" style="width: 120px; height: 40px; font-size: 17px; font-weight: 600" onclick="CloseHappyPointRedeemModal()">Back</button>
                    <button type="button" class="btn btn-sm cataddnew-btn" style="width: 120px; height: 40px; font-size: 17px" onclick="RedeemHappyPoints()">Apply</button>
                    <%--<button type="button" class="btn btn-sm btn-success" style="width: 100px" onclick="CreditcardPay()">PAY</button>--%>
                </div>
            </div>
        </div>
    </div>
    <script src="/Style/js/ASPSnippets_Pager.min.js"></script>
</body>
</html>

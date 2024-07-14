<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="LiveCart.aspx.cs" Inherits="Pages_LiveCart" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>Live Cart Report
        </h1>
    </section>
    <div class="content" id="divForm" ondragstart="return false;" ondrop="return false;">
        <div class="row">
            <div class="col-md-12">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <b>Live Cart Report </b>
                    </div>
                    <div class="panel-body">
                        <div class="row">
                            <div class="col-md-3 form-group" style="display: none">
                                <label>Select Store</label>
                                <select id="ddlStore" onchange="BindTerminal()" class="form-control">
                                    <option value="0">Select Store</option>
                                </select>
                            </div>
                            <div class="col-md-3 form-group">
                                <label>Select Terminal</label>
                                <select id="ddlTerminal" class="form-control">
                                    <option value="0">Select Terminal</option>
                                </select>
                            </div>
                            <div class="col-md-3 form-group" style="text-align: right; padding-top: 30px">
                                <label></label>
                                <button type="button" id="btnLiveCart" onclick="getCartandList();" class="btn btn-sm catsearch-btn">Search</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-md-5">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <b>Cart Details </b>
                    </div>
                    <div class="row" style="padding-top: 5px;">
                        <div class="col-md-12" style="margin-left: 10px;">
                            <div class="row">
                                <div class="col-md-6 ">
                                    <label>User Name: </label>
                                    <span id="spn_User"></span>
                                </div>
                                <div class="col-md-6">
                                    <label>Order No.: </label>
                                    <span id="spn_OrderNo"></span>
                                </div>

                            </div>
                            <div class="row">
                                <div class="col-md-12">
                                    <label>Customer: </label>
                                    <span id="spn_Customer"></span>
                                </div>
                            </div>
                            <hr />
                        </div>

                        <div class="col-md-12">
                            <input type="hidden" runat="server" id="hdnEmpId" value="1" />
                            <input type="hidden" runat="server" id="hdnEmpAutoId" value="" />
                            <input type="hidden" runat="server" id="hdnMinOrderAmtToReedemReward" value="" />
                            <input type="hidden" runat="server" id="hdnReedemRewardStatus" value="0" />
                            <input type="hidden" runat="server" id="hdnOrderId" value="" />
                            <input type="hidden" runat="server" id="hdnOrderNo" value="" />


                            <div class="row scrollbar tableFixHead style-3">
                                <div class="col-md-12" id="tblProductDetail"></div>
                            </div>

                            <div class="row" style="margin-left: 10px;">
                                <div class="col-md-6 form-group" style="margin-bottom: 0px;">
                                    <label>Product Count :</label><span style="margin-left: 10px" id="totalProductCnt"></span>
                                </div>
                                <div class="col-md-6 form-group" style="margin-bottom: 0px">
                                    <label>Quantity :</label><span style="margin-left: 10px" id="totalQuantityCnt"></span>
                                </div>
                            </div>
                            <hr />
                            <div class="row" style="margin-left: 10px;">
                                <div class="col-md-5">
                                    <div class="row">
                                        <div class="col-md-5">Subtotal</div>
                                        <div class="col-md-7 text-right">
                                            <label style="display: none;" id="lblsubtotal">0.00</label>
                                            <strong>
                                                <label id="lblsubtotal1">
                                                    <span class="symbol"></span>0.00</label>
                                            </strong>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-5">Tax</div>
                                        <div class="col-md-7 text-right">
                                            <strong>
                                                <label id="lbltax"><span class="symbol"></span>0.00</label></strong>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-5">Discount<span id="DiscType"></span></div>
                                        <div class="col-md-7 text-right" style="white-space: nowrap;">
                                            <strong><span id="lbldiscount1" style="margin-left: 27px;"><span class="symbol" style="margin-right: 1px;"></span>0.00</span>
                                                </strong><label style="display: none" id="lbldiscount">0.00</label>
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
                                            <span id="lblgrandtotal1"><span class="symbol"></span>0.00</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-7">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <b>Recent Invoices </b>
                    </div>
                    <div class="panel-body">
                        <div class="row">
                        <div class="col-md-12">
                            <div class="table-responsive" style="padding-top: 5px;">
                                <table id="tblInvoiceList" class="table table-striped table-bordered well" style="margin-bottom: 0px;">
                                    <thead>
                                        <tr class="thead">
                                            <td class="Action" style="width: 80px; text-align: center;">Action</td>
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
                                            <td class="UpdationDetails" style="white-space: nowrap; text-align: center; display: none">Creation Details</td>
                                            <td class="CreatedFrom" style="white-space: nowrap; text-align: center;">Created<br />
                                                From</td>
                                            <td class="Status" style="white-space: nowrap; text-align: center;">Status</td>
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
                                    <span id="spInvoiceSortBy" style="color: red; font-size: small; margin-right: 10px;"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    </div>
                    


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
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>


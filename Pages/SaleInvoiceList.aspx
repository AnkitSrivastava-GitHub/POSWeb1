<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="SaleInvoiceList.aspx.cs" Inherits="Pages_SaleInvoiceList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>Sale Invoice List
            <a href="/Pages/POSScreen.aspx" style="display:none" class="btn btn-sm btn-warning pull-right">Create Invoice</a>
        </h1>
    </section>
    <div class="content" id="divForm" ondragstart="return false;" ondrop="return false;">
        <div class="row">
            <div class="col-md-12">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <b>Sale Invoice List</b>
                    </div>
                    <div class="panel-body">
                        <div class="row">
                            <div class="col-md-2 form-group">
                                <label>Invoice Number</label>
                                <input type="text" id="txtInvoiceNumber" class="form-control input-sm" placeholder="Invoice Number" />
                            </div>
                            <div class="col-md-3 form-group">
                                <label>Customer Name</label>
                                <input type="text" id="txtCustName" class="form-control input-sm" placeholder="Customer Name" />
                            </div>
                            <div class="col-md-2 form-group">
                                <label>From Date</label>
                                <input type="text" id="txtInvoFromDate" class="form-control input-sm date" readonly="readonly" placeholder="select Date" />
                            </div>
                            <div class="col-md-2 form-group">
                                <label>To Date</label>
                                <input type="text" id="txtInvoToDate" class="form-control input-sm date" readonly="readonly" placeholder="select Date" />
                            </div>
                            <div class="col-md-3 form-group">
                                <label>Terminal</label>
                                <select id="ddlTerminal" class="form-control input-sm">
                                    <option value="0">All</option>
                                </select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-2 form-group">
                                <label>Created From</label>
                                <select id="ddlCreatedFrom" class="form-control input-sm">
                                    <option value="0">All</option>
                                    <option value="Web">Web</option>
                                    <option value="App">App</option>
                                </select>
                            </div>
                            <div class="col-md-10 form-group" style="text-align: right; padding-top: 30px">
                                <button type="button" id="btnSearchInvoice" onclick="showLoader();BindSaleInvoiceList(1);" class="btn btn-sm catsearch-btn">Search</button>
                            </div>
                        </div>
                        <div class="table-responsive" style="padding-top: 5px;">
                            <table id="tblInvoiceList" class="table table-striped table-bordered well" style="margin-bottom: 0px;display:none;">
                                <thead>
                                    <tr class="thead">
                                        <td class="Action" style="width: 100px; text-align: center;">Action</td>
                                        <td class="InvoiceAutoId" style="white-space: nowrap; text-align: center; display: none;">InvoiceAutoId</td>
                                        <td class="InvoiceNumber" style="white-space: nowrap; text-align: center">Invoice Number</td>
                                        <td class="InvoiceDate" style="white-space: nowrap; text-align: center">Invoice Date & Time</td>
                                        <td class="PaymentMethod" style="white-space: nowrap; display: none; text-align: center">Payment Method</td>
                                        <td class="CustomerName" style="white-space: nowrap; text-align: center">Customer Name</td>
                                        <td class="Tax" style="white-space: nowrap; text-align: center">Tax(<span class="symbol"></span>)</td>
                                        <td class="Discount" style="white-space: nowrap; text-align: center">Discount(<span class="symbol"></span>)</td>
                                        <td class="Coupon" style="white-space: nowrap; text-align: center">Coupon</td>
                                        <td class="CouponAmt" style="white-space: nowrap; text-align: center; display: none; vertical-align: middle;">Coupon Amount(<span class="symbol"></span>)</td>
                                        <td class="Total" style="white-space: nowrap; text-align: center">Total(<span class="symbol"></span>)</td>
                                        <%--<td class="SaleInvoiceItems" style="white-space: nowrap; text-align: center;display:None">View Invoice Items</td>--%>
                                        <%--<td class="UpdationDetails" style="white-space: nowrap; text-align: center;">Creation Details</td>--%>
                                        <td class="Terminal" style="white-space: nowrap; text-align: center">Terminal</td>
                                        <td class="CreatedFrom" style="white-space: nowrap; text-align: center;">Created From</td>
                                        <td class="Status" style="white-space: nowrap; text-align: center; display:none">Status</td>
                                    </tr>
                                </thead>
                            </table>
                            <h5 class="well text-center" id="InvoiceEmptyTable" style="display: none">No data available.</h5>
                        </div>
                        <div class="form-group row" style="padding-bottom: 0px; margin-bottom: 0px; margin-top: 10px;" id="DivPager">
                            <div class="col-md-1">
                                <select class="form-control border-primary input-sm" id="ddlPageSize" style="display:none;" onchange="BindSaleInvoiceList(1)">
                                    <option value="10">10</option>
                                    <option value="50">50</option>
                                    <option value="100">100</option>
                                    <option value="500">500</option>
                                    <option value="1000">1000</option>
                                    <option value="0">All</option>
                                </select>
                            </div>
                            <div class="col-md-8">
                                <div class="Pager" id="Pager"></div>
                            </div>
                            <div class="col-md-3 text-right">
                                <span id="spInvoiceSortBy" style="color: red; font-size: small;"></span>
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
                            <b>Earned Happy Points:</b>&nbsp;&nbsp;<span id="spnPMode"></span>
                        </div>
                    </div>
                    <div class="row Happy" style="display: none">
                        <div class="col-md-6">
                            <b>Total Happy Points:</b>&nbsp;&nbsp;<span id="spnHappy"></span>
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


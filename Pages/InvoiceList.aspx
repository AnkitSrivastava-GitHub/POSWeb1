<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="InvoiceList.aspx.cs" Inherits="Pages_InvoiceList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <style>
        .del-btn {
            width: 25px;
            height: 25px;
            opacity: 1.2;
            position: absolute;
            top: 10px;
            right: 9px;
            z-index: 2;
            cursor: pointer;
            border: 0;
            padding: 0;
            font-size: 0;
        }
    </style>
    <section class="content-header">
        <h1>Purchase invoice list
            <a href="/Pages/DirectInvoiceGenerate.aspx" class="btn btn-sm btn-warning pull-right">Generate PO Invoice</a>
        </h1>
    </section>
    <div class="content" id="divForm" ondragstart="return false;" ondrop="return false;">
        <div class="row">
            <div class="col-md-12">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <b>Purchase invoice list</b>
                    </div>
                    <div class="panel-body">
                        <div class="row">
                            <div class="col-md-3 form-group">
                                <input type="text" id="txtInvoiceNumber" class="form-control input-sm" placeholder="Enter Invoice Number" maxlength="20"  />
                            </div>
                            <div class="col-md-3 form-group">
                                <input type="text" id="txtPONumber" class="form-control input-sm" placeholder="Enter PO Number" maxlength="20" />
                            </div>
                            <div class="col-md-3 form-group">
                                <select id="ddlVendor" class="form-control input-sm">
                                    <option value="0">All Vendor</option>
                                </select>
                            </div>
                            <div class="col-md-1 form-group" style="text-align: right;">
                                <button type="button" id="btnSearchInvoice" onclick="BindInvoiceList(1);" class="btn btn-sm catsearch-btn">Search</button>
                            </div>
                        </div>
                        <div class="table-responsive" style="padding-top: 5px;">
                            <table id="tblInvoiceList" class="table table-striped table-bordered well" style="margin-bottom: 0px;display:none">
                                <thead>
                                    <tr class="thead">
                                        <td class="Action" style="width: 100px; text-align: center;">Action</td>
                                        <td class="InvoiceAutoId" style="white-space: nowrap; text-align: center; display: none;">InvoiceAutoId</td>
                                        <td class="InvoiceNumber" style="white-space: nowrap; text-align: center">Invoice Number</td>
                                        <td class="PONumber" style="white-space: nowrap; text-align: center">PO Number</td>
                                        <td class="BatchNumber" style="white-space: nowrap; text-align: center">Batch Number</td>
                                        <td class="Vendor" style="white-space: nowrap; text-align: center">Vendor Name</td>
                                        <td class="InvoiceDate" style="white-space: nowrap; text-align: center">Purchase Date</td>
                                        <td class="POItems" style="white-space: nowrap; text-align: center;">View Invoice Items</td>
                                        <%-- <td class="CreationDetails" style="white-space: nowrap; text-align: center;">Created Details</td>--%>
                                        <td class="UpdationDetails" style="white-space: nowrap; text-align: center;">Creation Details</td>
                                        <%-- <td class="PO_Status" style="white-space: nowrap; text-align: center;">Status</td>--%>
                                    </tr>
                                </thead>
                            </table>
                            <h5 class="well text-center" id="InvoiceEmptyTable" style="display: none">No data available.</h5>
                        </div>
                        <div class="form-group row" style="padding-bottom: 0px; margin-bottom: 0px; margin-top: 10px;" id="DivPager">
                            <div class="col-md-1">
                                <select class="form-control border-primary input-sm" id="ddlPageSize" style="display:none;" onchange="BindInvoiceList(1)">
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
    <div class="modal fade" id="InvoiceProductListModal" tabindex="-1" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-dialog-centered modal-lg" style="width: 1150px" role="document">
            <div class="modal-content">
                <div class="modal-header" style="margin-top:5px">
                    <h4 class="modal-title" id="exampleModalLongTitle"><strong>Product List</strong>
                        <img src="../Images/del.png" style="margin-top:5px;height:35px;width:35px;" class="del-btn" data-dismiss="modal" id="CloseModalD" />
                    </h4>
                </div>
                <div class="modal-body" id="DivProductList" style="margin-top: -20px;">
                    <div class="table-responsive" style="padding-top: 0px;overflow: hidden;">
                        <table id="tblInvoiceProductList" class="table table-striped table-bordered well" style="margin-bottom: 0px;">
                            <thead>
                                <tr class="thead">
                                    <td class="PoItemAutoId" style="width: 50px; text-align: center; display: none;">PoItemAutoId</td>
                                    <td class="ProductAutoId" style="white-space: nowrap; text-align: center; display: none;">ProductAutoId</td>
                                    <td class="ProductName" style="word-wrap:normal;text-align: center">Product Name</td>
                                    <td class="UnitType" style="white-space: nowrap; text-align: center">Unit Type</td>
                                    <td class="UnitAutoId" style="white-space: nowrap; text-align: center; display: none;">UnitAutoId</td>
                                    <td class="Quantity" style="white-space: nowrap; text-align: center">Quantity</td>
                                    <td class="SellingUnitCost" style="white-space: nowrap; text-align: center">Selling <br />Unit Price(<span class="symbol"></span>)</td>
                                    <td class="SecondaryCost" style="white-space: nowrap; text-align: center">Secondary<br /> Unit Price(<span class="symbol"></span>)</td>
                                    <td class="PreviousCost" style="white-space: nowrap; text-align: center">Previous<br /> Cost Price(<span class="symbol"></span>)</td>
                                    <td class="SUnitPrice" style="white-space: nowrap; text-align: center">Cost Price(<span class="symbol"></span>)</td>
                                    <td class="Tax" style="white-space: nowrap; text-align: center;display:none;">Tax (<span class="symbol"></span>)</td>
                                    <td class="Total" style="white-space: nowrap; text-align: center">Total (<span class="symbol"></span>)</td>
                                </tr>
                            </thead>
                        </table>
                        <h5 class="well text-center" id="InvoiceProductEmptyTable" style="display: none">No data available.</h5>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="PreviousStockModal" tabindex="-1" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header" style="margin-top:5px">
                    <h4 class="modal-title"><strong>Stock Details</strong>
                        <img src="../Images/del.png" style="margin-top:5px" class="del-btn close" data-dismiss="modal" id="CloseModalPS" />
                    </h4>
                </div>
                <div class="modal-body" id="DivPreviousStock" style="margin-top: -20px;">
                    <div class="table-responsive" style="padding-top: 0px;">
                        <table id="tblPreviousStockList" class="table table-striped table-bordered well" style="margin-bottom: 0px;">
                            <thead>
                                <tr class="thead">
                                    <td class="ProductAutoId" style="white-space: nowrap; text-align: center; display: none;">ProductAutoId</td>
                                    <td class="ProductName" style="white-space: nowrap; text-align: center">Product Name</td>
                                    <td class="PreviousStock" style="white-space: nowrap; text-align: center">Previous Stock QTY</td>
                                    <td class="PurchaseStock" style="white-space: nowrap; text-align: center">Purchase Stock QTY</td>
                                    <td class="EffectedStock" style="white-space: nowrap; text-align: center">Affected Stock QTY</td>
                                </tr>
                            </thead>
                        </table>
                        <h5 class="well text-center" id="PreviousStockEmptyTable" style="display: none">No data available.</h5>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>


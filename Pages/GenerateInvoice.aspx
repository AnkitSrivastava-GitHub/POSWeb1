<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="GenerateInvoice.aspx.cs" Inherits="Pages_GenerateInvoice" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>Generate Invoice
            <a href="/Pages/InvoiceList.aspx" class="btn btn-sm btn-warning pull-right">Invoice List</a>
        </h1>
    </section>
    <div class="content" id="divForm" ondragstart="return false;" ondrop="return false;">
        <div class="row">
            <div class="col-md-12">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <b>PO Details</b>
                    </div>
                    <div class="panel-body" id="panelStoreDetail">
                        <div class="row">
                            <div class="col-md-3  form-group">
                                <label>Vendor</label>
                                <select id="ddlVendor" class="form-control input-sm" disabled>
                                    <option value="0">Select Vendor</option>
                                </select>
                            </div>
                            <div class="col-md-2  form-group">
                                <label>PO Date</label>
                                <input type="text" id="txtDate" class="form-control input-sm Date" disabled />
                            </div>
                            <div class="col-md-2  form-group">
                                <label>Status</label>
                                <select id="ddlPotatus" class="form-control input-sm" disabled>
                                    <option value="1" selected="selected">Active</option>
                                    <option value="0">Inactive</option>
                                </select>
                            </div>
                            <div class="col-md-5  form-group">
                                <label>Remark</label>
                                <input type="text" id="txtRemark" class="form-control input-sm" readonly />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-12">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <b>Invoice Details</b>
                    </div>
                    <div class="panel-body" id="">
                        <div class="row">
                            <div class="col-md-4  form-group">
                                <label>PO Number</label>
                                <input type="text" id="txtPONumber" class="form-control input-sm" readonly />
                            </div>
                            <div class="col-md-4  form-group">
                                <label>Invoice Number <span class="required">*</span></label>
                                <input type="text" id="txtInvoiceNo" class="form-control input-sm" />
                            </div>
                            <div class="col-md-4  form-group">
                                <label>Purchase Date <span class="required">*</span></label>
                                <input type="text" id="txtPurchaseDate" class="form-control input-sm" readonly />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-12">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <b>PO Item Details</b>
                    </div>
                    <div class="panel-body">
                        <div class="table-responsive">
                            <div>
                                <p style="text-align: right;"><span><b>Row Count: </b></span><span id="RowCount">0</span></p>
                            </div>
                            <table id="tblPOList" class="table table-striped table-bordered well">
                                <thead>
                                    <tr class="thead">
                                        <%-- <td class="Action" style="width: 50px; text-align: center;">Action</td>--%>
                                        <td class="PoItemAutoId" style="text-align: center; display: none;">PoItemAutoId</td>
                                        <td class="ProductAutoId" style="white-space: nowrap; text-align: center; display: none;">ProductAutoId</td>
                                        <td class="VendorProductCode" style="width: 150px; text-align: center;">Vendor Product Code</td>
                                        <td class="ProductName" style="white-space: nowrap; text-align: center">Product Name</td>
                                        <td class="UnitType" style="white-space: nowrap; text-align: center">Unit Type</td>
                                        <td class="UnitAutoId" style="white-space: nowrap; text-align: center; display: none;">UnitAutoId</td>
                                        <td class="RequiredQty" style="width: 150px; text-align: center">Required Quantity</td>
                                        <td class="PartialQty" style="width: 150px; text-align: center">Partially Received</td>
                                        <td class="RemainingQty" style="width: 150px; text-align: center">Remaining Quantity</td>
                                        <td class="ReceivedQty" style="width: 150px; text-align: center; width: 12%;">Received Quantity</td>
                                        <td class="UnitPrice" style="white-space: nowrap; text-align: center; width: 12%;">Cost Price (<span class="symbol"></span>)</td>
                                        <td class="UnitPrice1" style="text-align: center; width: 150px;">Product Unit Price(<span class="symbol"></span>)</td>
                                        <td class="SecUnitPrice" style="text-align: center; width: 150px;">Secondary Unit Price(<span class="symbol"></span>)</td>
                                        <td class="TotalCost" style="white-space: nowrap; text-align: center;">Total Cost (<span class="symbol"></span>)</td>
                                        <td class="Taxper" style="white-space: nowrap; text-align: center; display: none;">Taxper</td>
                                        <td class="ActionId" style="white-space: nowrap; text-align: center; display: none;">ActionId</td>
                                    </tr>
                                </thead>
                                <tbody id="tblPOListBody" class="tbody">
                                </tbody>
                                <tfoot id="tblPOListFoot">
                                    <tr class="tfoot">
                                        <td class="F_POTotal" colspan="3" style="white-space: nowrap; text-align: right"><b>Total</b></td>
                                        <td class="F_RequiredQty" id="F_RequiredQty" colspan="1" style="white-space: nowrap; text-align: center; font-weight: 900;">0</td>
                                        <td class="F_PartialQty" id="F_PartiallyQty" colspan="1" style="white-space: nowrap; text-align: center; font-weight: 900;">0</td>
                                        <td class="F_RemainingQty" id="F_RemainingQty" colspan="1" style="white-space: nowrap; text-align: center; font-weight: 900;">0</td>
                                        <td class="F_ReceivedQty" id="F_ReceivedQty" colspan="1" style="white-space: nowrap; text-align: center; font-weight: 900;">0</td>

                                        <td class="F_TotalCost" id="F_TotalCost" colspan="4" style="white-space: nowrap; text-align: right; font-weight: 900;">0.00</td>
                                    </tr>
                                </tfoot>
                            </table>
                            <h5 class="well text-center" id="ProductEmptyTable" style="display: none">No data available.</h5>
                        </div>
                        <hr />
                        <div class="row">
                            <div class="col-md-12">
                                <%--<button type="button" id="btnReset" onclick="ResetPO()" style="margin-left: 10px;" class="btn btn-sm btn-default pull-right">Reset</button>--%>
                                <button type="button" id="btnSave" onclick="GenerateInvoice()" class="btn btn-sm btn-success pull-right">Generate Invoice</button>
                                <%--<button type="button" id="btnUpdate" onclick="UpdatePO()" style="display: none;" class="btn btn-sm btn-success pull-right">Update</button>--%>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>


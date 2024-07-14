<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="DirectInvoiceGenerate.aspx.cs" Inherits="Pages_DirectInvoiceGenerate" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1 ><span id="headername">Direct PO Invoice Generate</span>
            <a href="/Pages/InvoiceList.aspx" class="btn btn-sm btn-warning pull-right">Purchase Invoice List</a>
        </h1>
    </section>
    <div class="content" id="divForm" ondragstart="return false;" ondrop="return false;">
        <div class="row">
            <div class="col-md-12">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <b>Purchase Invoice Details</b>
                    </div>
                    <div class="panel-body" id="">
                        <div class="row">
                            <div class="col-md-3 form-group">
                                <label>Vendor <span class="required">*</span></label>
                                <select id="ddlVendor" class="form-control input-sm">
                                    <option value="0">Select Vendor</option>
                                </select>
                            </div>
                            <div class="col-md-2  form-group">
                                <label>Invoice Number <span class="required">*</span></label>
                                <input type="text" id="txtInvoiceNo" class="form-control input-sm" placeholder="Invoice Number" maxlength="20" />
                            </div>
                            <div class="col-md-2  form-group">
                                <label>Purchase Date <span class="required">*</span></label>
                                <input type="text" id="txtPurchaseDate" class="form-control input-sm date" readonly />
                            </div>
                            <div class="col-md-5 form-group">
                                <label>Remark </label>
                                <input type="text" id="txtRemark" class="form-control input-sm" placeholder="Enter Remark" maxlength="250" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-12">
                <div class="panel panel-default">
                    <div class="panel-heading" id="panel-heading">
                        <b>Item Details</b>
                    </div>
                    <div class="panel-body" >
                        <div class="row" id="panel-Body1">
                            <div class="col-md-2 form-group">
                                <label>Barcode</label>
                                <input type="text" id="txtBarcode" onpaste="var e=this; setTimeout(function(){FillProductByBarcode(e)}, 4);" class="form-control input-sm" maxlength="25" placeholder="Barcode" />
                            </div>
                            <div class="col-md-2 form-group">
                                <label>Vendor Product Code </label>
                                <input type="text" id="txtVProductCode" style="width: 183px;" onchange="FillProduct(this);" onpaste="var e=this; setTimeout(function(){FillProduct(e)}, 4);" class="form-control input-sm" maxlength="25" onkeypress="return isNumberKey(this)" placeholder="Vendor Product Code" />
                            </div>
                            <div class="col-md-4  form-group">
                                <label>Product <span class="required">*</span></label>
                                <select id="ddlProduct" onchange="BindUnitList()"  class="form-control input-sm">
                                    <option value="0">Select Product</option>
                                </select>
                            </div>
                            <div class="col-md-2  form-group">
                                <label>Unit Type<span class="required"> *</span></label>
                                <select id="ddlUnitType" onchange="FillPrice();" class="form-control input-sm">
                                    <option value="0">Select Unit</option>
                                </select>
                            </div>
                            <div class="col-md-2  form-group">
                                <label>Quantity <span class="required">*</span></label>
                                <input type="text" id="txtQuantity" class="form-control input-sm" maxlength="4" onkeypress="return isNumberKey(this)"
                                    placeholder="Enter Quantity" oncopy="return false" onpaste="return false" oncut="return false" style="text-align: center;" />
                            </div>

                        </div>
                        <div class="row" id="panel-Body2">
                            <div class="col-md-2 form-group">
                                <label>Previous Cost Price</label>
                                <div class="input-group">
                                    <span class="input-group-addon input-sm symbol"></span>
                                    <input type="text" id="txtCostPrice" placeholder="0.00" style="text-align: right" class="form-control input-sm" maxlength="4" onkeypress="return isNumberKey(this)" disabled="disabled" />
                                </div>
                            </div>
                            <div class="col-md-2 form-group">
                                <label>Selling Unit Price</label>
                                <div class="input-group">
                                    <span class="input-group-addon input-sm symbol"></span>
                                    <input type="text" id="txtUnitPrice1" class="form-control input-sm" style="text-align: right;" maxlength="4" placeholder="0.00" onkeypress="return isNumberKey(this)" disabled="disabled" />
                                </div>
                            </div>
                            <div class="col-md-2  form-group">
                                <label>Secondary Unit Price </label>
                                <div class="input-group">
                                    <span class="input-group-addon input-sm symbol"></span>
                                    <input type="text" id="txtSecUnitPrice" class="form-control input-sm" style="text-align: right;" maxlength="4" placeholder="0.00" onkeypress="return isNumberKey(this)" disabled="disabled" />
                                </div>
                            </div>
                            <div class="col-md-2 form-group">
                                <label>Cost Price <span class="required">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-addon input-sm symbol"></span>
                                    <input type="text" id="txtUnitPrice" value="0.00" class="form-control input-sm" maxlength="7" style="text-align: right;"
                                        onkeypress="return isNumberDecimalKey(event,this)" placeholder="0.00" autofill="0.00"
                                        oncopy="return false" onpaste="return false" oncut="return false" />
                                </div>
                            </div>
                            <div class="col-md-4 form-group">
                                <div class="pull-right" style="margin-top: 25px;">
                                    <button type="button" id="btnAdd" style="width: 100px;" onclick="AddPoItem()" class="btn btn-sm btn-success">Add</button>
                                    <button type="button" id="btnUpdateList" style="width: 100px; display: none" onclick="AddPoItem()" class="btn btn-sm btn-success">Update</button>
                                </div>
                            </div>
                        </div>
                        <div class="row" style="margin-bottom: 10px;">
                        </div>
                        <div class="table-responsive">
                            <div>
                                <p style="text-align:right;"><span><b>Row Count: </b></span><span id="RowCount">0</span></p>
                            </div>
                            <table id="tblPOList" class="table table-striped table-bordered well">
                                <thead>
                                    <tr class="thead">
                                        <td class="Action" style="width: 50px; text-align: center;">Action</td>
                                        <td class="ProductAutoId" style="white-space: nowrap; text-align: center; display: none;">ProductAutoId</td>
                                        <td class="VendorProductCode" style="white-space: nowrap; text-align: center;">Vendor <br />Product Code</td>
                                        <td class="ProductName" style="white-space: nowrap; text-align: center">Product Name</td>
                                        <td class="UnitType" style="white-space: nowrap; text-align: center">Unit Type</td>
                                        <td class="UnitAutoId" style="white-space: nowrap; text-align: center; display: none;">UnitAutoId</td>
                                        <td class="Quantity" style="white-space: nowrap; text-align: center">Quantity</td> 
                                         <td class="UnitPrice" style="white-space: nowrap; text-align: center">Cost Price (<span class="symbol"></span>)</td>
                                        <td class="Total" style="white-space: nowrap; text-align: center">Total (<span class="symbol"></span>)</td>
                                        <td class="Taxper" style="white-space: nowrap; text-align: center; display: none;">Taxper</td>
                                         <td class="CostPrice" style="white-space: nowrap; text-align: center">Previous <br />Cost Price (<span class="symbol"></span>)</td>
                                        <td class="UnitPrice1" style="width: 60px; white-space: nowrap; text-align: center">Selling<br /> Unit Price(<span class="symbol"></span>)</td>
                                        <td class="SecUnitPrice" style="width: 60px; white-space: nowrap; text-align: center">Secondary <br />Unit Price(<span class="symbol"></span>)</td>                                       
                                        <td class="ActionId" style="white-space: nowrap; text-align: center; display: none;">ActionId</td>
                                    </tr>
                                </thead>
                                <tbody id="tblPOListBody" class="tbody">
                                </tbody>
                                <tfoot id="tblPOListFoot">
                                    <tr class="tfoot">
                                        <td class="F_POTotal" colspan="4" style="white-space: nowrap; text-align: right"><b>Total</b></td>
                                        <td class="F_Qty" id="F_Qty" colspan="1" style="white-space: nowrap; text-align: center; font-weight: 900;">0</td>
                                        <td></td>
                                        <td class="F_GrandTotal"  colspan="1" style="white-space: nowrap; text-align: right; font-weight: 900;"><span class="symbol"></span><span id="F_GrandTotal">0.00</span></td>
                                    </tr>
                                </tfoot>
                            </table>
                            <h5 class="well text-center" id="ProductEmptyTable" style="display: none">No data available.</h5>
                        </div>
                        <hr />
                        <div class="modal fade" id="ModalProduct" role="dialog" data-backdrop="static" data-keyboard="false">
                            <div class="modal-dialog modal-dialog-centered actionb-p" role="document">
                                <div class="modal-content card-p">
                                    <div class="modal-header cardm-head">
                                        <h5 class="modal-title">Product - <span id="spnProductName"></span>
                                            <img src="../Images/del.png" class="del-btnp" id="CloseModal" onclick="CloseBarcode()" data-dismiss="modal" />
                                        </h5>
                                    </div>
                                    <div class="modal-body" style="padding: 15px 0 0 0;">
                                        <div class="row">
                                            <div class="col-lg-12 form-group ProductUnit">
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-lg-12 form-group text-center">
                                                <button type="button" class="cash-btn btn btn-primary" id="btnSubmit" onclick="SubmitUnit();">Submit</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                              <%--  <button type="button" id="btnBack" disabled="disabled" onclick="Reset()" style="margin-left: 10px;" class="btn btn-sm catreset-btn pull-right">Back</button>--%>
                                <button type="button" id="btnReset" onclick="Reset()" style="margin-left: 10px;" class="btn btn-sm catreset-btn pull-right">Reset</button>
                                <button type="button" id="btnSave" onclick="GenDirectInvoice()" class="btn btn-sm catsave-btn pull-right">Generate Invoice</button>
                                <button type="button" id="btnUpdate" disabled="disabled" onclick="UpdateDirectInvoice()" style="display: none;" class="btn btn-sm catsave-btn pull-right">Update</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>


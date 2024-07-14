<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="POMaster.aspx.cs" Inherits="Pages_POMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>Purchase Order
            <a href="/Pages/POList.aspx" class="btn btn-sm btn-warning pull-right">PO List</a>
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
                                <label>Vendor <span class="required">*</span></label>
                                <select id="ddlVendor" class="form-control input-sm">
                                    <option value="0">Select Vendor</option>
                                </select>
                            </div>
                            <div class="col-md-2  form-group">
                                <label>PO Date <span class="required">*</span></label>
                                <input type="text" id="txtDate" class="form-control input-sm date" readonly />
                            </div>
                            <div class="col-md-2  form-group">
                                <label>Status</label>
                                <select id="ddlStatus" class="form-control input-sm">
                                    <option value="1" selected="selected">Active</option>
                                    <option value="0">Inactive</option>
                                </select>
                            </div>
                            <div class="col-md-5  form-group">
                                <label>Remark </label>
                                <input type="text" id="txtRemark" class="form-control input-sm" placeholder="Enter Remark" maxlength="250" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-12">
                <div class="panel panel-default">
                    <div class="panel-heading" id="headingfirst">
                        <b>PO Item Details</b>
                    </div>
                    <div class="panel-body">
                        <div class="row" id="firstform">
                            <div class="col-md-3 form-group">
                                <label>Barcode</label>
                                <input type="text" id="txtBarcode" onpaste="var e=this; setTimeout(function(){FillProductByBarcode(e)}, 4);" class="form-control input-sm" maxlength="25" placeholder="Barcode" />
                            </div>
                            <div class="col-md-3 form-group">
                                <label>Vendor Product Code </label>
                                <input type="text" id="txtVProductCode" onchange="FillProduct(this);" onpaste="var e=this; setTimeout(function(){FillProduct(e)}, 4);" class="form-control input-sm" maxlength="25" onkeypress="return isNumberKey(this)" placeholder="Vendor Product Code" />
                            </div>
                            <div class="col-md-4  form-group">
                                <label>Product <span class="required">*</span></label>
                                <select id="ddlProduct" onchange="BindUnitList()" class="form-control input-sm">
                                    <option value="0">Select Product</option>
                                </select>
                            </div>
                            <div class="col-md-2  form-group">
                                <label>Unit Type <span class="required">*</span></label>
                                <select id="ddlUnitType" onchange="FillPrice();" class="form-control input-sm">
                                    <option value="0">Select Unit</option>
                                </select>
                            </div>
                        </div>
                        <div class="row" id="firstform2">
                            <div class="col-md-2 form-group">
                                <label style="white-space: nowrap;">Quantity <span class="required">*</span></label>
                                <input type="text" id="txtQuantity" style="text-align: center" class="form-control input-sm" maxlength="4" onkeypress="return isNumberKey(this)" placeholder="Enter Quantity" />
                            </div>
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
                                    <input type="text" id="txtUnitPrice1" placeholder="0.00" style="text-align: right" class="form-control input-sm" maxlength="4" onkeypress="return isNumberKey(this)" disabled="disabled" />
                                </div>
                            </div>
                            <div class="col-md-2  form-group">
                                <label>Secondary Unit Price </label>

                                <div class="input-group">
                                    <span class="input-group-addon input-sm symbol"></span>
                                    <input type="text" id="txtSecUnitPrice" placeholder="0.00" style="text-align: right" class="form-control input-sm" maxlength="4" onkeypress="return isNumberKey(this)" disabled="disabled" />
                                </div>
                            </div>
                            <div class="col-md-4 form-group">
                                <div class="pull-right">
                                    <button type="button" id="btnAdd" style="width: 100px; margin-top: 30px;" onclick="AddPoItem()" class="btn btn-sm btn-success">Add</button>
                                    <button type="button" id="btnUpdateList" style="width: 100px; margin-top: 30px; display: none" onclick="AddPoItem()" class="btn btn-sm btn-success">Update</button>
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
                                        <td class="PoItemAutoId" style="width: 50px; text-align: center; display: none;">PoItemAutoId</td>
                                        <td class="VendorProductCode" style="width: 150px; text-align: center;">Vendor Product Code</td>
                                        <td class="ProductAutoId" style="white-space: nowrap; text-align: center; display: none;">ProductAutoId</td>
                                        <td class="ProductName" style="white-space: nowrap; text-align: center">Product Name</td>
                                        <td class="UnitType" style="white-space: nowrap; text-align: center">Unit Type</td>
                                        <td class="UnitAutoId" style="white-space: nowrap; text-align: center; display: none;">UnitAutoId</td>
                                        <td class="Quantity" style="white-space: nowrap; text-align: center">Quantity</td>
                                        <td class="CostPrice" style="width: 60px; white-space: nowrap; text-align: center">Previous Cost Price(<span class="symbol"></span>)</td>
                                        <td class="UnitPrice" style="width: 60px; white-space: nowrap; text-align: center">Unit Price(<span class="symbol"></span>)</td>
                                        <td class="SecUnitPrice" style="width: 60px; white-space: nowrap; text-align: center">Sec. Unit Price(<span class="symbol"></span>)</td>
                                        <td class="ActionId" style="white-space: nowrap; text-align: center; display: none;">ActionId</td>
                                    </tr>
                                </thead>
                                <tbody id="tblPOListBody" class="tbody">
                                </tbody>
                                <tfoot id="tblPOListFoot">
                                    <tr class="tfoot">
                                        <td class="F_POTotal" colspan="4" style="white-space: nowrap; text-align: right"><b>Total</b></td>
                                        <td class="F_Qty" id="F_Qty" colspan="1" style="white-space: nowrap; text-align: center; font-weight: 900">0</td>
                                    </tr>
                                </tfoot>
                            </table>
                            <h5 class="well text-center" id="ProductEmptyTable" style="display: none">No data available.</h5>
                        </div>
                        <hr />
                        <div class="row">
                            <div class="col-md-12">
                                <button type="button" id="btnReset" onclick="ResetPO()" style="margin-left: 10px;" class="btn btn-sm catreset-btn pull-right">Reset</button>
                                <button type="button" id="btnSave" onclick="InsertPO()" class="btn btn-sm catsave-btn pull-right">Save</button>
                                <button type="button" id="btnUpdate" onclick="UpdatePO()" style="display: none;" class="btn btn-sm catsave-btn pull-right">Update</button>
                                <button type="button" id="btnInvGenerated" style="display: none;" disabled="disabled" class="btn btn-sm catsave-btn pull-right">Invoice Generated</button>
                            </div>
                        </div>

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
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>


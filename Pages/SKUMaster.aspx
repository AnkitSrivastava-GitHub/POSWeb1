<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="SKUMaster.aspx.cs" ClientIDMode="Static" Inherits="Pages_SKUMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server"> 
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>SKU Master
            <a href="/Pages/SKUList.aspx" class="btn btn-sm btn-success pull-right">SKU List</a>
        </h1>
    </section>
    <div class="content" id="divForm" ondragstart="return false;" ondrop="return false;">
        <div class="row">
            <div class="col-md-6">
                <input type="hidden" id="hdnBrandId" />
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <b>SKU Details</b>
                    </div>
                    <div class="panel-body" id="panelStoreDetail">
                        <div class="row">
                            <label class="col-md-3 form-group">
                                SKU Name<span class="required"> *</span>
                            </label>
                            <div class="col-md-9 form-group">
                                <input type="text" id="txtSKUName" maxlength="100" class="form-control input-sm" placeholder="Enter SKU Name" />
                            </div>
                        </div>
                        <div class="row">
                            <label class="col-md-3 form-group">
                                Status
                            </label>
                            <div class="col-md-9 form-group">
                                <select id="ddlStatus" class="form-control input-sm">
                                    <option value="1">Active</option>
                                    <option value="0">Inactive</option>
                                </select>
                            </div>
                        </div>
                        <div class="row">
                            <label class="col-md-3 form-group">
                                Description
                            </label>
                            <div class="col-md-9 form-group">
                                <textarea id="txtDescription" maxlength="400" style="min-width: 431px; min-height: 92px;max-width: 431px; max-height: 92px;" rows="3" class="form-control input-sm"></textarea>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <b>Barcode List</b>
                    </div>
                    <div class="panel-body">

                        <div class="row">
                            <div class="col-md-9">
                                <input type="text" id="txtBarcode" maxlength="50" class="form-control input-sm" style="text-transform: uppercase;" placeholder="Enter Barcode" />
                            </div>
                            <div class="col-md-3">
                                <button id="btnSearch" type="button" onclick="this.disabled = true;AddBarcodeInTable(this);" class="btn btn-sm btn-success pull-right">Add</button>
                            </div>
                        </div>
                        <div class="form-group"></div>
                        <div class="table-responsive" style="height: 136px; overflow-y: auto;">
                            <table id="tblBarcodeList" class="table table-striped table-bordered well">
                                <thead style="position: sticky; top: 0px;">
                                    <tr class="thead">
                                        <td class="Action" style="width: 50px; text-align: center">Action</td>
                                        <td class="BarcodeAutoId" style="white-space: nowrap; text-align: center; display: none;">BarcodeAutoId</td>
                                        <td class="Barcode" style="white-space: nowrap; text-align: center">Barcode</td>
                                        <td class="ActionId" style="white-space: nowrap; text-align: center; display: none;">ActionId</td>
                                    </tr>
                                </thead>
                                <tbody id="tblBarcodeListBody" class="tbody">
                                </tbody>
                            </table>
                            <h5 class="well text-center" id="EmptyTable" style="display: none">No data available.</h5>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <b>Upload Image</b>
                    </div>
                    <div class="panel-body" style="height: 202px;">
                        <div class="row">
                            <div class="col-md-12">
                                <input type="file" id="FuSKUImage" runat="server" onchange="LoadImage(this);" class="form-control">
                            </div>
                        </div>
                        <div class="row" id="divimgPreview" style="margin-top: 5px; text-align: center;">
                            <div class="col-md-12">
                                <img src="../Images/ProductImages/product.png" class="imagePreview border-primary" id="imgPreview" width="120" height="120" />
                                <input type="hidden" id="imgPath" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <p id="txtextention" style="text-align: center;" class="required">.png, .jpg, .jpeg, .gif, .bmp</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-12">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <b>Product List</b>
                    </div>
                    <div class="panel-body">
                        <div class="row">
                            <div class="col-md-3 form-group">
                                <label>Product<span class="required"> *</span></label>
<%--                                <input id="txtProductAutoFill" onkeypress="Add();" onchange="Add();"  class="ui-autocomplete-input ui-autocomplete-loading" autocomplete="on"  />--%>
                                <select id="ddlProduct" onchange="BindUnitList()" class="form-control input-sm">
                                    <option value="0">Select Product</option>
                                </select>
                            </div>
                            <div class="col-md-3 form-group">
                                <label>Unit<span class="required"> *</span></label>
                                <select id="ddlProductUnit" onchange=" FillProductDetails()" class="form-control input-sm">
                                    <option value="0">Select Unit</option>
                                </select>
                            </div>
                            <div class="col-md-2 form-group">
                                <label>Quantity<span class="required"> *</span></label>
                                <div class="input-group">
                                    <span class="input-group-addon input-sm" onclick="decreaseValueSKU(this)"><strong>-</strong></span>
                                    <input type="text" onfocus="this.select()" id="txtQuantity" style="text-align: center;" onchange="ChangeValueSKU(this)" onkeypress="return isNumberKey(event)"
                                        class="form-control input-sm" value="1" maxlength="4" placeholder="Quantity" />
                                    <span class="input-group-addon input-sm" onclick="increaseValueSKU(this)"><strong>+</strong></span>
                                </div>
                            </div>
                            <div class="col-md-2 form-group">
                                <label>Tax Percentage</label>
                                <div class="input-group">
                                    <input type="text" id="txtTaxPerUnit" style="text-align: right" value="0.000" readonly onkeypress="return isNumberDecimalKey(event,this)" class="form-control input-sm" placeholder="0.000" />
                                    <span class="input-group-addon input-sm"><strong>%</strong></span>
                                </div>
                            </div>
                            <div class="col-md-2 form-group">
                                <label>Total Tax</label>
                                <div class="input-group">
                                    <span class="input-group-addon input-sm symbol"></span>
                                    <input type="text" id="txtTotalTax" style="text-align: right" value="0.00" readonly onkeypress="return isNumberDecimalKey(event,this)" class="form-control input-sm" placeholder="0.00" />
                                    <input type="hidden" id="txtTaxAutoId" />
                                    <input type="hidden" id="txtUnitTax" value="0.00" />

                                </div>
                            </div>

                        </div>
                        <div class="row" style="margin-bottom: 10px;">
                            <div class="col-md-2 form-group">
                                <label>Unit Price<span class="required"> *</span></label>
                                <div class="input-group">
                                    <span class="input-group-addon input-sm symbol"></span>
                                    <input type="text" id="txtUnitPrice" onkeypress="return isNumberDecimalKey(event,this)" value="0.00" style="text-align: right" class="form-control input-sm" readonly placeholder="0.00" />
                                </div>
                            </div>
                            <div class="col-md-2 form-group">
                                <label>Discount/Unit (<span class="symbol"></span>)</label>
                                <div class="input-group">
                                    <span class="input-group-addon input-sm symbol"></span>
                                    <input type="text" id="txtDiscount" onfocus="this.select()" onchange="return IsValidDecimal(this),calculate_total('Amount');" onpaste="return false" onkeypress="return isNumberDecimalKey(event,this)" style="text-align: right" maxlength="8" class="form-control input-sm" value="0.00" placeholder="0.00" autofill="0.00" />
                                </div>
                            </div>
                            <div class="col-md-2 form-group">
                                <label>Discount/Unit (%)</label>
                                <div class="input-group">
                                    <input type="text" id="txtDiscountPer" onfocus="this.select()" onchange="return IsValidDecimal(this),calculate_total('Percentage');" onpaste="return false" onkeypress="return isNumberDecimalKey(event,this)" style="text-align: right" maxlength="8" class="form-control input-sm" value="0.00" placeholder="0.00" autofill="0.00" />
                                    <span class="input-group-addon input-sm"><strong>%</strong></span>
                                </div>
                            </div>
                            
                            
                            <div class="col-md-2 form-group">
                                <label>Grand Total</label>
                                <div class="input-group">
                                    <span class="input-group-addon input-sm inputsmgenerateinvoive symbol"></span>
                                    <input type="text" id="txtTotal"  style="text-align: right" value="0.00" onkeypress="return isNumberDecimalKey(event,this)" readonly class="form-control input-sm" placeholder="0.00" />
                                </div>
                            </div>
                            <div class="col-md-4 form-group" style="text-align: right;">
                                <button type="button" id="btnAddProduct" style="margin-top: 25px;" onclick="AddProductInTable();" class="btn btn-sm btn-success">Add</button>
                                <button type="button" id="btnUpdateProduct" style="margin-top: 25px; display: none;" onclick="updateProductInTable();" class="btn btn-sm btn-success">Update</button>
                                <button type="button" id="btnUpdateProduct1" style="margin-top: 25px; display: none;" onclick="updateProductInTable1();" class="btn btn-sm btn-success">Update</button>
                            </div>
                        </div>
                        <div class="table-responsive">
                            <table id="tblProductList" class="table table-striped table-bordered well">
                                <thead>
                                    <tr class="thead">
                                        <td class="Action" style="width: 50px; text-align: center;">Action</td>
                                        <td class="SKUItemAutoId" style="white-space: nowrap; text-align: center; display: none;">SKUItemAutoId</td>
                                        <td class="ProductId" style="white-space: nowrap; text-align: center; display: none;">ProductId</td>
                                        <td class="ProductName" style="white-space: nowrap; text-align: center">Product Name</td>
                                        <td class="Unit" style="white-space: nowrap; text-align: center">Unit</td>
                                        <td class="UnitAutoId" style="white-space: nowrap; text-align: center; display: none;">UnitAutoId</td>
                                        <td class="Quantity" style="white-space: nowrap; text-align: center">Quantity</td>
                                        <td class="UnitPrice" style="white-space: nowrap; text-align: center;">Unit Price (<span class="symbol"></span>)</td>
                                        <td class="TotalDiscount" style="white-space: nowrap; text-align: center">Discount (<span class="symbol"></span>)</td>
                                        <td class="DiscountPer" style="white-space: nowrap; text-align: center">Discount (%)</td>
                                        <td class="Discount" style="white-space: nowrap; text-align: center; display: none;">DiscountPerUnit</td>
                                        <td class="Tax" style="white-space: nowrap; text-align: center">Tax (<span class="symbol"></span>)</td>
                                        <td class="TaxPercentagePerUnit" style="white-space: nowrap; text-align: center; display: none;">TaxPercentagePerUnit</td>
                                        <td class="TaxAutoId" style="white-space: nowrap; align-content: center; display: none;">TaxAutoId</td>
                                        <td class="Total" style="white-space: nowrap; text-align: center;">Total (<span class="symbol"></span>)</td>
                                        <td class="ActionId" style="white-space: nowrap; text-align: center; display: none;">ActionId</td>
                                    </tr>
                                </thead>
                                <tbody id="tblProductListBody" class="tbody">
                                </tbody>
                                <tfoot id="tblProductListFoot">
                                    <tr class="tfoot">
                                        <td class="F_SKUTotal" colspan="7" style="white-space: nowrap; text-align: right"><b>Total</b></td>
                                        <td class="F_Discount" id="F_Discount" colspan="1" style="white-space: nowrap; text-align: right; display: none">0.00</td>
                                        <td class="F_Tax" id="F_Tax" colspan="1" style="white-space: nowrap; text-align: right; font-weight: 900">0.00</td>
                                        <td class="F_Total" id="F_Total" colspan="1" style="white-space: nowrap; text-align: right; font-weight: 900">0.00</td>
                                    </tr>
                                </tfoot>
                            </table>
                            <h5 class="well text-center" id="ProductEmptyTable" style="display: none">No data available.</h5>
                        </div>
                        <hr />
                        <div class="row">
                            <div class="col-md-12 form-group">
                                <div class="pull-right">
                                    <button type="button" id="btnSave" onclick="this.disabled=true;InsertSKU(this);" class="btn btn-sm catsave-btn">Save</button>
                                    <button type="button" id="btnUpdate" onclick="UpdateSKU();" class="btn btn-sm catsave-btn" style="display: none">Update</button>
                                    <button type="button" id="btnReset" onclick="ResetSKUDetails()" class="btn btn-sm catreset-btn">Reset</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>


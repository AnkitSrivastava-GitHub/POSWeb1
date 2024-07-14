<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" ClientIDMode="Static" CodeFile="ProductMaster.aspx.cs" Inherits="Pages_ProductMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style>
        /*button{
            font-size:14px !important;
            font-weight:700 !important;
        }
        a{
            font-size:14px !important;
            font-weight:700 !important;   
        }*/
        
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>Product Master
            <a href="/Pages/ProductList.aspx" class="btn btn-sm btn-warning pull-right">Product List</a>
        </h1>
        <input type="hidden" id="hdnProductId" />
        <input type="hidden" id="hdnimage" />
    </section>
    <div class="content" id="divForm" ondragstart="return false;" ondrop="return false;">
        <div class="row">
            <div class="col-md-12">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <b>Product Details </b>
                    </div>
                    <div class="panel-body">
                        <div class="row">
                            <div class="col-md-9">
                                <div class="row">
                                    <div class="col-md-4 form-group">
                                        <div class="row">
                                            <label class="col-md-4 form-group">
                                                Department
                                            </label>
                                            <div class="col-md-8 form-group">
                                                <select id="ddlDept" runat="server" onchange="BindAgeRestriction()" class="form-control input-sm">
                                                    <option value="0">Select Department</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-4 form-group">
                                        <div class="row">
                                            <label class="col-md-4 form-group">
                                                Category
                                            </label>
                                            <div class="col-md-8 form-group">
                                                <select id="ddlcategory" class="form-control input-sm">
                                                    <option value="0">Select Catgory</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-4 form-group">
                                        <div class="row">
                                            <label class="col-md-4 form-group">
                                                Brand
                                            </label>
                                            <div class="col-md-8  form-group">
                                                <select id="ddlbrand" class="form-control input-sm">
                                                    <option value="0">Select Brand</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <label class="col-md-2 form-group" style="white-space: nowrap">
                                        Age Restriction
                                    </label>
                                    <div class="col-md-4 form-group">
                                        <select id="ddlAgeRestriction" style="padding-top: 2px;" class="form-control input-sm">
                                            <option value="0">Select Age Restriction</option>
                                        </select>
                                    </div>
                                    <label class="col-md-2 form-group" style="white-space: nowrap">
                                        Product Short Name
                                    </label>
                                    <div class="col-md-4 form-group">
                                        <input id="txtProductShortName" maxlength="25" class="form-control input-sm" />
                                    </div>
                                    <div style="display: none;">
                                        <label class="col-md-2 form-group" style="white-space: nowrap">
                                            Product Group
                                        </label>
                                        <div class="col-md-4 form-group">
                                            <select id="ddlGroup" style="padding-top: 2px;" class="form-control input-sm">
                                                <option value="0">Select Group</option>
                                            </select>
                                        </div>
                                    </div>

                                </div>
                                <div class="row">
                                </div>

                                <div class="row">
                                    <label class="col-md-2 form-group" style="white-space: nowrap;">
                                        Product Name<span class="required"> *</span>
                                    </label>
                                    <div class="col-md-10 form-group">
                                        <input type="text" id="txtProductName" maxlength="75" class="form-control input-sm" placeholder="Product Name" />
<%--                                        <input type="text" id="txtProductName" onkeypress="return /[0-9a-zA-Z ]/i.test(event.key)" maxlength="200" class="form-control input-sm" placeholder="Product Name" />--%>
                                    </div>
                                </div>
                                <div class="row">
                                    <label class="col-md-2 form-group">
                                        Description
                                    </label>
                                    <div class="col-md-10 form-group">
                                        <input type="text" maxlength="500" class="form-control input-sm" id="txtDescription" placeholder="Enter Description" />
                                        <%-- <textarea class="form-control input-sm" rows="1" id="txtDescription"></textarea>--%>
                                    </div>
                                </div>
                                <div class="row">
                                    <label class="col-md-2 form-group">
                                        Product QTY<span class="required"> *</span>
                                    </label>
                                    <div class="col-md-2 form-group">
                                        <input type="text" id="txtProductSize" oninput="process(this)" autocomplete="off" class="form-control input-sm" maxlength="5" onchange="return IsValidDecimal(this);" onkeypress="return isNumberDecimalKey(event,this)" placeholder="e.g. 750" />
                                    </div>
                                    <%--<label class="col-md-2 form-group">
                                        Product Size
                                    </label>--%>
                                    <div class="col-md-2 form-group">
                                        <select id="ddlMeasureUnit" style="width: 160px" class="form-control">
                                            <%--<option value="0">Product Size</option>--%>
                                            <%--<option value="Litre">Litre</option>
                                            <option value="Gallon">Gallon</option>--%>
                                        </select>
                                    </div>

                                </div>
                                <%--<div class="row">
                                </div>--%>

                                <div class="row">
                                    <label class="col-md-2  form-group">Tax</label>
                                    <div class="col-md-2  form-group">
                                        <select id="ddltax" class="form-control input-sm">
                                            <option value="0">Select Tax</option>
                                        </select>
                                    </div>
                                    <%--<label class="col-md-1  form-group text-nowrap">Barcode<span class="required"> *</span></label>
                                    <div class="col-md-3  form-group">
                                        <input type="text" id="txtbarcode" onkeypress="return alpha(event)" class="form-control input-sm" onchange="IsDuplicateBarcode(this)" placeholder="Barcode" />
                                    </div>--%>
                                    <%-- <div style="display: none">
                                        <label class="col-md-2  form-group text-nowrap">Size Of Single Piece <span class="required">*</span></label>
                                        <div class="col-md-3  form-group">
                                            <input type="text" id="txtPieceSize" onselectstart="return false" oncut="return false" oncopy="return false" onpaste="return false" ondrag="return false" ondrop="return false" class="form-control input-sm" placeholder="Size of single Piece" />
                                        </div>
                                    </div>--%>
                                    <div style="display: none">
                                        <label class="col-md-2 form-group text-nowrap">Available on Web ?</label>
                                        <div class="col-md-2  form-group">
                                            <select id="ddlWebAvailability" class="form-control input-sm">
                                                <option value="Yes">Yes</option>
                                                <option value="No" selected="selected">No</option>
                                            </select>
                                        </div>
                                    </div>

                                    <label class="col-md-1 form-group">
                                        Status
                                    </label>
                                    <div class="col-md-2 form-group">
                                        <select id="ddlStatus" class="form-control input-sm">
                                            <option value="1">Active</option>
                                            <option value="0">Inactive</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="row">
                                    <label class="col-md-2 form-group">
                                        Allow Sell Without Stock
                                    </label>
                                    <div class="col-md-2 form-group">
                                        <select id="ddlManageStock" class="form-control input-sm" onchange="ManageStock()">
                                            <option value="1">No</option>
                                            <option value="0" selected="selected">Yes</option>
                                        </select>
                                    </div>

                                    <div class="ManageStock" style="display: none">
                                        <label class="col-md-2  form-group" style="white-space: nowrap;">
                                            Current Stock QTY <span class="required">*</span>
                                        </label>
                                        <div class="col-md-2 form-group">
                                            <input type="text" onselectstart="return false" maxlength="5" oncut="return false" oncopy="return false" onpaste="return false" ondrag="return false" ondrop="return false" id="txtInStock" class="form-control input-sm text-right" placeholder="In Stock" value="0" onchange="return IsValidInteger(this);" onkeypress="return event.charCode >= 48 &amp;&amp; event.charCode <= 57" />
                                        </div>
                                    </div>
                                    <div class="ManageStock" style="display: none">
                                        <label class="col-md-2  form-group">
                                            Alert Stock QTY <%--<span class="required">*</span>--%>
                                        </label>
                                        <div class="col-md-2 form-group">
                                            <input type="text" id="txtLowStock" maxlength="5" class="form-control input-sm text-right" onblur="CheckOpenStock(this);" onkeyup="CheckOpenStock(this);" onselectstart="return false" oncut="return false" oncopy="return false" onpaste="return false" ondrag="return false" ondrop="return false" placeholder="Low Stock" value="0" onchange="return IsValidInteger(this); CheckOpenStock(this);" onkeypress="return event.charCode >= 48 &amp;&amp; event.charCode <= 57" />
                                        </div>
                                    </div>
                                </div>
                                <%--<div class="row">
                                    <div class="ManageStatus">
                                        <label class="col-md-1 form-group">Status</label>
                                        <div class="col-md-2 form-group">
                                            <select id="ddlStatuspacking" class="form-control input-sm">
                                                <option value="1">Active</option>
                                                <option value="0">Inactive</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>--%>
                            </div>

                            <div class="col-md-3">
                                <div class="row">
                                    <div class="col-md-12" style="text-align: center;">
                                        <img src="../Images/ProductImages/product.png" onerror="this.onerror=null;this.src='/Images/ProductImages/product.png';" class="imagePreview border-primary" id="imgPreview" width="170" height="170" style="margin-bottom: 10px; border-radius: 0px" />
                                        <input type="hidden" id="imgPath" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-12 form-group">
                                        <input type="file" class="form-control" id="filePhoto" runat="server" onchange="readURL(this);" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-12 form-group" style="text-align: center">
                                        <span id="txtextention" class="required">.png, .jpg, .jpeg, .gif, .bmp</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="panel-footer" id="divupdate" style="display: none">
                        <div class="row">
                            <div class="col-md-12">
                                <div class="pull-right">
                                    <button type="button" id="btnUpdate" onclick="UpdateProduct();" class="btn btn-sm catsave-btn" style="display: none">Update</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <input id="hdnBarcodeForEdit" type="hidden" />
                    <div class="panel-heading">
                        <b>Add Barcode and Packing Details</b>
                    </div>
                    <div class="panel-body" style="">
                        <div class="col-md-3">
                            <div class="row">
                                <div class="col-md-9">
                                    <label>Barcode <span class="required">*</span></label>
                                    <input type="text" id="txtBarcode" onpaste="var e=this;setTimeout(function(){PreventOnPaste(e)}, 4);" style="text-transform: uppercase;" maxlength="25" class="form-control input-sm" placeholder="Enter Barcode" />
                                </div>
                                <div class="col-md-3" style="margin-top: 30px">
                                    <button id="btnAddBarcode" type="button" onclick="this.disabled=true;IsDuplicateBarcode()" class="btn btn-sm btn-success pull-right">Add</button>
                                    <button id="btnAddBarcode1" type="button" onclick="AddBarcodeInDB()" style="display: none" class="btn btn-sm btn-success pull-right">Add</button>
                                    <button id="btnBarcodeUpdate" type="button" onclick="UpdateBarcodeInTable()" style="display: none" class="btn btn-sm btn-success pull-right">Update</button>
                                    <button id="btnBarcodeUpdate1" type="button" onclick="UpdateBarcodeInTable1()" style="display: none" class="btn btn-sm btn-success pull-right">update</button>
                                </div>
                            </div>
                            <div class="form-group"></div>
                            <div class="table-responsive" <%--style="height: 136px; overflow-y: auto;"--%>>
                                <table id="tblBarcodeList" class="table table-striped table-bordered well">
                                    <thead style="position: sticky; top: 0px;">
                                        <tr class="thead">
                                            <td class="Action" style="text-align: center">Action</td>
                                            <td class="BarcodeAutoId" style="white-space: nowrap; text-align: center; display: none;">BarcodeAutoId</td>
                                            <td class="Barcode" style="white-space: nowrap; text-align: center">Barcode</td>
                                            <td class="ActionId" style="white-space: nowrap; text-align: center; display: none;">ActionId</td>
                                        </tr>
                                    </thead>
                                    <tbody id="tblBarcodeListBody" class="tbody">
                                    </tbody>
                                </table>
                                <h5 class="well text-center" id="BarcodeEmptyTable" style="display: none">No data available.</h5>
                            </div>
                            <div class="row" style="display: none;">
                                <div class="col-md-12" style="text-align: center; margin-bottom: 5px">
                                    <img src="../Images/ProductImages/product.png" class="imagePreview1 border-primary" onerror="this.onerror=null;this.src='/Images/ProductImages/product.png';" style="border-radius: 0px;" id="PackingimgPreview" width="90" height="90" />
                                    <input type="hidden" id="PackingimgPath" />
                                </div>
                            </div>
                            <div class="row" style="display: none;">
                                <div class="col-md-12 form-group text-nowrap" style="text-align: center">
                                    <p style="margin: 0 0 0px;">(<span id="txtPackingextention" class="required">.png, .jpg, .jpeg, .gif, .bmp</span>)</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-9">
                            <div class="row">
                                <div class="col-md-3  form-group" style="display: none;">
                                    <label>Packing Name<span class="required">*</span></label>
                                    <input type="text" id="txtPackingName" class="form-control input-sm" placeholder="Packing Name" />
                                    <input type="hidden" id="lblpackingautoid" />
                                </div>
                                <div class="col-md-2  form-group">
                                    <label>No. of Pieces <span class="required">*</span></label>
                                    <input type="text" id="txtNoOfPieces" onclick="this.select();" maxlength="4" onselectstart="return false" oncut="return false" oncopy="return false" onpaste="return false" ondrag="return false" ondrop="return false" class="form-control input-sm text-center" placeholder="No. of Pieces" value="0" onchange="return IsValidInteger(this);" onkeypress="return isNumberKey(event)" />
                                </div>
                                <div class="col-md-2  form-group">
                                    <label>Cost Price</label>
                                    <div class="input-group">
                                        <span class="input-group-addon input-sm symbol"></span>
                                        <input type="text" id="txtCostPrice" maxlength="9" onclick="this.select();" onselectstart="return false" oncut="return false" oncopy="return false" onpaste="return false" ondrag="return false" ondrop="return false" class="form-control input-sm text-right" placeholder="Cost Price" value="0.00" onchange="return IsValidDecimal(this);" onkeypress="return isNumberDecimalKey(event,this)" />
                                    </div>
                                </div>
                                <div class="col-md-3 form-group">
                                    <label>Unit Price <span class="required">*</span></label>
                                    <div class="input-group">
                                        <span class="input-group-addon input-sm symbol"></span>
                                        <input type="text" id="txtSellingPrice" onclick="this.select();" onselectstart="return false" oncut="return false" oncopy="return false" onpaste="return false" ondrag="return false" ondrop="return false" class="form-control input-sm text-right" maxlength="9" placeholder="Unit Price" value="0.00" onchange="fillsecondPrice(this);" onkeypress="return isNumberDecimalKey(event,this)" />
                                    </div>
                                </div>
                                <div class="col-md-3 form-group">
                                    <label class="text-nowrap">Secondary Unit Price <span class="required">*</span></label>
                                    <div class="input-group">
                                        <span class="input-group-addon input-sm symbol"></span>
                                        <input type="text" id="txtSecondaryUnitPrice" onclick="this.select();" onselectstart="return false" oncut="return false" oncopy="return false" onpaste="return false" ondrag="return false" ondrop="return false" class="form-control input-sm text-right" maxlength="9" placeholder="Secondary Unit Price" value="0.00" onchange="return IsValidDecimal(this);" onkeypress="return isNumberDecimalKey(event,this)" />
                                    </div>
                                </div>
                                <div class="col-md-2 form-group">
                                    <label>Status</label>
                                    <select id="ddlStatuspacking" class="form-control input-sm">
                                        <option value="1" selected="selected">Active</option>
                                        <option value="0">Inactive</option>
                                    </select>
                                </div>
                                <div class="col-md-3 form-group pull-right text-right text-nowrap" style="margin-top: 0px">
                                    <button id="btnAddPacking" style="display: none" type="button" onclick="AddPacking();" class="btn btn-sm btn-success">Add Packing</button>
                                    <button id="btnUpdatePacking" style="display: none" type="button" onclick="UpdatePacking();" class="btn btn-sm btn-success">Update Packing</button>
                                    <button id="btnUpdatePacking1" style="display: none" type="button" onclick="UpdatePacking1();" class="btn btn-sm btn-success">Update Packing</button>
                                    <button id="btnInsertPacking" type="button" onclick="InsertPacking();" class="btn btn-sm btn-success">Add Packing</button>
                                    <button type="button" onclick="ResetPacking();" class="btn btn-sm catreset-btn">Reset</button>
                                </div>
                                <%-- <div class="col-md-2 form-group ManageStatus">
                                    <label>Status</label>
                                    <select id="ddlStatuspacking" class="form-control input-sm">
                                        <option value="1">Active</option>
                                        <option value="0">Inactive</option>
                                    </select>
                                </div>--%>
                            </div>
                            <div class="row">
                                <%--<div class="col-md-2  form-group">
                                    <label>Tax</label>
                                    <select id="ddltax" class="form-control input-sm">
                                        <option value="0">Select Tax</option>
                                    </select>
                                </div>

                                <div class="col-md-2  form-group">
                                    <label>Barcode<span class="required"> *</span></label>
                                    <input type="text" id="txtbarcode" onkeypress="return alpha(event)" class="form-control input-sm" onchange="IsDuplicateBarcode(this)" placeholder="Barcode" />
                                </div>
                                <div class="col-md-3 form-group">
                                    <label>Choose Packing Image</label>
                                    <input type="file" id="F_UnitImage" runat="server" onchange="readURL1(this);" class="form-control" />
                                </div>
                                <div class="col-md-2  form-group" style="display: none">
                                    <label>Size Of Single Piece <span class="required">*</span></label>
                                    <input type="text" id="txtPieceSize" onselectstart="return false" oncut="return false" oncopy="return false" onpaste="return false" ondrag="return false" ondrop="return false" class="form-control input-sm" placeholder="Size of single Piece" />
                                </div>
                                <div class="col-md-2  form-group">
                                    <label>Available on Web ?</label>
                                    <select id="ddlWebAvailability" class="form-control input-sm">
                                        <option value="Yes">Yes</option>
                                        <option value="No">No</option>
                                    </select>
                                </div>
                                <div class="col-md-2 form-group ManageStatus">
                                    <label>Status</label>
                                    <select id="ddlStatuspacking" class="form-control input-sm">
                                        <option value="1">Active</option>
                                        <option value="0">Inactive</option>
                                    </select>
                                </div>--%>
                            </div>
                            <div class="row">
                            </div>
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="table-responsive">
                                        <table id="tblPackingList" class="table table-striped table-bordered well">
                                            <thead>
                                                <tr class="thead">
                                                    <td class="Action" style="text-align: center; width: 50px;">Action</td>
                                                    <td class="Packing" style="text-align: center; width: 150px; display: none;">Packing Name</td>
                                                    <td class="NoOfPieces" style="text-align: center; width: 120px;">No. of Pieces</td>
                                                    <%--  <td class="Barcode" style="text-align: center; display: none;">Barcode</td>--%>
                                                    <td class="CP" style="text-align: center; width: 120px; ">Cost Price (<span class="symbol"></span>)</td>
                                                    <td class="SP" style="text-align: center; width: 120px;">Unit Price (<span class="symbol"></span>)</td>
                                                    <td class="SecondaryUnitPrice" style="text-align: center; width: 170px;">Secondary Unit Price (<span class="symbol"></span>)</td>
                                                    <%--<td class="TaxId" style="display: none">TaxId</td>
                                                    <td class="Tax" style="text-align: center; width: 120px; display: none">Tax</td>
                                                    <td class="WebAvailability" style="text-align: center; width: 120px; display: none">Available
                                                    <br />
                                                        on Web ?</td>
                                                    <td class="PreviewImage" style="text-align: center; width: 120px; display: none">Preview Image</td>
                                                    <td class="ImageName" style="text-align: center; width: 120px; display: none; display: none">Image Name</td>--%>
                                                    <td class="Status" style="text-align: center; width: 120px;">Status</td>
                                                </tr>
                                            </thead>
                                            <tbody>
                                            </tbody>
                                        </table>
                                        <h5 class="well text-center" id="EmptyTable" style="display: none">No Packing available.</h5>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="panel-heading">
                        <b>Vendor Product Details</b>
                    </div>
                    <div class="panel-body" style="">
                        <div class="col-md-7">
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="row">
                                        <div class="col-md-6 form-group">
                                            <select id="ddlVendor" class="form-control input-sm">
                                                <option value="0">Select Vendor</option>
                                            </select>
                                        </div>
                                        <div class="col-md-4  form-group">
                                            <input type="text" id="txtVenProductCode" maxlength="15" onkeypress="return numberonly(this)" class="form-control input-sm" placeholder="Vendor Product Code" />
                                        </div>
                                        <div class="col-md-2  form-group text-right">
                                            <button type="button" id="btnAddVendor" onclick="AddVendorInTable()" class="btn btn-sm btn-success pull-right">Add</button>
                                            <button type="button" id="btnUpdateVendor" style="display: none;" onclick="" class="btn btn-sm btn-success">Update</button>
                                            <button type="button" id="btnAddVendor1" style="display: none;" onclick="AddVendorInDB()" class="btn btn-sm btn-success">Add</button>
                                            <button type="button" id="btnUpdateVendor1" style="display: none;" onclick="UpdateVendorInDB()" class="btn btn-sm btn-success">Update</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="table-responsive">
                                        <table id="tblVendorProductList" class="table table-striped table-bordered well">
                                            <thead>
                                                <tr class="thead" style="background-color: #70e46c;">
                                                    <td class="Action" style="text-align: center; width: 50px;">Action</td>
                                                    <td class="VendorId" style="text-align: center; width: 150px; display: none;">VendorId</td>
                                                    <td class="VendorName" style="text-align: center;">Vendor Name</td>
                                                    <td class="VendorProductCode" style="text-align: center;">Vendor Product Code</td>
                                                </tr>
                                            </thead>
                                            <tbody>
                                            </tbody>
                                        </table>
                                        <h5 class="well text-center" style="display: none">No Packing available.</h5>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-5" id="DivStoreListHead">
                            <div class="row col-md-12">
                                <strong>Select Store<span class="required"> *</span> :</strong>
                            </div>
                            <div class="row" id="DivStoreList">
                                <%--<div class="col-md-6">
                                    
                                </div>--%>
                            </div>
                        </div>
                    </div>

                    <%--<div class="panel-heading">
                        <b>Add Product Packing Detail</b>
                    </div>
                    <div class="panel-body">
                       
                    </div>--%>


                    <div class="panel-footer">
                        <div class="row">
                            <div class="col-md-12">
                                <div class="pull-right">
                                    <button type="button" id="btnSave" onclick="this.disabled=true;InsertProduct();" class="btn btn-sm catsave-btn">Save</button>
                                    <button type="button" id="btnReset" onclick="Reset();" class="btn btn-sm catreset-btn">Reset</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="ModalPackingImage" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-dialog-centered" style="width: 600px !important;" role="document">
            <div class="modal-content card-p">
                <div class="modal-header cardm-head">
                    <h5 class="modal-title">Packing Image
                        <img src="../Images/del.png" class="del-btnp" onclick="ClosePackingImageModal()" />
                    </h5>
                </div>
                <div class="modal-body" style="padding-left: 0px; padding-right: 0px;">
                    <div class="row">
                        <div class="col-md-12 text-center">
                            <img id="imgPackingImage" src="#" class="image" style="height: 80%; width: 80%; border-radius: 0px !important">
                        </div>
                    </div>
                </div>
                <div class="modal-footer text-center" style="text-align: center">
                    <%--<button type="button" class="btn btn-sm btn-danger" style="width: 100px" onclick="CloseCardTypeModal()">BACK</button>
                    <button type="button" class="btn btn-sm btn-success" style="width: 100px" onclick="CreditcardPay()">PAY</button>--%>
                </div>
            </div>
        </div>
    </div>
</asp:Content>


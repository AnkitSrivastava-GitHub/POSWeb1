<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="ProductGroup.aspx.cs" Inherits="Pages_ProductGroup" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>Product Group Master
            <a href="/Pages/MixNMatchList.aspx" class="btn btn-sm btn-success pull-right">Group List</a>
        </h1>
    </section>
    <div class="content" id="divForm" ondragstart="return false;" ondrop="return false;">
        <div class="row">
            <div class="col-md-12">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <b>Product Group Master</b>
                    </div>
                    <div class="panel-body">
                        <div class="row">
                            <div class="col-md-4 form-group">
                                <label>Group Name<span class="required"> *</span></label>
                                <input type="text" id="txtGroupName" class="form-control input-sm" placeholder="Enter Group Name" />
                            </div>
                            <div class="col-md-2 form-group">
                                <label>Minimum Quantity<span class="required"> *</span></label>
                                <div class="input-group">
                                    <span class="input-group-addon input-sm" onclick="decreaseValueSKU(this);"><strong>-</strong></span>
                                    <input type="text" id="txtQuantity" style="text-align: center;" oncopy="return false" onpaste="return false" oncut="return false"
                                        onchange="ChangeValueSKU(this)" onclick="this.select();" onkeypress="return isNumberKey(event)" class="form-control input-sm" value="1"
                                        placeholder="Enter Quantity" maxlength="5" />
                                    <span class="input-group-addon input-sm" onclick="increaseValueSKU(this)"><strong>+</strong></span>
                                </div>
                            </div>
                            <div class="col-md-2 form-group">
                                <label>Select Discount Type <span class="required">*</span></label>
                                <select id="ddlDiscountCriteria" onchange="ShowDiscountTextBox()" class="form-control input-sm">
                                    <option value="0">Select</option>
                                    <%--<option value="DiscountInAmount">Discount In Amount</option>
                                    <option value="DiscountInPercentage">Discount In Percentage</option>
                                    <option value="FixedPrice">Fixed Price</option>--%>
                                </select>
                            </div>
                            <div class="col-md-2 form-group" id="DivDiscountAmount" style="display: none">
                                <label>Discount Amount<span class="required"> *</span></label>
                                <div class="input-group">
                                    <span class="input-group-addon input-sm symbol"></span>
                                    <input type="text" id="txtDiscountAmount" onclick="this.select();" onchange="cal_TotalPrice()" onkeypress="return isNumberDecimalKey(event,this)" value="0.00" style="text-align: right" class="form-control input-sm" placeholder="0.00" />
                                </div>
                            </div>
                            <div class="col-md-2 form-group" id="DivDiscountPer" style="display: none">
                                <label>Discount Percentage<span class="required"> *</span></label>
                                <div class="input-group">
                                    <input type="text" id="txtDiscountPer" onclick="this.select();" onchange="cal_TotalPrice()" onkeypress="return isNumberDecimalKey(event,this)" value="0.00" style="text-align: right" class="form-control input-sm" placeholder="0.00" />
                                    <span class="input-group-addon input-sm">%</span>
                                </div>
                            </div>
                            
                            <div class="col-md-2 form-group" id="DivFixedPrice" style="display: none">
                                <label>Fixed Price<span class="required"> *</span></label>
                                <div class="input-group">
                                    <span class="input-group-addon input-sm symbol"></span>
                                    <input type="text" id="txtFixedPrice" onclick="this.select();" onchange="cal_TotalPrice()" onkeypress="return isNumberDecimalKey(event,this)" value="0.00" style="text-align: right" class="form-control input-sm" placeholder="0.00" />
                                </div>
                            </div>
                            <div class="col-md-2 form-group" >
                               <label>Status <span class="required">*</span></label>
                                <select id="ddlStatus" class="form-control input-sm">
                                   <%-- <option value="2">Select</option>--%>
                                    <option value="1" selected="selected">Active</option>
                                    <option value="0">Inactive</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-12">
                <div class="panel panel-default">
                    <div class="panel-heading" id="headingfirst">
                        <b>Product Group Items</b>
                    </div>
                    <div class="panel-body">
                        <div class="row">
                            <div class="col-md-3 form-group">
                                <label>Select Department<span style="display:none;" class="required" id="spnDept"> *</span></label>
                                <select id="ddlDept" onchange="ChangeDropdown(this)" class="form-control input-sm">
                                    <option value="0">Select Department</option>
                                </select>
                            </div>
                            <div class="col-md-3 form-group">
                                <label>Select Category<span style="display:none;" class="required" id="spnCat"> *</span></label>
                                <select id="ddlCategory" onchange="ChangeDropdown(this)" class="form-control input-sm">
                                    <option value="0">Select Category</option>
                                </select>
                            </div>
                            <div class="col-md-3 form-group">
                                <label>Product Name<span style="display:none;" class="required" id="spnProduct"> *</span></label>
                                <select id="ddlSKU" onchange="ChangeDropdown(this)" class="form-control input-sm">
                                    <option value="0">Select Product</option>
                                </select>
                            </div>
                            <div class="col-md-3 pull-right" style="margin-top: 30px;">
                                <div class="pull-right">
                                    <button type="button" id="btnSave1" onclick="CreateMixMatchTable();" class="btn btn-sm catsave-btn">Add</button>
                                    <button type="button" id="btnReset1" onclick="ResetFilters()" class="btn btn-sm catreset-btn">Reset</button>
                                     <button type="button" id="btnDeleteSelectedRow" onclick="DeleteSelectedRow()" disabled="disabled" style="display:none;" class="btn btn-sm btn-danger">Delete Selected Rows</button>
                                </div>
                            </div>
                        </div>
                        <div class="table-responsive">
                            <div>
                                <p style="text-align: right;">
                                   
                                    <span><b>Row Count: </b></span><span id="RowCount">0</span>
                                </p>
                            </div>
                            <table id="tblProductGroupList" class="table table-striped table-bordered well">
                                <thead>
                                    <tr class="thead">
                                        <td class="chkCheckBox text-center" style="width: 3%; vertical-align: middle;">
                                            <input type="checkbox" id="check-all" />
                                        </td>
                                        <td class="SKUAutoId" style="white-space: nowrap; text-align: center; display: none;">SKUAutoId</td>
                                        <td class="Action" style="white-space: nowrap; text-align: center;display:none;">Action</td>
                                        <td class="Department" style="white-space: nowrap; text-align: center">Department</td>
                                        <td class="Category1" style="white-space: nowrap; text-align: center">Category</td>
                                        <td class="SKUName" style="white-space: nowrap; text-align: center">Product Name</td>
                                        <%--<td class="UnitAutoId" style="white-space: nowrap; text-align: center; display: none;">UnitAutoId</td>--%>
                                        <td class="Unitprice" style="white-space: nowrap; text-align: center">Original
                                            <br />
                                            Unit Price (<span class="symbol"></span>)</td>
                                        <td class="UnitDiscount" style="white-space: nowrap; text-align: center; width: 10%;">Discount<br />(<span class="symbol"></span>)</td>
                                        <td class="UnitDiscountP" style="white-space: nowrap; text-align: center; width: 10%;">Discount<br />(%)</td>
                                        <td class="Discount" style="white-space: nowrap; text-align: center; display: none;">Discount<br />(<span class="symbol"></span>)</td>
                                        <td class="DiscountedUnitPrice" style="white-space: nowrap; text-align: center; width: 10%;">Discounted
                                            <br />
                                            Unit Price (<span class="symbol"></span>)</td>
                                        <td class="TaxPer" style="white-space: nowrap; text-align: center;">Tax<br />
                                            Percentage(%)</td>
                                        <td class="Tax" style="white-space: nowrap; text-align: center">Tax<br />(<span class="symbol"></span>)</td>
                                        <td class="TaxAutoId" style="white-space: nowrap; align-content: center; display: none;">TaxAutoId</td>
                                        <td class="Total" style="white-space: nowrap; text-align: center;">Total<br />(<span class="symbol"></span>)</td>
                                        <td class="ActionId" style="white-space: nowrap; text-align: center; display: none;">ActionId</td>
                                    </tr>
                                </thead>
                                <tbody id="tblProductGroupListBody" class="tbody">
                                </tbody>
                            </table>
                            <h5 class="well text-center" id="ProductGroupEmptyTable" style="display: none">No data available.</h5>
                        </div>
                        <hr />
                        <div class="row">
                            <div class="col-md-12 form-group">
                                <div class="pull-right">
                                    <button type="button" id="btnSave" onclick="InsertProductGroup();" class="btn btn-sm catsave-btn">Save</button>
                                    <button type="button" id="btnUpdate" onclick="UpdateScheme()" class="btn btn-sm catsave-btn" style="display: none">Update</button>
                                    <button type="button" id="btnReset" onclick="ResetMixNMatch()" class="btn btn-sm catreset-btn">Reset</button>
                                </div>
                            </div>
                        </div>
                    </div>


                </div>
            </div>

        </div>
    </div>
</asp:Content>


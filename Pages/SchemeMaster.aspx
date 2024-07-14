<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="SchemeMaster.aspx.cs" Inherits="Pages_SchemeMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <style>
        .picker {
            margin-left: -87px;
        }
        .DAY{
            padding:0px;
        }
    </style>
    <section class="content-header">
        <h1>Scheme  Master
            <a href="/Pages/SchemeList.aspx" class="btn btn-sm btn-success pull-right">Scheme List</a>
        </h1>
    </section>
    <div class="content" id="divForm" ondragstart="return false;" ondrop="return false;">
        <div class="row">
            <div class="col-md-12">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <b>Scheme Master</b>
                    </div>
                    <div class="panel-body">
                        <div class="row">
                            <div class="col-md-4 form-group">
                                <label>Scheme Name<span class="required"> *</span></label>
                                <input type="text" id="txtSchemeName" class="form-control input-sm" placeholder="Enter Scheme Name" />
                            </div>
                            <div class="col-md-4 form-group">
                                <label>SKU Name/Product Name<span class="required"> *</span></label>
                                <select id="ddlSKU" onchange="BindSKUDetails()" class="form-control input-sm">
                                    <option value="0">Select SKU/Product</option>
                                </select>
                            </div>
                            <div class="col-md-2 form-group">
                                <label>Scheme Start Date</label>
                                <input type="text" id="txtFromDate" class="form-control input-sm date" placeholder="From Date" />
                            </div>
                            <div class="col-md-2 form-group">
                                <label>Scheme End Date</label>
                                <input type="text" id="txtToDate" class="form-control input-sm date" placeholder="To Date" />
                            </div>
                        </div>
                        <div class="row" style="margin-bottom: 10px;">
                            <div class="col-md-2 form-group">
                                <label>Product/SKU Price<%--<span class="required"> *</span>--%></label>
                                <div class="input-group">
                                    <span class="input-group-addon input-sm symbol"></span>
                                    <input type="text" id="txtSKUUnitPrice" onkeypress="return isNumberDecimalKey(event,this)" value="0.00" style="text-align: right" class="form-control input-sm" readonly placeholder="0.00" />
                                </div>
                            </div>
                            <div class="col-md-2 form-group">
                                <label>Scheme Price<%--span class="required"> *</span>--%></label>
                                <div class="input-group">
                                    <span class="input-group-addon input-sm symbol"></span>
                                    <input type="text" id="txtSchemePrice" onkeypress="return isNumberDecimalKey(event,this)" value="0.00" style="text-align: right" class="form-control input-sm" readonly placeholder="0.00" />
                                </div>
                            </div>
                            <div class="col-md-2 form-group">
                                <label>Minimum Quantity<span class="required"> *</span></label>
                                <div class="input-group">
                                    <span class="input-group-addon input-sm" onclick="decreaseValueSKU(this)"><strong>-</strong></span>
                                    <input type="text" id="txtQuantity" style="text-align: center;" oncopy="return false" onpaste="return false" oncut="return false"
                                        onchange="ChangeValueSKU(this)" onkeypress="return isNumberKey(event)" class="form-control input-sm" value="1"
                                        placeholder="Enter Quantity" maxlength="5" />
                                    <span class="input-group-addon input-sm" onclick="increaseValueSKU(this)"><strong>+</strong></span>
                                </div>
                            </div>
                            
                            <div class="col-md-2 form-group">
                                <label>Status<%--<span class="required"> *</span>--%></label>
                                <select id="ddlSchemeStatus" class="form-control input-sm">
                                    <option value="1" selected="selected">Active</option>
                                    <option value="0">Inactive</option>
                                </select>
                            </div>
                        </div>

                        <div class="row" style="margin-bottom: 10px;">
                            <div class="col-md-1">
                                <div class="row">
                                    <div class="col-md-12 form-group">
                                        <label style="white-space: nowrap;">Select Day :<span class="required"> *</span></label>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-11">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="row">
                                            <div class="col-md-12">
                                                <div class="col-md-3  form-group DAY">
                                                    <input class="form-check-input" id="chkAllDays" type="checkbox" name="AllDays" onclick="event.stopPropagation()" onchange="selectAll()" />
                                                    &nbsp;&nbsp;<label class="form-check-label" for="chkAllDays">All Day</label>
                                                </div>
                                                <div class="col-md-3  form-group DAY">
                                                    <input class="form-check-input" type="checkbox" onchange="isAllday()" id="chkSunday" name="DayNames" value="Sunday" />
                                                    &nbsp;&nbsp;<label class="form-check-label" for="chkSunday">Sunday</label>
                                                </div>
                                                <div class="col-md-3  form-group DAY">
                                                    <input class="form-check-input" type="checkbox" onchange="isAllday()" id="chkMonday" name="DayNames" value="Monday" />
                                                    &nbsp;&nbsp;<label class="form-check-label" for="chkMonday">Monday</label>
                                                </div>
                                                <div class="col-md-3  form-group DAY">
                                                    <input class="form-check-input" type="checkbox" onchange="isAllday()" id="chkTuesday" name="DayNames" value="Tuesday" />
                                                    &nbsp;&nbsp;<label class="form-check-label" for="chkTuesday">Tuesday</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="row">
                                            <div class="col-md-12">
                                                <div class="col-md-3  form-group DAY" style="white-space: nowrap;">
                                                    <input class="form-check-input" type="checkbox" onchange="isAllday()" id="chkWednesday" name="DayNames" value="Wednesday" />
                                                    &nbsp;&nbsp;<label class="form-check-label" for="chkWednesday">Wednesday</label>
                                                </div>
                                                <div class="col-md-3  form-group DAY">
                                                    <input class="form-check-input" type="checkbox" onchange="isAllday()" id="chkThursday" name="DayNames" value="Thursday" />
                                                    &nbsp;&nbsp;<label class="form-check-label" for="chkThursday">Thursday</label>
                                                </div>
                                                <div class="col-md-3 form-group DAY">
                                                    <input class="form-check-input" type="checkbox" onchange="isAllday()" id="chkFriday" name="DayNames" value="Friday" />
                                                    &nbsp;&nbsp;<label class="form-check-label" for="chkFriday">Friday</label>
                                                </div>
                                                <div class="col-md-3 form-group DAY">
                                                    <input class="form-check-input" type="checkbox" onchange="isAllday()" id="chkSaturday" name="DayNames" value="Saturday" />
                                                    &nbsp;&nbsp;<label class="form-check-label" for="chkSaturday">Saturday</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="table-responsive">
                            <table id="tblSchemeProductList" class="table table-striped table-bordered well">
                                <thead>
                                    <tr class="thead">
                                        <td class="SchemeItemAutoId" style="white-space: nowrap; text-align: center; display: none;">SchemeItemAutoId</td>
                                        <td class="ProductId" style="white-space: nowrap; text-align: center; display: none;">ProductId</td>
                                        <td class="ProductName" style="white-space: nowrap; text-align: center">SKU/Product Name</td>
                                        <td class="Unit" style="white-space: nowrap; text-align: center">Unit</td>
                                        <td class="Quantity" style="white-space: nowrap; text-align: center">Quantity</td>
                                        <td class="UnitAutoId" style="white-space: nowrap; text-align: center; display: none;">UnitAutoId</td>
                                        <td class="Unitprime" style="white-space: nowrap; text-align: center">Original Unit Price (<span class="symbol"></span>)</td>
                                        <td class="UnitDiscountDL" style="white-space: nowrap; text-align: center; width: 10%;">Discount(<span class="symbol"></span>)</td>
                                        <td class="UnitDiscount" style="white-space: nowrap; text-align: center; width: 10%;">Discount(%)</td>
                                        <td class="UnitPrice" style="white-space: nowrap; text-align: center; width: 10%;">Discounted Unit Price (<span class="symbol"></span>)</td>
                                        
                                        <td class="Discount" style="white-space: nowrap; text-align: center; display: none;">Discount(<span class="symbol"></span>)</td>
                                        <td class="Tax" style="white-space: nowrap; text-align: center">Tax(<span class="symbol"></span>)</td>
                                        <td class="TaxAutoId" style="white-space: nowrap; align-content: center; display: none;">TaxAutoId</td>
                                        <td class="TaxPer" style="white-space: nowrap; align-content: center; display: none;">TaxPer</td>
                                        <td class="Total" style="white-space: nowrap; text-align: center;">Total(<span class="symbol"></span>)</td>
                                        <td class="ActionId" style="white-space: nowrap; text-align: center; display: none;">ActionId</td>
                                    </tr>
                                </thead>
                                <tbody id="tblSchemeProductListBody" class="tbody">
                                </tbody>
                                <tfoot id="tblSchemeProductListFoot">
                                    <tr class="tfoot">
                                        <td class="F_SKUTotal" colspan="6" style="white-space: nowrap; text-align: right"><b>Total</b></td>
                                        <td class="F_UnitPrice" id="F_UnitPrice" colspan="1" style="white-space: nowrap; text-align: right; font-weight: 900">0.00</td>
                                        
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
                                    <button type="button" id="btnSave" onclick="InsertScheme();" class="btn btn-sm catsave-btn">Save</button>
                                    <button type="button" id="btnUpdate" onclick="UpdateScheme()" class="btn btn-sm catsave-btn" style="display: none">Update</button>
                                    <button type="button" id="btnReset" onclick="ResetSchemeDetails()" class="btn btn-sm catreset-btn">Reset</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>


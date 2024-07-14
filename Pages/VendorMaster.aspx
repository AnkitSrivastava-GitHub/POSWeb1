<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="VendorMaster.aspx.cs" Inherits="Pages_VendorMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>Vendor Master
            <a href="/Pages/ShowVendorMaster.aspx" class="btn btn-sm btn-warning pull-right">Vendor List</a>
        </h1>
    </section>
    <div class="content" id="divForm" ondragstart="return false;" ondrop="return false;">
        <div class="row">
            <div class="col-md-12">
                <input type="hidden" id="hdnVendorId" />
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <b>Vendor Details</b>
                    </div>
                    <div class="panel-body" id="panelStoreDetail">
                        <div class="row">
                            <label class="col-md-2 form-group">
                                Vendor Code<span class="required"> *</span>
                            </label>
                            <div class="col-md-4 form-group">
                                <input type="text" id="txtVendorCode" onkeypress="return /[0-9a-zA-Z ]/i.test(event.key)" class="form-control input-sm" placeholder="Enter Vendor Code" maxlength="25" />
                            </div>
                            <label class="col-md-2 form-group" style="padding-left: 50px;">
                                Vendor Name<span class="required"> *</span>
                            </label>
                            <div class="col-md-4 form-group">
                                <input type="text" id="txtname" class="form-control input-sm" placeholder="Enter Vendor Name" maxlength="25" />
                            </div>
                            <label class="col-md-2 form-group" style="display: none;">
                                Store Name<span class="required"> *</span>
                            </label>
                            <div class="col-md-4 form-group" style="display: none;">
                                <select id="ddlCompanyName" style="padding-top: 2px;" class="form-control input-sm">
                                    <option value="0">Select Store</option>
                                </select>
                            </div>
                        </div>
                        <div class="row">
                            <label class="col-md-2 form-group">
                                Contact No.<span class="required"> *</span>
                            </label>
                            <div class="col-md-4 form-group">
                                <input type="text" id="txtmob" oninput="process(this)" class="form-control input-sm" onkeypress="return isNumberKey(this)" placeholder="Enter Contact No." maxlength="10" />
                            </div>
                             <label class="col-md-2 form-group" style="padding-left: 50px;">
                                Email ID
                            </label>
                            <div class="col-md-4 form-group">
                                <input type="text" id="txtemail" class="form-control input-sm" placeholder="Enter Email ID" />
                            </div>
                        </div>
                        <div class="row">
                            <label class="col-md-2 form-group">
                                Address
                            </label>
                            <div class="col-md-4 form-group">
                                <textarea type="text" id="txtaddress" maxlength="200" class="form-control input-sm" style="resize: none;" placeholder="Enter Address" rows="3"></textarea>
                            </div>
                            <label class="col-md-2 form-group" style="padding-left: 50px;">
                                State
                            </label>
                            <div class="col-md-4 form-group">
                                <select id="ddlstate" class="form-control input-sm">
                                    <option value="1">Select State</option>
                                </select>
                            </div>
                            <label class="col-md-2 form-group" style="padding-left: 50px;">
                                City
                            </label>
                            <div class="col-md-4 form-group">
                                <input type="text" id="txtcity" onkeypress="return /[a-zA-Z ]/i.test(event.key)" class="form-control input-sm" placeholder="Enter City" maxlength="25" />
                            </div>
                            <label class="col-md-2 form-group" style="padding-left: 50px;">
                                Zip Code
                            </label>
                            <div class="col-md-4 form-group">
                                <input type="text" id="txtzip" oninput="process(this)" class="form-control input-sm" placeholder="Enter Zip Code" maxlength="5"
                                    onkeypress="return isNumberKey(this)" />
                            </div>
                        </div>
                        <div class="row">
                           
                            <label class="col-md-2 form-group">
                                Status
                            </label>
                            <div class="col-md-4 form-group">
                                <select id="ddlstatus" class="form-control input-sm">
                                    <option value="1">Active</option>
                                    <option value="0">Inactive</option>
                                </select>
                            </div>
                        </div>

                        <hr />
                        <div class="row">
                            <div class="col-md-12 form-group">
                                <div class="pull-right">
                                    <button type="button" id="btnSave" class="btn btn-sm catsave-btn">Save</button>
                                    <button type="button" id="btnUpdate" onclick="UpdateVendor();" class="btn btn-sm catsave-btn" style="display: none">Update</button>
                                    <button type="button" id="btnReset" onclick="Reset();" class="btn btn-sm catreset-btn">Reset</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>


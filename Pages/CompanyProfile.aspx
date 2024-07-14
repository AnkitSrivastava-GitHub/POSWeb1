<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="CompanyProfile.aspx.cs" Inherits="Pages_CompanyProfile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>Store Master
                 <a href="/Pages/StoreList.aspx" class="btn btn-sm btn-warning pull-right">Store List</a>
        </h1>
    </section>
    <div class="content" id="divForm" ondragstart="return false;" ondrop="return false;">
        <div class="row">
            <div class="col-md-12">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <b>Store Details </b>
                    </div>
                    <div class="panel-body">
                        <div class="row">
                            <div class="col-md-9">
                                <div class="row">

                                    <div class="col-md-6">
                                        <input type="text" id="hdnCompanyId" hidden />
                                        <input type="text" id="hdnimage" hidden />
                                        <div class="row">
                                            <label class="col-sm-5 form-group">
                                                Store Name&nbsp;<span class="required">*</span>
                                            </label>
                                            <div class="col-sm-7 form-group">
                                                <input type="text" id="txtCompanyName" maxlength="60" class="form-control input-sm" placeholder="Enter Store Name" />
                                            </div>
                                        </div>
                                        <div class="row">
                                            <label class="col-sm-5 form-group">
                                                Billing Address&nbsp;<span class="required">*</span>
                                            </label>
                                            <div class="col-sm-7 form-group">
                                                <input type="text" id="txtBilling" maxlength="150" class="form-control input-sm" placeholder="Enter Billing Address" />
                                            </div>
                                        </div>
                                        <div class="row">
                                            <label class="col-sm-5 form-group">
                                                State&nbsp;<span class="required">*</span>
                                            </label>
                                            <div class="col-sm-7 form-group">
                                                <input type="text" id="txtstate" onkeypress="return /[0-9a-zA-Z ]/i.test(event.key)" maxlength="50" class="form-control input-sm" placeholder="Enter State" />
                                            </div>
                                        </div>
                                        <div class="row">
                                            <label class="col-md-5 form-group">
                                                Zip Code&nbsp;<span class="required">*</span>
                                            </label>
                                            <div class="col-md-7 form-group">
                                                <input type="text" id="txtzipcode" class="form-control input-sm" placeholder="Enter Zip Code" maxlength="5"
                                                    oncopy="return false" onpaste="return false" oncut="return false" onkeypress="NumericInput(event)" />
                                            </div>
                                        </div>
                                        <div class="row">
                                            <label class="col-sm-5 form-group">
                                                Email ID
                                            </label>
                                            <div class="col-sm-7 form-group">
                                                <input type="email" id="txtemail" maxlength="90" class="form-control input-sm" placeholder="Enter Email ID" />
                                            </div>
                                        </div>
                                        <%--      <div class="row">
                                            <label class="col-sm-5 form-group">
                                                Mobile No.
                                            </label>
                                            <div class="col-sm-7 form-group">
                                                <input type="text" id="txtmob" class="form-control input-sm" placeholder="Enter Mobile No." maxlength="10"
                                                    oncopy="return false" onpaste="return false" oncut="return false" onkeypress="return isNumberKey(event)" />
                                            </div>
                                        </div>--%>


                                        <div class="row">
                                            <label class="col-md-5 form-group">
                                                Mobile No.
                                            </label>
                                            <div class="col-md-7 form-group">
                                                <input type="text" id="txtphone" class="form-control input-sm" placeholder="Enter Mobile No." maxlength="10"
                                                    oncopy="return false" onpaste="return false" oncut="return false" onkeypress="return isNumberKey(event)" />
                                            </div>
                                        </div>
                                        <div class="row">
                                            <label class="col-sm-5 form-group">
                                                Fax No.
                                            </label>
                                            <div class="col-sm-7 form-group">
                                                <input type="text" id="txtfaxno" class="form-control input-sm" placeholder="Enter Fax No." maxlength="10"
                                                    oncopy="return false" onpaste="return false" oncut="return false" onkeypress="NumericInput(event)" />
                                            </div>
                                        </div>
                                        <div class="row">
                                            <label class="col-md-5 form-group">
                                                Currency&nbsp;<span class="required">*</span>
                                            </label>
                                            <div class="col-md-7 form-group">
                                                <select class="form-control border-primary input-sm" style="line-height: 17px !important; height: 35px;" id="ddlCurrency" >
                                                    <option value="0">Select Currency</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="row" style="display: none;">
                                            <label class="col-md-5 form-group">
                                                Store ID
                                            </label>
                                            <div class="col-md-7 form-group">
                                                <input type="text" id="txtid" class="form-control input-sm" placeholder="Enter ID" readonly />
                                            </div>
                                        </div>
                                        <div class="row">
                                            <label class="col-md-5 form-group">
                                                Contact person
                                            </label>
                                            <div class="col-md-7 form-group">
                                                <input type="text" id="txtcontact" maxlength="90" onkeypress="return /[0-9a-zA-Z ]/i.test(event.key)" class="form-control input-sm" placeholder="Enter Contact Person" />
                                            </div>
                                        </div>
                                        <div class="row">
                                            <label class="col-sm-5 form-group">
                                                City&nbsp;<span class="required">*</span>
                                            </label>
                                            <div class="col-sm-7 form-group">
                                                <input type="text" id="txtCity" onkeypress="return /[0-9a-zA-Z ]/i.test(event.key)" maxlength="50" class="form-control input-sm" placeholder="Enter City" />
                                            </div>
                                        </div>
                                        <div class="row">
                                            <label class="col-md-5 form-group">
                                                Country&nbsp;<span class="required">*</span>
                                            </label>
                                            <div class="col-md-7 form-group">
                                                <input type="text" id="txtcountry" onkeypress="return /[0-9a-zA-Z ]/i.test(event.key)" maxlength="50" class="form-control input-sm" placeholder="Enter Country" />
                                            </div>
                                        </div>
                                        <div class="row">
                                            <label class="col-md-5 form-group">
                                                Website
                                            </label>
                                            <div class="col-md-7 form-group">
                                                <input type="text" id="txtsite" maxlength="500" class="form-control input-sm d-flex align-items-center" placeholder="Enter Website" />
                                            </div>
                                        </div>
                                        <%--      <div class="row">
                                            <label class="col-md-5 form-group">
                                                Phone No.
                                            </label>
                                            <div class="col-md-7 form-group">
                                                <input type="text" id="txtphone" class="form-control input-sm" placeholder="Enter Phone No." maxlength="10"
                                                    oncopy="return false" onpaste="return false" oncut="return false" onkeypress="return isNumberKey(event)" />
                                            </div>
                                        </div>--%>

                                        <div class="row">
                                            <label class="col-sm-5 form-group">
                                                Phone No.
                                            </label>
                                            <div class="col-sm-7 form-group">
                                                <input type="text" id="txtmob" class="form-control input-sm" placeholder="Enter Phone No." maxlength="10"
                                                    oncopy="return false" onpaste="return false" oncut="return false" onkeypress="return isNumberKey(event)" />
                                            </div>
                                        </div>


                                        <div class="row">
                                            <label class="col-md-5 form-group">
                                                VAT No.
                                            </label>
                                            <div class="col-md-7 form-group">
                                                <input type="text" id="txtvatno" class="form-control input-sm" placeholder="Enter VAT No." maxlength="15"
                                                    oncopy="return false" onpaste="return false" oncut="return false" onkeypress="NumericInput(event)" />
                                            </div>
                                        </div>
                                        <div class="row">
                                            <label class="col-md-5 form-group">
                                                Status
                                            </label>
                                            <div class="col-md-7 form-group">
                                                <select id="ddlStoreStatus" style="line-height: 17px !important; height: 35px;" class="form-control input-sm d-flex align-items-center">
                                                    <option value="1">Open</option>
                                                    <option value="0">Close</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <label class="col-md-5 form-group">
                                                Allow Lottery Sale
                                            </label>
                                            <div class="col-md-7 form-group">
                                                <select id="ddlAllowLottoSale" style="line-height: 17px !important; height: 35px;" class="form-control input-sm d-flex align-items-center">
                                                    <option value="1">Yes</option>
                                                    <option value="0">No</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="row">
                                    <div class="col-md-12" style="text-align: center;">
                                        <div class="col-md-12 form-group" style="text-align: center;">
                                            <input type="file" id="uploadimg" placeholder="Enter file" onchange="readURL(this)" class="form-control" />
                                        </div>
                                        <%--<div class="col-md-12 form-group" style="text-align: center;">
                                            <img id="imglogo" alt="photo" style="width: 120px;max-height:150px; text-align: center;" />
                                        </div>--%>
                                        <div class="row" id="divimgPreview" style="margin-top: 5px; text-align: center;">
                                            <div class="col-md-12">
                                                <img src="../pages/images/logo.ico" class="imagePreview border-primary" id="imgPreview" width="120" height="120" />
                                                <input type="hidden" id="imgPath" />
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-12 form-group" style="text-align: center;">
                                                <span id="txtextention" class="required" style="text-align: center;">.png, .jpg, .jpeg, .gif, .bmp</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12 form-group">
                                <div class="pull-right">
                                    <button type="button" id="btnSave" onclick="InsertStore();" class="btn btn-sm catsave-btn">Save</button>
                                    <button type="button" id="btnUpdate" onclick="updateCompanyProfile();" class="btn btn-sm catsave-btn" style="display: none">Update</button>
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


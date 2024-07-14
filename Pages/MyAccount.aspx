<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="MyAccount.aspx.cs" Inherits="Pages_MyAccount" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <section class="content-header">
        <h1>My Account
        </h1>
    </section>
    <div class="content" id="divForm"  ondragstart="return false;" ondrop="return false;">
        <div class="row">
            <div class="col-md-12">
                <input type="hidden" id="hdnUserId" />
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <b>My Account</b>
                    </div>
                    <div class="panel-body" id="panelStoreDetail">
                        <div class="row">
                            <label class="col-md-2 form-group">
                                First Name<span class="required"> *</span>
                            </label>
                            <div class="col-md-4 form-group">
                                <input type="text" id="txtfirstname" class="form-control input-sm" placeholder="Enter First Name" onkeypress='return validate(event)' />
                            </div>
                            <label class="col-md-2 form-group">
                                Last Name
                            </label>
                            <div class="col-md-4 form-group">
                                <input type="text" id="txtlastname" class="form-control input-sm" placeholder="Enter Last Name" onkeypress='return validate(event)' />
                            </div>
                        </div>
                        <div class="row">
                            <label class="col-md-2 form-group">
                                Email ID
                            </label>
                            <div class="col-md-4 form-group">
                                <input type="text" id="txtemail" class="form-control input-sm" placeholder="Enter Email ID" />
                            </div>
                            <label class="col-md-2 form-group">
                                Phone No.
                            </label>
                            <div class="col-md-4 form-group">
                                <input type="text" id="txtmob" class="form-control input-sm" placeholder="Enter Phone No." maxlength="10"
                                     oncopy="return false" onpaste="return false" oncut="return false" />
                            </div>
                        </div>
                        <div class="row">
                            <label class="col-md-2 form-group">
                                Login ID<span class="required"> *</span>
                            </label>
                            <div class="col-md-4 form-group">
                                <input type="text" id="txtlogin" autocomplete="new-password"  class="form-control input-sm" placeholder="Enter Login ID" />
                            </div>
                             <label class="col-md-2 form-group">
                                Password<span class="required"> *</span>
                            </label>
                            <div class="col-md-4 form-group">
                                <div class="input-group">
                                    <input type="password" id="txtpassword" disabled="disabled" autocomplete="new-password" class="form-control input-sm" placeholder="Enter Password" />
                                    <span class="input-group-addon input-sm" id="chkViewPassword" style="background-color:azure;" onclick="ViewPassword();"><img src="/Images/icons8-password.gif" height="18"  /></span>
                                </div>
                            </div>                            
                        </div>
                        <div class="row">
                            <label class="col-md-2 form-group">
                                User Type<span class="required"> *</span>
                            </label>
                            <div class="col-md-4 form-group">
                                <select id="ddluserType" onchange="OpenSecurityPin()" disabled="disabled" style="padding-top:2px;" class="form-control input-sm">
                                    <option value="1">Select User Type</option>
                                </select>
                            </div>
                            <label class="col-md-2 form-group">
                                Status
                            </label>
                            <div class="col-md-4 form-group">
                                <select id="ddlstatus" disabled="disabled" class="form-control input-sm">
                                    <option value="1">Active</option>
                                    <option value="0">Inactive</option>
                                </select>
                            </div>
                        </div>
                          <div class="row" id="securitybox" style="display:none">  
                                <label class="col-md-2 form-group">
                                     Security PIN <span class="required"> *</span>
                               </label>
                            <div class="col-md-4 form-group">
                               <input type="text" id="txtsecuritypin" disabled="disabled" placeholder="Enter security PIN" class="form-control input-sm" />
                            </div>
                        </div>
                        <hr />
                        <div class="row">
                            <div class="col-md-12 form-group">
                                <div class="pull-right">
                                    <button type="button" id="btnUpdate" onclick="UpdateUser();" class="btn btn-sm catsave-btn" style="display: none">Update</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>


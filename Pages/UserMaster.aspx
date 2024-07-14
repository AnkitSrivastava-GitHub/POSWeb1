<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="UserMaster.aspx.cs" Inherits="Pages_UserMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>User Master
            <a href="/Pages/ShowUserMaster.aspx" class="btn btn-sm btn-warning pull-right">User List</a>
        </h1>
    </section>
    <div class="content" id="divForm" ondragstart="return false;" ondrop="return false;">
        <div class="row">
            <div class="col-md-12">
                <input type="hidden" id="hdnUserId" />
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <b>User Details</b>
                    </div>
                    <div class="panel-body" id="panelStoreDetail">


                        <div class="row">
                            <div class="col-md-6">
                            </div>

                        </div>
                        <div class="row">
                            <label class="col-md-2 form-group">
                                First Name<span class="required"> *</span>
                            </label>
                            <div class="col-md-4 form-group">
                                <input type="text" id="txtfirstname" onkeypress="return /[0-9a-zA-Z ]/i.test(event.key)" maxlength="60" class="form-control input-sm" placeholder="Enter First Name" onkeypress='return validate(event)' />
                            </div>
                            <label class="col-md-2 form-group">
                                Last Name
                            </label>
                            <div class="col-md-4 form-group">
                                <input type="text" id="txtlastname" onkeypress="return /[0-9a-zA-Z ]/i.test(event.key)" maxlength="60" class="form-control input-sm" placeholder="Enter Last Name" onkeypress='return validate(event)' />
                            </div>
                        </div>
                        <div class="row">
                            <label class="col-md-2 form-group">
                                Email ID
                            </label>
                            <div class="col-md-4 form-group">
                                <input type="text" id="txtemail" maxlength="80" class="form-control input-sm" placeholder="Enter Email ID" />
                            </div>
                            <label class="col-md-2 form-group">
                                Mobile No.
                            </label>
                            <div class="col-md-4 form-group">
                                <input type="text" id="txtmob" class="form-control input-sm" placeholder="Enter Mobile No." onkeypress="return isNumberKey(event)" maxlength="10"
                                    oncopy="return false" onpaste="return false" oncut="return false" />
                            </div>
                        </div>
                        <div class="row">
                            <label class="col-md-2 form-group">
                                Login ID<span class="required"> *</span>
                            </label>
                            <div class="col-md-4 form-group">
                                <input type="text" id="txtlogin" maxlength="50" autocomplete="new-password" class="form-control input-sm" placeholder="Enter Login ID" />
                            </div>
                            <label class="col-md-2 form-group">
                                Password<span class="required"> *</span>
                            </label>
                            <div class="col-md-4 form-group">
                                <div class="input-group">
                                    <input type="password" id="txtpassword" maxlength="40" autocomplete="new-password" class="form-control input-sm" placeholder="Enter Password" />
                                    <span class="input-group-addon input-sm" id="chkViewPassword" style="background-color: azure;" onclick="ViewPassword();">
                                        <img src="/Images/icons8-password.gif" height="18" /></span>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <label class="col-md-2 form-group">
                                User Type<span class="required"> *</span>
                            </label>
                            <div class="col-md-4 form-group">
                                <select id="ddluserType" onchange="OpenSecurityPin()" style="padding-top: 2px;" class="form-control input-sm">
                                    <option value="1">Select User Type</option>
                                </select>
                            </div>
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
                        <div class="row">
                            <div class="col-md-6">
                                <div class="row" id="securitybox" style="display: none">
                                    <label class="col-md-4 form-group">
                                        Security PIN <span class="required">*</span>
                                    </label>
                                    <div class="col-md-8 form-group">
                                        <input type="text" maxlength="15" id="txtsecuritypin" placeholder="Enter Security PIN" class="form-control input-sm" />
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="row" id="securityboxD" style="display: none">
                                    <label class="col-md-4 form-group">
                                        Discount Security PIN <span class="required">*</span>
                                    </label>
                                    <div class="col-md-8 form-group">
                                        <input type="text" id="txtsecuritypinDisc" maxlength="15" placeholder="Enter Discount Security PIN" class="form-control input-sm" />
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="row" id="securityboxW" style="display: none">
                                    <label class="col-md-4 form-group" style="white-space: nowrap;">
                                        Withdraw Security PIN <span class="required">*</span>
                                    </label>
                                    <div class="col-md-8 form-group">
                                        <input type="text" maxlength="15" id="txtWsecuritypin" placeholder="Enter Withdraw Security PIN" class="form-control input-sm" />
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="row" id="HourlyRate" style="display: none">
                                    <label class="col-md-4 form-group">
                                        Hourly Rate<span class="required">*</span>
                                    </label>
                                    <div class="col-md-8 form-group">
                                        <div class="input-group">
                                            <span class="input-group-addon input-sm symbol" style="font-weight:700"></span>
                                            <input type="text" id="txtHourlyRate" style="text-align: right" oninput="process(this)" maxlength="9" placeholder="0.00" class="form-control input-sm" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <label class="col-md-2 form-group">
                                Allowed App
                            </label>
                            <div class="col-md-4 form-group">
                                <select id="ddlAllowedApp" class="form-control input-sm">
                                    <option value="2">Select</option>
                                    <option value="1">Yes</option>
                                    <option value="0">No</option>
                                </select>
                            </div>
                        </div>
                        <div class="row">
                            <label class="col-md-2 form-group">
                                Assign Store
                            </label>
                            <div class="col-md-10 form-group" id="DivStoreList">
                            </div>
                        </div>
                        <hr />
                        <div class="row">
                            <div class="col-md-12 form-group">
                                <div class="pull-right">
                                    <button type="button" id="btnSave" onclick="InsertUser();" class="btn btn-sm catsave-btn">Save</button>
                                    <button type="button" id="btnUpdate" onclick="UpdateUser();" class="btn btn-sm catsave-btn" style="display: none">Update</button>
                                    <button type="button" id="btnReset" onclick="Reset();" class="btn btn-sm catreset-btn">Reset</button>
                                </div>
                            </div>
                        </div>

                        <div class="row ModuleAssign" style="display: none">
                            <%-- <hr />--%>
                            <div class="col-md-12">
                                <div class="col-md-4">
                                    <div class="row">
                                        <style>
                                            .table1, th, td {
                                                border: 1px solid black;
                                                border-collapse: collapse;
                                            }
                                        </style>

                                        <div class="col-md-12">
                                            <table class="col-md-12 table1" style="border: solid black 1px; text-align: center;">
                                                <thead>
                                                    <tr>
                                                        <th colspan="3" style="text-align: center; background-color: #0f7d63; color: #ffffff">Assign Module
                                                        </th>
                                                    </tr>
                                                    <tr>
                                                        <th style="text-align: center">Action</th>
                                                        <th style="text-align: center">Module Id</th>
                                                        <th style="text-align: center">Module Name</th>
                                                    </tr>
                                                </thead>
                                                <tbody id="DivModuleList">
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="row">
                                        <div class="col-md-12">
                                            <table class="col-md-12 table1" style="border: solid black 1px; text-align: center;">
                                                <thead>
                                                    <tr>
                                                        <th colspan="3" style="text-align: center; background-color: #0f7d63; color: #ffffff">Assign Sub Module
                                                        </th>
                                                    </tr>
                                                    <tr>
                                                        <th style="text-align: center">Action</th>
                                                        <th style="text-align: center">Sub Module Id</th>
                                                        <th style="text-align: center">Sub Module Name</th>
                                                    </tr>
                                                </thead>
                                                <tbody id="DivSubModuleList">
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="row">
                                        <div class="col-md-12">
                                            <table class="col-md-12 table1" style="border: solid black 1px; text-align: center;">
                                                <thead>
                                                    <tr>
                                                        <th colspan="3" style="text-align: center; background-color: #0f7d63; color: #ffffff">Assign Component
                                                        </th>
                                                    </tr>
                                                    <tr>
                                                        <th style="text-align: center">Action</th>
                                                        <th style="text-align: center">Component Id</th>
                                                        <th style="text-align: center">Component Name</th>
                                                    </tr>
                                                </thead>
                                                <tbody id="DivComponentList">
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <%-- <hr />--%>
                        <div class="row ModuleAssign" style="display: none">
                            <div class="col-md-12 form-group">
                                <div class="pull-right">
                                    <button type="button" id="btnSaveModule" onclick="AssignModule();" class="btn btn-sm catsave-btn">Update</button>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>


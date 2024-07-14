<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="ShowUserMaster.aspx.cs" Inherits="Pages_ShowUserMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>User Master
            <a href="/Pages/UserMaster.aspx" class="btn btn-sm btn-warning pull-right">Add New User</a>
        </h1>
    </section>
    <div class="content" id="divForm" ondragstart="return false;" ondrop="return false;">
        <div class="row">
            <div class="col-md-12">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <b>Search Criteria</b>
                    </div>
                    <div class="panel-body">
                        <div class="row" style="margin-bottom:10px;">
                            <div class="col-md-2">
                                <input type="text" id="txtSname" class="form-control input-sm" placeholder="Name" />
                            </div>
                            <div class="col-md-2">
                                <input type="text" id="txtSEmailid" class="form-control input-sm" placeholder="Email ID" />
                            </div>
                            <div class="col-md-2">
                                <select id="txtSUserType" style="padding-top:2px;" class="form-control input-sm">
                                    <option value="0">All User Type</option>
                                </select>
                            </div>
                            <div class="col-md-2" >
                                <input type="text" id="txtSUser" class="form-control input-sm" placeholder="Login ID" />
                            </div>
                            <div class="col-md-2">
                                <input type="text" id="txtSMob" class="form-control input-sm" onkeypress="return isNumberKey(this)" placeholder="Mobile No" maxlength="10"/>
                            </div>
                            <div class="col-md-2">
                                <select id="txtSstatus" class="form-control input-sm">
                                    <option value="2">All Status</option>
                                    <option value="1">Active</option>
                                    <option value="0">Inactive</option>
                                </select>
                            </div> 
                        </div>
                        <div class="row">
                             <div class="col-md-2">
                                <select id="ddlSCompanyName" style="padding-top:2px;display:none;" class="form-control input-sm">
                                    <option value="0">All Company</option>
                                </select>
                            </div>
                             <div class="col-md-10">
                                <button id="btnSearch" type="button" onclick="BindUserList(1);" class="btn btn-md catsearch-btn pull-right" style="margin-bottom:10px;">Search</button>
                            </div>
                        </div>
                        <div class="table-responsive">
                            <table id="tblUserList" class="table table-striped table-bordered well" style="margin-bottom:0px;display:none;">
                                <thead>
                                    <tr class="thead">
                                        <td class="Action" style="width:5%;">Action</td>
                                        <td class="UserAutoId" style="display: none;">UserAutoId</td>
                                        <td class="CompanyName" style="width: 100px; text-align: center;display:none;">Company Name</td>
                                        <td class="UserFName" style="white-space: nowrap;text-align:center;width:30%">Name</td>
                                        <td class="UserType" style="width: 100px; text-align: center;">User Type</td>
                                        <td class="LoginId" style="width: 100px; text-align: center;">Login ID</td>
                                        <td class="EmailId" style="width: 100px; text-align: center;">Email ID</td>
                                        <td class="Mob" style="width: 100px; text-align: center;">Mobile No</td>
                                        <td class="status" style="width: 100px; text-align: center;">Status</td>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>
                            <h5 class="well text-center" id="EmptyTable" style="display: none">No data available.</h5>

                        </div>
                        <div class="form-group row" style="padding-bottom: 0px; margin-bottom: 0px; margin-top: 10px;" id="DivPager">
                            <div class="col-md-1">
                                <select class="form-control border-primary input-sm" style="display:none;" id="ddlPageSize" onchange="BindUserList(1)">
                                    <option value="10">10</option>
                                    <option value="50">50</option>
                                    <option value="100">100</option>
                                    <option value="500">500</option>
                                    <option value="1000">1000</option>
                                    <option value="0">All</option>
                                </select>
                            </div>
                            <div class="col-md-8">
                                <div class="Pager" id="Pager"></div>
                            </div>
                            <div class="col-md-3 text-right">
                                <span id="spSortBy" style="color: red; font-size: small;"></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>


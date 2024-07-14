<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="ShowVendorMaster.aspx.cs" Inherits="Pages_ShowVendorMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>Vendor Master List
            <a href="/Pages/VendorMaster.aspx" class="btn btn-sm btn-warning pull-right">Add New Vendor</a>
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
                           <%--  <div class="col-md-2">
                                <select id="ddlSCompanyName"  style="padding-top: 2px;" class="form-control input-sm" >
                                    <option value="0">Select Store</option>
                                </select>
                            </div>--%>
                            <div class="col-md-2">
                                <input type="text" id="txtScode" onkeypress="return /[0-9a-zA-Z ]/i.test(event.key)" class="form-control input-sm" placeholder="Vendor Code" maxlength="25"/>
                            </div>
                            <div class="col-md-2">
                                <input type="text" id="txtSname" class="form-control input-sm" placeholder="Vendor Name"  maxlength="25"/>
                            </div>
                             <div class="col-md-2">
                                <input type="text" id="txtSMob" onkeypress="return isNumberKey(this)" class="form-control input-sm" placeholder="Contact No." maxlength="10" />
                            </div>
                            <div class="col-md-2">
                                <input type="email" id="txtSEmailid" class="form-control input-sm" placeholder="Email ID" />
                            </div>
                            <div class="col-md-2">
                                <select id="txtSstatus" class="form-control input-sm">
                                    <option value="2">All Status</option>
                                    <option value="1">Active</option>
                                    <option value="0">Inactive</option>
                                </select>
                            </div>
                        
                            <div class="col-md-2">
                                  <button id="btnSearch" type="button" onclick="BindVendorList(1);" class="btn btn-sm catsearch-btn pull-right">Search</button>
                            </div>
                        </div>
                        <div class="table-responsive">
                            <table id="tblVendorList" class="table table-striped table-bordered well" style="margin-bottom:0px;display:none;">
                                <thead>
                                    <tr class="thead">
                                        <td class="Action" style="width: 50px;">Action</td>
                                        <td class="AutoId" style="display: none;">AutoId</td>
                                        <td class="vendorCode" style="white-space: nowrap; text-align: center;">Vendor Code</td>
                                        <td class="vendorName" style="white-space: nowrap; text-align: center;">Vendor Name</td>
<%--                                    <td class="companyName" style="white-space: nowrap; text-align: center;">Store Name</td>--%>
                                       <%-- <td class="vendorCode" style="white-space: nowrap; text-align: center;">Vendor Code</td>--%>
                                        <td class="Mob" style="width: 100px; text-align: center;">Contact No.</td>
                                        <td class="EmailId" style="width: 100px; text-align: center;">Email ID</td>
                                      <%--  <td class="Mob" style="width: 100px; text-align: center;">Contact No.</td>--%>
                                        <td class="address" style=" text-align: center;">Address</td>
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
                                <select class="form-control border-primary input-sm" style="display:none;" id="ddlPageSize" onchange="BindVendorList(1)">
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


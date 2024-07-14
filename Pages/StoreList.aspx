<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="StoreList.aspx.cs" Inherits="Pages_StoreList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>Store List
            <a href="/Pages/CompanyProfile.aspx" class="btn btn-sm btn-warning pull-right">Add New Store</a>
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
                        <div class="row" style="margin-bottom:10px">
                            <div class="col-md-2">
                                <label>Store Name</label>
                                <input type="text" id="txtSCompanyName" onkeypress="return /[0-9a-zA-Z ]/i.test(event.key)" maxlength="60" class="form-control input-sm" placeholder="Store Name" />
                            </div>
                            <div class="col-md-2">
                                 <label>Contact Person</label>
                                <input type="text" id="txtSContact" maxlength="60" onkeypress="return /[0-9a-zA-Z ]/i.test(event.key)" class="form-control input-sm" placeholder="Contact Person" />
                            </div>
                            <div class="col-md-2">
                                <label>Mobile No.</label>
                                <input type="text" id="txtSmob" onpaste="return false;" onkeypress="return isNumberKey(event)"  maxlength="10" class="form-control input-sm" placeholder="Mobile No." />

                            </div>
                            <div class="col-md-2">
                                 <label>Website</label>
                                <input type="text" id="txtSWebsite" class="form-control input-sm" placeholder="Website " />
                            </div>

                            <div class="col-md-2">
                                <label>Status</label>
                                <select id="ddlStoreStatus" style="padding-top:2px" class="form-control input-sm d-flex align-items-center">
                                    <option value="2" selected="selected">All Status</option>
                                    <option value="1">Open</option>
                                    <option value="0">Close</option>
                                </select>
                            </div>

                            <div class="col-md-2">
                                <button id="btnSearch" style="margin-top:29px; " type="button" onclick="BindStoreList(1);" class="btn btn-md catsearch-btn pull-right">Search</button>
                            </div>
                        </div>

                        <%--<div class="row">--%>
                        <div class="table-responsive">
                            <table id="tblStoreList" class="table table-striped table-bordered well" style="margin-bottom: 0px;display:none;">
                                <thead>
                                    <tr class="thead">
                                        <td class="Action" style="width: 5%;">Action</td>
                                        <td class="StoreAutoId" style="display: none;">StoreAutoId</td>
                                        <td class="CompanyName" style="white-space: nowrap; text-align: center; width: 20%">Store Name</td>
                                        <td class="ContactName" style="white-space: nowrap; text-align: center; width: 20%">Contact Person</td>
                                        <td class="Website" style="white-space: nowrap; text-align: center; width: 20%">Website</td>
                                        <td class="Address" style="white-space: nowrap; text-align: center; width: 40%">Billing Address</td>
                                        <td class="Currency" style="width: 100px; text-align: center;">Currency</td>
                                         <%--<td class="State" style="width: 100px; text-align: center;">State</td>
                                        <td class="Country" style="width: 100px; text-align: center;">Country</td>
                                        <td class="ZipCode" style="width: 100px; text-align: center;">Zip Code</td>--%>
                                        <td class="Mob" style="width: 100px; text-align: center;">Mobile No.</td>
                                        <td class="Status" style="width: 100px; text-align: center;">Status</td>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>
                            <h5 class="well text-center" id="EmptyTable" style="display: none">No data available.</h5>

                            <%--</div>--%>
                        </div>
                        <div class="form-group row" style="padding-bottom: 0px; margin-bottom: 0px; margin-top: 10px;" id="DivPager">
                            <div class="col-md-1">
                                <select class="form-control border-primary input-sm" style="width:100px;display:none;" id="ddlPageSize" onchange="BindStoreList(1)">
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


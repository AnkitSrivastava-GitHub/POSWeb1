<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="StoreLoginLogReport.aspx.cs" Inherits="Pages_StoreLoginLogReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <section class="content-header">
        <h1>Store Login Report
        </h1>
    </section>
    <div class="content" ondragstart="return false;" ondrop="return false;">
        <div class="row">
            <div class="col-md-12">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <b>Store Login Report</b>
                    </div>
                    <div class="panel-body">
                        <div class="row">
                            <div class="col-md-3 form-group">
                                <label> Employee Name</label>
                                    <input type="text" id="txtEmpName" style="text-align: left;" class="form-control input-sm" placeholder="Enter Employee Name" />
                            </div>
                            <div class="col-md-2 form-group">
                                <label>Select From Date</label>
                                <input type="text" id="txtFromDate" style="text-align: left;" class="form-control input-sm date" readonly="readonly" />
                            </div>
                            <div class="col-md-2 form-group">
                                <label>Select To Date</label>
                                <input type="text" id="txtToDate" style="text-align: left" class="form-control input-sm date" readonly="readonly" />

                            </div>
                            <%--<div class="col-md-2 form-group">
                                <label>Store</label>
                                <select id="ddlStore" class="form-control input-sm">
                                    <option value="0">All</option>
                                </select>
                            </div>--%>
                            <div class="col-md-2 form-group">
                                <label>Status</label>
                                <select id="ddlStatus" class="form-control input-sm">
                                    <option value="2">All</option>
                                    <option value="Success">Success</option>
                                    <option value="Failed">Failed</option>
                                </select>
                            </div>

                            <div class="col-md-2 form-group" style="text-align: right; padding-top: 30px">
                                <label></label>
                                <button type="button" id="btnLoginReport" onclick="BindStoreLoginLogList(1);" class="btn btn-sm catsearch-btn">Search</button>
                            </div>
                        </div>
                        <div class="table-responsive" style="padding-top: 5px;">
                            <table id="tblStoreLoginList" class="table table-striped table-bordered well" style="margin-bottom: 0px;display:none;">
                                <thead>
                                    <tr class="thead">
                                        <%-- <td class="Action" style="width: 50px; text-align: center;">Action</td>--%>
                                        <td class="StoreAutoId" style="white-space: nowrap; text-align: center; display: none;">UserAutoId</td>
                                        <td class="StoreName" style="white-space: nowrap; text-align: center;display:none;">Store Name</td>
                                        <td class="UserName" style="white-space: nowrap; text-align: center">Employee Name</td>
                                        <td class="UserType" style="white-space: nowrap; text-align: center">Employee Type</td>
                                        <td class="LoginDateTime" style="white-space: nowrap; text-align: center">Date & Time</td>
                                        <td class="IPAddress" style="white-space: nowrap; text-align: center">IP Address</td>
                                        <%--<td class="Store" style="white-space: nowrap; text-align: center">Store</td>--%>
                                        <%--<td class="Terminal" style="white-space: nowrap; text-align: center">Terminal</td>--%>
                                        <td class="Status" style="white-space: nowrap; text-align: center">Status</td>
                                    </tr>
                                </thead>
                            </table>
                            <h5 class="well text-center" id="EmptyTable" style="display: none">No data available.</h5>
                        </div>
                        <div class="form-group row" style="padding-bottom: 0px; margin-bottom: 0px; margin-top: 10px;" id="DivPager">
                            <div class="col-md-1">
                                <select class="form-control border-primary input-sm" id="ddlPageSize" style="display:none;" onchange="BindStoreLoginLogList(1)">
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


<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="NoSaleList.aspx.cs" Inherits="Pages_NoSaleList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <section class="content-header">
        <h1>No Sale Report
            <%--<a href="/Pages/POSScreen.aspx" class="btn btn-sm btn-warning pull-right">Create Invoice</a>--%>
        </h1>
    </section>
    <div class="content" id="divForm"  ondragstart="return false;" ondrop="return false;">
        <div class="row">
            <div class="col-md-12">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <b>No Sale Report</b>
                    </div>
                    <div class="panel-body">
                        <div class="row">
                            <div class="col-md-3 form-group">
                                <label>Select Employee</label>
                                <select id="ddlEmployee" class="form-control">
                                    <option value="0">All Employee</option>
                                </select>
                            </div>
                             <div class="col-md-2 form-group">
                                <label>Employee Type</label>
                                <select id="ddlUserType" class="form-control">
                                    <option value="0">All User</option>
                                </select>
                            </div>
                            <div class="col-md-2 form-group">
                                 <label>Select From Date</label>
                                <input type="text" id="txtFromDate" style="text-align:left" class="form-control input-sm date" readonly="readonly" />
                            </div>
                            <div class="col-md-2 form-group">
                                <label>Select To Date</label>
                               <input type="text" id="txtToDate" style="text-align:left" class="form-control input-sm date" readonly="readonly" />                               

                            </div>
                            <div class="col-md-3 form-group" style="text-align: right;padding-top:30px">
                                <label></label>
                                <button type="button" id="btnNoSaleReport" onclick="BindNoSaleReport(1);" class="btn btn-sm catsearch-btn">Search</button>
                            </div>
                        </div>
                        <div class="table-responsive" style="padding-top: 5px;">
                            <table id="tblNoSaleList" class="table table-striped table-bordered well" style="margin-bottom: 0px;display:none;">
                                <thead>
                                    <tr class="thead">
                                       <%-- <td class="Action" style="width: 50px; text-align: center;">Action</td>--%>
                                        <td class="NosaleAutoId" style="white-space: nowrap; text-align: center; display: none;">NosaleAutoId</td>
                                        <td class="OpenBy" style="white-space: nowrap; text-align: center">Open By</td>
                                        <td class="Terminal" style="white-space: nowrap; text-align: center">Terminal</td>
                                        <td class="Time" style="white-space: nowrap; text-align: center">Creation Date & Time</td>
                                        <td class="UserType" style="white-space: nowrap; text-align: center">Employee Type</td>
                                        <td class="Remark" style="width:650px; text-align: center">Remark</td>
                                    </tr>
                                </thead>
                            </table>
                            <h5 class="well text-center" id="EmptyTable" style="display: none">No data available.</h5>
                        </div>
                        <div class="form-group row" style="padding-bottom: 0px; margin-bottom: 0px; margin-top: 10px;" id="DivPager">
                            <div class="col-md-1">
                                <select class="form-control border-primary input-sm" id="ddlPageSize" style="display:none;" onchange="BindNoSaleReport(1)">
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


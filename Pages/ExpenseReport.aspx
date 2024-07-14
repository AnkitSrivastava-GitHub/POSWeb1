<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="ExpenseReport.aspx.cs" Inherits="Pages_ExpenseReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>Expense Report
        </h1>
    </section>
    <div class="content" id="divForm" ondragstart="return false;" ondrop="return false;">
        <div class="row">
            <div class="col-md-12">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <b>Expense Report </b>
                    </div>
                    <div class="panel-body">
                        <div class="row">
                            <div class="col-md-3 form-group">
                                <label>Terminal</label>
                                <select id="ddlTerminal" class="form-control">
                                    <option value="0">All Terminal</option>
                                </select>
                            </div>
                            <div class="col-md-3 form-group">
                                <label>Expense</label>
                                <select id="ddlExpense" class="form-control">
                                    <option value="0">All Expense</option>
                                </select>
                            </div>
                            <div class="col-md-2 form-group">
                                <label>Payout From Date</label>
                                <input type="text" id="txtFromDate" style="text-align: left" placeholder="Select From Date" class="form-control input-sm date" readonly="readonly" />
                            </div>
                            <div class="col-md-2 form-group">
                                <label>Payout To Date</label>
                                <input type="text" id="txtToDate" style="text-align: left" placeholder="Select To Date" class="form-control input-sm date" readonly="readonly" />

                            </div>
                            <div class="col-md-2 form-group" style="margin-top: 30px">
                                <div class="pull-right">
                                    <button type="button" id="btnExpenseReport" onclick="BindExpenseReport(1);" class="btn btn-sm catsearch-btn pull-right">Search</button>
                                </div>
                            </div>
                        </div>
                        <div class="table-responsive" style="padding-top: 5px;">
                            <table id="tblExpenseList" class="table table-striped table-bordered well" style="margin-bottom: 0px;display:none;">
                                <thead>
                                    <tr class="thead">
                                        <%-- <td class="Action" style="width: 50px; text-align: center;">Action</td>--%>
                                        <td class="ClockInOutAutoId" style="white-space: nowrap; text-align: center; display: none;">ClockInOutAutoId</td>
                                        <td class="TerminalName" style="white-space: nowrap; text-align: center">Terminal Name</td>
                                        <td class="Expense" style="white-space: nowrap; text-align: center">Expense</td>
                                        <td class="PayTo" style="white-space: nowrap; text-align: center">Pay To</td>
                                        <td class="Amount" style="white-space: nowrap; text-align: center">Amount (<span class="symbol"></span>)</td>
                                        <td class="PayoutMode" style="white-space: nowrap; text-align: center">Payout Mode</td>
                                        <td class="Remark" style="white-space: nowrap; text-align: center">Remark</td>
                                        <td class="PayoutDateTime" style="white-space: nowrap; text-align: center">Payout Date & Time</td>
                                        <td class="CreationDetail" style="white-space: nowrap; text-align: center">Creation Detail</td>
                                    </tr>
                                </thead>                               
                            </table>
                            <h5 class="well text-center" id="EmptyTable" style="display: none">No data available.</h5>
                        </div>
                        <div class="form-group row" style="padding-bottom: 0px; margin-bottom: 0px; margin-top: 10px;" id="DivPager">
                            <div class="col-md-1">
                                <select class="form-control border-primary input-sm" style="width: 100px;display:none;" id="ddlPageSize" onchange="BindExpenseReport(1)">
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


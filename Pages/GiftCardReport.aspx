<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="GiftCardReport.aspx.cs" Inherits="Pages_GiftCardReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>Gift Card Report
        </h1>
    </section>
    <div class="content" ondragstart="return false;" ondrop="return false;">
        <div class="row">
            <div class="col-md-12">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <b>Gift Card Report</b>
                    </div>
                    <div class="panel-body">
                        <div class="row">
                            <div class="col-md-3 form-group">
                                <label>Customer Name</label>
                                <input type="text" id="txtCustomer" style="text-align: left" class="form-control input-sm " placeholder="Customer Name" />
                            </div>
                            <div class="col-md-2 form-group">
                                <label>Invoice No.</label>
                                <input type="text" id="txtInvoice" style="text-align: left" onkeypress="return isNumberKey(event)" class="form-control input-sm " placeholder="Invoice No." />
                            </div>
                            <div class="col-md-2 form-group">
                                <label>Customer Mobile No.</label>
                                <input type="text" id="txtMobile" maxlength="10" style="text-align: left" onkeypress="return isNumberKey(event)" class="form-control input-sm " placeholder="Mobile No." />
                            </div>
                            <div class="col-md-3 form-group">
                                <label>Customer Email ID</label>
                                <input type="text" id="txtEmail" style="text-align: left" class="form-control input-sm " placeholder="Email ID" />
                            </div>

                            <div class="col-md-2 form-group" style="display: none">
                                <label>Terminal</label>
                                <select id="ddlTerminal" class="form-control input-sm">
                                    <option value="0">All Terminal</option>
                                </select>
                            </div>
                            <div class="col-md-2 form-group">
                                <label>Status</label>
                                <select id="ddlStatus" class="form-control input-sm">
                                    <option value="5">All</option>
                                    <option value="1">Sold</option>
                                    <option value="4">Partial</option>
                                    <option value="2">Close</option>
                                </select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-2 form-group">
                                <label>Select From Date</label>
                                <input type="text" id="txtFromDate" style="text-align: left;" class="form-control input-sm date" placeholder="Select From Date" readonly="readonly" />
                            </div>
                            <div class="col-md-2 form-group">
                                <label>Select To Date</label>
                                <input type="text" id="txtToDate" style="text-align: left" class="form-control input-sm date" placeholder="Select To Date" readonly="readonly" />
                            </div>

                            <div class="col-md-8 form-group" style="text-align: right; padding-top: 30px">
                                <label></label>
                                <button type="button" id="btnGiftReport" onclick="BindGiftCard(1);" class="btn btn-sm catsearch-btn">Search</button>
                            </div>
                        </div>
                        <div class="table-responsive" style="padding-top: 5px;">
                            <table id="tblGiftList" class="table table-striped table-bordered well" style="margin-bottom: 0px;display:none">
                                <thead>
                                    <tr class="thead">
                                        <td class="AutoId" style="white-space: nowrap; text-align: center; display: none;">AutoId</td>
                                        <td class="GiftCardCode" style="white-space: nowrap; text-align: center">Gift Card Code</td>
                                        <td class="TotalAmt" style="white-space: nowrap; text-align: center">Total Amount (<span class="symbol"></span>)</td>
                                        <td class="LeftAmt" style="white-space: nowrap; text-align: center">Left Amount (<span class="symbol"></span>)</td>
                                        <td class="GiftCardPurchaseInvoice" style="white-space: nowrap; text-align: center">Purchase Invoice No.</td>
                                        <td class="SoldDate" style="white-space: nowrap; text-align: center">Sold Date</td>
                                        <td class="Customers" style="white-space: nowrap; text-align: center">Customer</td>
                                        <td class="Mobile" style="white-space: nowrap; text-align: center">Mobile No.</td>
                                        <td class="Email" style="white-space: nowrap; text-align: center">Email Id</td>
                                        <td class="Status" style="white-space: nowrap; text-align: center">Status</td>
                                        <td class="CompanyName" style="white-space: nowrap; text-align: center">Store Name</td>
                                        <td class="TerminalName" style="white-space: nowrap; text-align: center">Terminal Name</td>
                                        <td class="SoldBy" style="white-space: nowrap; text-align: center">Sold By</td>
                                    </tr>
                                </thead>
                            </table>
                            <h5 class="well text-center" id="EmptyTable" style="display: none">No data available.</h5>
                        </div>
                        <div class="form-group row" style="padding-bottom: 0px; margin-bottom: 0px; margin-top: 10px;" id="DivPager">
                            <div class="col-md-1">
                                <select class="form-control border-primary input-sm" id="ddlPageSize" style="display:none;" onchange="BindGiftCard(1)">
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


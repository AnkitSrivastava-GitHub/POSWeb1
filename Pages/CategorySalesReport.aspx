<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="CategorySalesReport.aspx.cs" Inherits="Pages_CategorySalesReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="content" id="divForm" ondragstart="return false;" ondrop="return false;">
        <div class="row">
            <div class="col-md-12">
                <div class="panel panel-default">
                    <%-- <div class="panel-heading" style="text-align: center;">
                        <b>Category Sales Report</b>
                    </div>--%>
                    <div class="panel-body">
                        <div class="row">
                            <div class="col-md-3">
                                <input type="text" id="txtAllReportDate" onchange="FilledDate()" class="form-control input-sm date"  readonly="readonly" />
                            </div>
                            <div class="col-md-3">
                                <select id="ddlAllReportTerminal" onchange="getShiftList()" class="form-control input-sm">
                                    <option value="0">All Terminal</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <select id="ddlAllShift" class="form-control input-sm">
                                    <option value="0">All Shift</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <button id="btnAllReportSearch" type="button" onclick="SearchAllReports(1);" class="btn btn-sm catsearch-btn pull-right">Search</button>
                            </div>
                        </div>
                        <div class="form-group"></div>


                    </div>
                </div>
            </div>
            <div class="col-md-12">
                <div class="panel panel-default">
                    <%--<div class="panel-heading" style="text-align: center;">
                        <b>Ticket Sale Report</b>

                    </div>--%>
                    <div class="panel-body">
                      <%--  <div class="form-group"></div>--%>
                        <div class="table-responsive">
                            <table id="tblCurrentCashList" class="table table-striped table-bordered well" style="margin-bottom: 0px;">
                                <thead>
                                    <tr class="thead">
                                        <td class="Openbal" style="white-space: nowrap; text-align: center;">Open Balance(<span class="symbol"></span>)</td>
                                        <td class="CashTotalTrs" style="white-space: nowrap; text-align: center;">Total Cash Transaction(<span class="symbol"></span>)</td>
                                        <td class="PayoutInCash" style="white-space: nowrap; width: 100px; text-align: right;">Payout In Cash(<span class="symbol"></span>)</td>
                                        <td class="SafeDepositeCash" style="white-space: nowrap; width: 100px; text-align: right;">Safe Deposit Cash(<span class="symbol"></span>)</td>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                                <tfoot>
                                    <tr>
                                        <td style="text-align: right" colspan="3"><strong>Current Drawer Cash(Open Balance + Total Cash Transaction - Payout In Cash - Safe Deposit Cash) :</strong></td>
                                        <td style="text-align: right"><strong><span id="spnCurrencySymbol"></span><span id="CurrentCash"></span></strong></td>
                                    </tr>
                                </tfoot>
                            </table>
                            <h5 class="well text-center" id="CurrentCashEmptyTable" style="display: none">No data available.</h5>
                        </div>

                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <input type="hidden" id="hdnBrandId" />

            <div class="col-md-4">
                <div class="panel panel-default">
                    <div class="panel-heading" style="text-align: center;">
                        <b>Category Sales Report</b>

                    </div>
                    <div class="panel-body">
                        <div class="row" style="display: none;">
                            <div class="col-md-4">
                                <input type="text" id="txtCatSaleDate" class="form-control input-sm date" readonly="readonly" />
                            </div>
                            <div class="col-md-6">
                                <select id="ddlCategorySalesTerminal" class="form-control input-sm">
                                    <option value="0">All Terminal</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <button id="btnCategorySalesSearch" type="button" onclick="BindCategorySalesReport(1);" class="btn btn-sm catsearch-btn pull-right">Search</button>
                            </div>
                        </div>
                        <%--<div class="form-group"></div>--%>
                        <div class="table-responsive">
                            <table id="tblCategorySalesList" class="table table-striped table-bordered well" style="margin-bottom: 0px;">
                                <thead>
                                    <tr class="thead">
                                        <td class="CategoryAutoId" style="display: none;">BrandAutoId</td>
                                        <td class="CategoryName" style="white-space: nowrap; text-align: center;">Category Name</td>
                                        <td class="CategorySaleAmount" style="width: 100px; text-align: right;">Amount(<span class="symbol"></span>)</td>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                                <tfoot>
                                    <tr>
                                        <td style="text-align: right"><strong>Total :</strong></td>
                                        <td style="text-align: right"><strong><span class="symbol"></span><span id="CatSalestotal"></span></strong></td>
                                    </tr>
                                </tfoot>
                            </table>
                            <h5 class="well text-center" id="CategorySaleEmptyTable" style="display: none">No data available.</h5>
                        </div>
                        <div class="form-group row" style="padding-bottom: 0px; margin-bottom: 0px; margin-top: 10px; display: none;" id="CategorySaleDivPager">
                            <div class="col-md-3">
                                <select class="form-control border-primary input-sm" id="ddlCategorySalePageSize" onchange="BindCategorySalesReport(1);">
                                    <option value="10">10</option>
                                    <option value="50">50</option>
                                    <option value="100">100</option>
                                    <option value="500">500</option>
                                    <option value="1000">1000</option>
                                    <option value="0">All</option>
                                </select>
                            </div>
                            <div class="col-md-7" style="width:74%">
                                <div class="Pager CategorySalePager" id="CategorySalePager"></div>
                            </div>
                            <div class="col-md-2 text-right">
                                <span id="spCategorySaleSortBy" style="color: red; font-size: small;"></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-4" id="divLottery" style="display:none">
                <div class="panel panel-default">
                    <div class="panel-heading" style="text-align: center;">
                        <b>Ticket Sale Report</b>

                    </div>
                    <div class="panel-body">
                        <div class="row" style="margin-bottom: 10px; display: none;">
                            <div class="col-md-4">
                                <input type="text" id="txtTicketSaleDate" class="form-control input-sm date" readonly="readonly" />
                            </div>
                            <div class="col-md-6">
                                <select id="ddlTicketSaleTerminal" class="form-control input-sm">
                                    <option value="0">All Terminal</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <button id="btnTicketSaleSearch" type="button" onclick="BindTicketSalesReport(1);" class="btn btn-sm catsearch-btn pull-right">Search</button>
                            </div>
                        </div>
                       <%-- <div class="form-group"></div>--%>
                        <div class="table-responsive">
                            <table id="tblTicketSaleList" class="table table-striped table-bordered well" style="margin-bottom: 0px;">
                                <thead>
                                    <tr class="thead">
                                        <td class="TicketAutoId" style="display: none;">BrandAutoId</td>
                                        <td class="TicketsName" style="white-space: nowrap; text-align: center;">Tickets</td>
                                        <td class="TicketSaleAmount" style="width: 100px; text-align: right;">Amount(<span class="symbol"></span>)</td>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                                <tfoot>
                                    <tr>
                                        <td style="text-align: right"><strong>Total :</strong></td>
                                        <td style="text-align: right"><strong><span class="symbol"></span><span id="TicketSalestotal"></span></strong></td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: right"><strong>Lottery Payout :</strong></td>
                                        <td style="text-align: right"><strong><span class="symbol"></span><span id="LottoPayOut"></span></strong></td>
                                    </tr>
                                </tfoot>
                            </table>
                            <h5 class="well text-center" id="TicketSaleEmptyTable" style="display: none">No data available.</h5>
                        </div>
                        <div class="form-group row" style="padding-bottom: 0px; margin-bottom: 0px; margin-top: 10px;" id="DivTicketSalePager">
                            <div class="col-md-3">
                                <select class="form-control border-primary input-sm" id="ddlTicketSalePageSize" onchange="">
                                    <option value="10">10</option>
                                    <option value="50">50</option>
                                    <option value="100">100</option>
                                    <option value="500">500</option>
                                    <option value="1000">1000</option>
                                    <option value="0">All</option>
                                </select>
                            </div>
                            <div class="col-md-7">
                                <div class="TicketSalePager" id="TicketSalePager"></div>
                            </div>
                            <div class="col-md-2 text-right">
                                <span id="spTicketSaleSortBy" style="color: red; font-size: small;"></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="panel panel-default">
                    <div class="panel-heading" style="text-align: center">
                        <b>Payment details</b>

                    </div>
                    <div class="panel-body">
                        <div class="row" style="margin-bottom: 10px; display: none;">
                            <div class="col-md-4">
                                <input type="text" id="txtPaymentdetailsDate" class="form-control input-sm date" readonly="readonly" />
                            </div>
                            <div class="col-md-6">
                                <select id="ddlPaymentDetailsTerminal" class="form-control input-sm">
                                    <option value="0">All Terminal</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <button id="btnPayment detailsSearch" type="button" onclick="BindTransDetailsReport();" class="btn btn-sm catsearch-btn pull-right">Search</button>
                            </div>
                        </div>
                      <%--  <div class="form-group"></div>--%>
                        <div class="table-responsive">
                            <table id="tblPaymentDetailsList" class="table table-striped table-bordered well" style="margin-bottom: 0px;">
                                <thead>
                                    <tr class="thead">
                                        <td class="PaymentMethods" style="text-align: center;">Payment Methods</td>
                                        <td class="TransTotal" style="text-align: right; width: 100px;">Amount(<span class="symbol"></span>)</td>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                                <tfoot>
                                    <tr>
                                        <td style="text-align: right"><strong>Total :</strong></td>
                                        <td style="text-align: right"><strong><span class="symbol"></span><span id="Salestotal"></span></strong></td>
                                    </tr>
                                </tfoot>
                            </table>
                            <h5 class="well text-center" id="PaymentDetailsEmptyTable" style="display: none">No data available.</h5>
                        </div>
                    </div>
                </div>
            </div>



        <%--</div>
        <div class="row">--%>
            <div class="col-md-4">
                <div class="panel panel-default">
                    <div class="panel-heading" style="text-align: center">
                        <b>Payout Report</b>

                    </div>
                    <div class="panel-body">
                        <div class="row" style="margin-bottom: 10px; display: none;">
                            <div class="col-md-4">
                                <input type="text" id="txtLottoPayoutDate" class="form-control input-sm date" readonly="readonly" />
                            </div>
                            <div class="col-md-6">
                                <select id="ddlLottoPayoutTerminal" class="form-control input-sm">
                                    <option value="0">All Terminal</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <button id="btnLottoPayoutSearch" type="button" onclick="BindPayoutReport()" class="btn btn-sm catsearch-btn pull-right">Search</button>
                            </div>
                        </div>

                        <%--<div class="form-group"></div>--%>
                        <div class="table-responsive">
                            <table id="tblLottoPayoutList" class="table table-striped table-bordered well" style="margin-bottom: 0px;">
                                <thead>
                                    <tr class="thead">
                                        <td class="BrandAutoId" style="display: none;">BrandAutoId</td>
                                        <td class="LottoPayoutName" style="white-space: nowrap; text-align: center;">Payout</td>
                                        <td class="LottoPayoutAmount" style="width: 100px; text-align: right;">Amount(<span class="symbol"></span>)</td>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                                <tfoot>
                                    <tr>
                                        <td style="text-align: right"><strong>Total :</strong></td>
                                        <td style="text-align: right"><strong><span class="symbol"></span><span id="PayoutTotal"></span></strong></td>
                                    </tr>
                                </tfoot>
                            </table>
                            <h5 class="well text-center" id="LottoPayoutEmptyTable" style="display: none">No data available.</h5>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</asp:Content>


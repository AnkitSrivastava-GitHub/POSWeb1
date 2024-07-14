<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="PayoutMaster.aspx.cs" Inherits="Pages_PayoutMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <style>
        .Add-btnp {
            width: 33px;
            height: 32px;
            position: absolute;
            top: 3px;
            right: 25px;
            z-index: 5;
            cursor: pointer;
            border: 0;
            padding: 0px;
            font-size: 0px;
            background-color: gold;
        }
    </style>
    <section class="content-header">
        <h1>Payout Master</h1>
    </section>
    <div class="content" id="divForm" ondragstart="return false;" ondrop="return false;">
        <div class="row">
            <input type="hidden" id="hdnPayoutId" />
            <div class="col-md-12">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <b>Payout List</b>
                        <img src="../Style/img/add-png.png" class="Add-btnp" style="display:none" onclick="OpenModel();" id="btnAdd" />
                    </div>
                    <div class="panel-body">
                        <div class="row" style="margin-bottom: 10px;">
                            <div class="col-md-4" style="display: none">
                                <select id="ddlSCompanyName" style="padding-top: 2px;" class="form-control input-sm">
                                    <option value="0">All Company</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <input type="text" id="txtSFromDate" class="form-control input-sm date" placeholder="From Date" readonly="readonly" />
                            </div>
                            <div class="col-md-3">
                                <input type="text" id="txtSToDate" class="form-control input-sm date" placeholder="To Date" readonly="readonly" />
                            </div>
                            <%--</div>
                        <div class="row">--%>
                            <div class="col-md-3">
                                <input type="text" id="txtSPayTo" maxlength="80" class="form-control input-sm" placeholder="Pay To" />
                            </div>
                            <div class="col-md-3">
                                <div class="input-group">
                                    <span class="input-group-addon input-sm symbol"></span>
                                    <input type="text" id="txtSAmount" maxlength="9" onpaste="return false" class="form-control input-sm" ondrop="return false;" placeholder="0.00" onkeypress="return isNumberDecimalKey(event,this)" style="text-align: right;" />
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <select id="ddlSTerminal" style="padding-top: 2px;" class="form-control input-sm">
                                    <option value="0">All Terminal</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <select id="ddlPayoutType1" onchange="BindDDLExpenseVendor1();" class="form-control input-sm" style="padding-top: 2px;">
                                    <option value="0">Select</option>
                                </select>
                            </div>

                            <div class="col-md-3 Expense1" style="display: none">
                                <select id="ddlExpense1" class="form-control input-sm" style="padding-top: 2px;">
                                    <option value="0">Select Expense</option>
                                </select>
                            </div>

                            <div class="col-md-3 Vendor1" style="display: none">
                                <select id="ddlVendor1" class="form-control input-sm" style="padding-top: 2px;">
                                    <option value="0">Select Vendor</option>
                                </select>
                            </div>
                            <div class="col-md-3 ExVe"></div>
                            <div class="col-md-3">
                                <button id="btnSearch" type="button" onclick="BindPayoutList(1);" class="btn btn-sm catsearch-btn pull-right">Search</button>
                            </div>
                        </div>


                        <div class="form-group"></div>
                        <div class="table-responsive">
                            <table id="tblPayoutList" class="table table-striped table-bordered well" style="margin-bottom: 0px; display: none;">
                                <thead>
                                    <tr class="thead">
                                        <td class="Action" style="width: 50px; display:none">Action</td>
                                        <td class="PayoutAutoId" style="display: none;">PayoutAutoId</td>
                                        <td class="CompanyName" style="white-space: nowrap; text-align: center; display: none">Company Name</td>
                                        <td class="PayTo" style="white-space: nowrap; text-align: center;">Pay To</td>
                                        <td class="PaymentMode" style="width: 100px; text-align: center;">Payment Mode</td>
                                        <td class="Amount" style="width: 100px; text-align: right;">Amount(<span class="symbol"></span>)</td>
                                        <td class="PayoutType" style="width: 100px; text-align: center;">Payout Type</td>
                                        <td class="Expenses" style="width: 100px; text-align: center;">Expense</td>
                                        <td class="Vendors" style="width: 100px; text-align: center;">Vendor</td>
                                        <td class="PayoutDate" style="width: 100px; text-align: center;">Payout Date</td>
                                        <td class="PayoutTime" style="width: 100px; text-align: center;">Payout Time</td>
                                        <td class="Remark" style="width: 100px; text-align: center;">Remark</td>
                                        <td class="Terminal" style="width: 100px; text-align: center;">Terminal</td>
                                        <td class="createdby" style="width: 100px; text-align: center;">Creation Details</td>
                                        <td class="UserType" style="width: 100px; text-align: center;">User Type</td>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                                <tfoot>
                                    <tr>
                                        <td colspan="1"></td>
                                        <td style="text-align: right"><b>Total</b></td>
                                        <td style="text-align: right"><b><span class="symbol" style="font-weight:600"></span></b>
                                            <label id="lblTotal">0.00</label>
                                        </td>
                                        <td></td>
                                    </tr>
                                </tfoot>
                            </table>
                            <h5 class="well text-center" id="EmptyTable" style="display: none">No data available.</h5>
                        </div>

                        <div class="form-group row" style="padding-bottom: 0px; margin-bottom: 0px; margin-top: 10px;" id="DivPager">
                            <div class="col-md-2">
                                <select class="form-control border-primary input-sm" id="ddlPageSize" style="display: none;" onchange="BindPayoutList(1)">
                                    <option value="10">10</option>
                                    <option value="50">50</option>
                                    <option value="100">100</option>
                                    <option value="500">500</option>
                                    <option value="1000">1000</option>
                                    <option value="0">All</option>
                                </select>
                            </div>
                            <div class="col-md-7">
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
    <div class="modal fade" id="ModalTerminal" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-dialog-centered actionb-p" role="document">
            <div class="modal-content card-p">
                <div class="modal-header cardm-head Deposit">
                    <h5 class="modal-title">Payout Details
                <img src="../Images/del.png" class="del-btnp" id="CloseModalD" data-dismiss="modal" />
                    </h5>
                </div>

                <div class="modal-body" style="padding: 15px 0 0 0;">
                    <div class="row" style="display: none">
                        <label class="col-md-4 form-group">
                            Company Name&nbsp;<span class="required">*</span>
                        </label>
                        <div class="col-md-8 form-group">
                            <select id="ddlCompanyName" style="padding-top: 2px;" class="form-control input-sm">
                                <option value="1">Select Company</option>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <label class="col-md-4 form-group">
                            Terminal&nbsp;<span class="required">*</span>
                        </label>
                        <div class="col-md-8 form-group">
                            <select id="ddlTerminal" style="padding-top: 2px;" class="form-control input-sm">
                                <option value="1">Select Terminal</option>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <label class="col-md-4 form-group">
                            Date&nbsp;<span class="required">*</span>
                        </label>
                        <div class="col-md-4 form-group">
                            <input type="text" id="txtDate" style="text-align: left" placeholder="Select Date" class="form-control input-sm" readonly="readonly" />
                        </div>
                        <%--<label class="col-md-2 form-group">
                            Time&nbsp;<span class="required">*</span>
                        </label>--%>
                        <div class="col-md-4 form-group">
                            <input type="text" id="txtTime" style="text-align: left" placeholder="Select Time" class="form-control input-sm" readonly="readonly" />
                        </div>
                    </div>
                    <div class="row">
                        <label class="col-md-4 form-group">
                            Payout Type<span class="required"> *</span>
                        </label>
                        <div class="col-md-8 form-group">
                            <select id="ddlPayoutType" onchange="BindDDLExpenseVendor();" class="form-control input-sm" style="padding-top: 2px;">
                                <option value="0">Select</option>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <label class="col-md-4 form-group Expense" style="display: none">
                            Expense<span class="required"> *</span>
                        </label>
                        <div class="col-md-8 form-group Expense" style="display: none">
                            <select id="ddlExpense" class="form-control input-sm" style="padding-top: 2px;">
                                <option value="0">Select Expense</option>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <label class="col-md-4 form-group Vendor" style="display: none">
                            Vendor<span class="required"> *</span>
                        </label>
                        <div class="col-md-8 form-group Vendor" style="display: none">
                            <select id="ddlVendor" class="form-control input-sm" style="padding-top: 2px;">
                                <option value="0">Select Vendor</option>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <label class="col-md-4 form-group">
                            Pay To<span class="required"> *</span>
                        </label>
                        <div class="col-md-8 form-group">
                            <input type="text" id="txtPayTo" maxlength="80" class="form-control input-sm" placeholder="Pay To" />
                        </div>
                    </div>
                    <div class="row">
                        <label class="col-md-4 form-group">
                            Amount<span class="required"> *</span>
                        </label>
                        <div class="col-md-8 form-group">
                            <div class="input-group">
                                <span class="input-group-addon input-sm symbol">$</span>
                                <input type="text" id="txtAmount" onpaste="return false" ondrop="return false;" maxlength="9" class="form-control input-sm" placeholder="0.00" style="text-align: right" onkeypress="return isNumberDecimalKey(event,this)" />

                            </div>

                        </div>
                    </div>
                    <div class="row">
                        <label class="col-md-4 form-group">
                            Payment Mode
                        </label>
                        <div class="col-md-8 form-group">
                            <select id="ddlPayoutmode" class="form-control input-sm" onchange="OpenOnline();" style="padding-top: 2px;">
                                <option value="Cash">Cash</option>
                                <%-- <option value="Online">Online</option>--%>
                            </select>
                        </div>
                    </div>
                    <div class="row" id="ddlTransactionId" style="display: none">
                        <label class="col-md-4 form-group">
                            Transaction ID <span class="required">*</span>
                        </label>
                        <div class="col-md-8 form-group">
                            <input type="text" id="txtTransactionId" placeholder="Enter Transaction ID" class="form-control input-sm" onkeypress="return alpha(event)" />
                        </div>
                    </div>
                    <div class="row">
                        <label class="col-md-4 form-group">
                            Remark<span class="required"> *</span>
                        </label>
                        <div class="col-md-8 form-group">
                            <%--<input type="text" id="txtRemark" class="form-control input-sm" placeholder="Remark" />--%>
                            <textarea id="txtRemark" maxlength="300" style="max-height: 95px; max-width: 403px; min-height: 95px; min-width: 403px;" class="form-control input-sm" placeholder="Remark"></textarea>
                        </div>
                    </div>
                    <hr />
                    <div class="row">
                        <div class="col-md-12 form-group">
                            <div class="pull-right">
                                <button type="button" id="btnSave" onclick="InsertPayout();" class="btn btn-sm catsave-btn">Save</button>
                                <button type="button" id="btnUpdate" onclick="UpdatePayout();" class="btn btn-sm catsave-btn" style="display: none">Update</button>
                                <button type="button" id="btnReset" onclick="Reset();" class="btn btn-sm catreset-btn">Reset</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>


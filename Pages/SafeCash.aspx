<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="SafeCash.aspx.cs" Inherits="Pages_SafeCash" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <style>
        .picker__holder {
            margin-left: -118px;
        }

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
        <h1>Safe Cash Master</h1>
    </section>
    <div class="content" id="divForm" ondragstart="return false;" ondrop="return false;">
        <div class="row">
            <input type="hidden" id="hdnSafeCashId" />
            <div class="col-md-12">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <b>Safe Cash List</b>
                        <img src="../Style/img/add-png.png" style="display:none" class="Add-btnp" onclick="OpenModel();" id="btnAdd" />
                    </div>
                    <div class="panel-body">
                        <div class="row" style="margin-bottom: 10px;">

                            <div class="col-md-2">
                                <label>Amount </label>
                                <div class="input-group">
                                    <span class="input-group-addon input-sm symbol">$</span>
                                    <input type="text" id="txtAmount1" maxlength="7" style="text-align: right" class="form-control input-sm" placeholder="0.00" value="0.00" oncopy="return false" onpaste="return false" oncut="return false" onkeypress="return isNumberDecimalKey(event, this)" />
                                </div>
                            </div>
                            <div class="col-md-3">
                                <label>Safe Cash Mode </label>
                                <select id="ddlMode2" class="form-control input-sm" style="font-size: 17px">
                                    <option value="0">All </option>
                                    <option value="1">Deposit</option>
                                    <option value="2">Withdraw</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                 <label>Terminal </label>
                                <select id="ddlSTerminal" class="form-control input-sm">
                                    <option value="0">All Terminal</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <label>From Date </label>
                                <input type="text" id="txtStartDate" class="form-control input-sm date" placeholder="From Date" style="background-color: white;" />
                            </div>
                            <div class="col-md-2">
                                <label>To Date </label>
                                <input type="text" id="txtEndDate" class="form-control input-sm date" placeholder="To Date" style="background-color: white;" />
                            </div>
                        </div>
                        <div class="row">
                            <label class="col-md-2 form-group">Total Safe Cash Amount</label>
                            <div class="col-md-2">
                                <label style="margin-left: 0px"><span id="Total">0.00</span></label>
                            </div>
                            <%-- <label class="col-md-3 form-group">Opening Safe Cash</label>
                            <div class="col-md-2">
                                <label style="margin-left: -25px"><span id="OTotal"></span></label>
                            </div>--%>
                            <div class="col-md-8 text-right">
                                <button id="btnSearch" type="button" onclick="BindSafeCashList(1);" class="btn btn-sm catsearch-btn pull-right">Search</button>
                            </div>
                        </div>
                        <div class="form-group"></div>
                        <div class="table-responsive">
                            <table id="tblSafeCashList" class="table table-striped table-bordered well" style="margin-bottom: 0px; display: none;">
                                <thead>
                                    <tr class="thead">
                                        <td class="Action" style="width: 100px;">Action</td>
                                        <td class="SafeCashAutoId" style="display: none;">SafeCashAutoId</td>
                                        <td class="Mode" style="white-space: nowrap; text-align: center;">Mode</td>
                                        <td class="Amount" style="white-space: nowrap; text-align: center;">Amount(<span class="symbol"></span>)</td>
                                        <td class="Remark" style="text-align: center;">Remark</td>
                                        <td class="CreatedDate" style="white-space: nowrap; text-align: center;">Creation Date & Time</td>
                                        <td class="CreatedBy" style="white-space: nowrap; text-align: center;">Created By</td>
                                        <td class="Terminal" style="white-space: nowrap; text-align: center;">Terminal</td>
                                        <td class="Status" style="white-space: nowrap; text-align: center;">Status</td>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                                <tfoot>
                                    <tr>
                                        <td colspan="2" style="white-space: nowrap; text-align: right; font-weight: 600">Total</td>
                                        <td style="white-space: nowrap; text-align: right; font-weight: 600"><span id="spn_TotalSafe"><span class="symbol"></span>0.00</span></td>
                                    </tr>
                                </tfoot>
                            </table>
                            <h5 class="well text-center" id="EmptyTable" style="display: none">No data available.</h5>
                        </div>
                        <div class="form-group row" style="padding-bottom: 0px; margin-bottom: 0px; margin-top: 10px;" id="DivPager">
                            <div class="col-md-2">
                                <select class="form-control border-primary input-sm" id="ddlPageSize" style="display: none;" onchange="BindSafeCashList(1)">
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
                                <span id="spSortBy" style="color: red; font-size: small; white-space: nowrap;"></span>
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
                    <h5 class="modal-title">Safe Cash Details
                    <img src="../Images/del.png" class="del-btnp" id="CloseModalD" data-dismiss="modal" />
                    </h5>
                </div>

                <div class="modal-body" style="padding: 15px 0 0 0;">
                    <div class="row">
                        <label class="col-md-4 form-group">
                            Terminal&nbsp;<span class="required">*</span>
                        </label>
                        <div class="col-md-8 form-group">
                            <select id="ddlTerminal" style="padding-top: 2px;" disabled="disabled" class="form-control input-sm">
                                <option value="1">Select Terminal</option>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <label class="col-md-4 form-group">
                            Safe Cash Mode<span class="required"> *</span>
                        </label>
                        <div class="col-md-8 form-group">
                            <select id="ddlMode" class="form-control input-sm" style="font-size: 17px">
                                <option selected="selected" value="0">Select Safe Cash Mode</option>
                                <option value="1">Deposit</option>
                                <option value="2">Withdraw</option>
                            </select>

                        </div>
                    </div>
                    <div class="row">
                        <label class="col-md-4 form-group">
                            Amount<span class="required"> *</span>
                        </label>
                        <div class="col-md-8 form-group">
                            <div class="input-group">
                                <span class="input-group-addon input-sm symbol"></span>
                                <input type="text" style="text-align: right" id="txtAmount" maxlength="7" value="0.00" oncopy="return false" oninput="process(this)" onpaste="return false" oncut="return false" onkeypress="return isNumberDecimalKey(event, this)" class="form-control input-sm" placeholder="0.00" />
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <label class="col-md-4 form-group">
                            Remark<%--<span class="required"> *</span>--%>
                        </label>
                        <div class="col-md-8 form-group">
                            <textarea type="text" maxlength="150" style="min-width: 402px; min-height: 78px; max-width: 402px; max-height: 150px;" id="txtRemark" class="form-control input-sm" placeholder="Remark"> </textarea>
                        </div>
                    </div>
                    <div class="row">
                        <label class="col-md-4 form-group">
                            Status
                        </label>
                        <div class="col-md-8 form-group">
                            <select id="ddlStatus" class="form-control input-sm" style="font-size: 17px;">
                                <option value="0">Open</option>
                                <option value="1">Close</option>
                            </select>
                        </div>
                    </div>
                    <hr />
                    <div class="row">
                        <div class="col-md-12 form-group">
                            <div class="pull-right">
                                <button type="button" id="btnSave" onclick="InsertSafeCash();" class="btn btn-sm catsave-btn">Save</button>
                                <button type="button" id="btnUpdate" onclick="UpdateSafeCash();" class="btn btn-sm catsave-btn" style="display: none">Update</button>
                                <button type="button" id="btnReset" onclick="Reset();" class="btn btn-sm catreset-btn" style="display: none">Reset</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>


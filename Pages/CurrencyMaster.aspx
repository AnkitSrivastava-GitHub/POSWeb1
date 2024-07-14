<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="CurrencyMaster.aspx.cs" Inherits="Pages_CurrencyMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>Currency Master</h1>
    </section>
    <div class="content" id="divForm" ondragstart="return false;" ondrop="return false;">
        <div class="row">
            <div class="col-md-5">
                <input type="hidden" id="hdnCurrencyId" />
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <b>Currency Master</b>
                    </div>
                    <div class="panel-body" id="panelStoreDetail">
                        
                        <div class="row">
                            <label class="col-md-4 form-group">
                                Amount<span class="required"> *</span>
                            </label>
                            <div class="col-md-8 form-group">
                                <input type="text" onkeypress="return isNumberDecimalKey(event,this)" maxlength="8" id="txtAmount" class="form-control input-sm" placeholder="0.00" />
                            </div>
                        </div>
                        <div>
                        </div>
                        <div class="row">
                            <label class="col-md-4 form-group">
                                Status<span class="required"> *</span>
                            </label>
                            <div class="col-md-8 form-group">
                                <select id="ddlStatus" class="form-control input-sm">
                                    <option value="1">Active</option>
                                    <option value="0">Inactive</option>
                                </select>

                            </div>
                        </div>
                        <hr />
                        <div class="row">
                            <div class="col-md-12 form-group">
                                <div class="pull-right">
                                    <button type="button" id="btnSave" onclick="InsertCurrency();" class="btn btn-sm catsave-btn">Save</button>
                                    <button type="button" id="btnUpdate" onclick="UpdateCurrency();" class="btn btn-sm catsave-btn" style="display: none">Update</button>
                                    <button type="button" id="btnReset" onclick="Reset();" class="btn btn-sm catreset-btn">Reset</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-7">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <b>Currency List</b>
                    </div>
                    <div class="panel-body">
                        <div class="row" style="margin-bottom: 10px;">
                           
                            <div class="col-md-3">
                                <input type="text" id="txtAmountT" onkeypress="return isNumberDecimalKey(event,this)" maxlength="8" class="form-control input-sm" placeholder="0.00" />
                            </div>
                            <div class="col-md-3">
                                <select id="ddlSStatus" class="form-control input-sm">
                                    <option value="2">All Status</option>
                                    <option value="1">Active</option>
                                    <option value="0">Inactive</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <button id="btnSearch" type="button" onclick="BindCurrencyList(1);" class="btn btn-sm catsearch-btn pull-right">Search</button>
                            </div>
                        </div>
                        <div class="form-group"></div>
                        <div class="table-responsive">
                            <table id="tblCurrencyList" class="table table-striped table-bordered well" style="margin-bottom: 0px;">
                                <thead>
                                    <tr class="thead">
                                        <td class="Action" style="width: 50px;">Action</td>
                                        <td class="CurrencyAutoId" style="display: none;">CurrencyAutoId</td>
                                        <td class="Amount" style="white-space: nowrap; text-align: center;">Amount</td>
                                        <td class="Status" style="width: 100px; text-align: center; text-align: center;">Status</td>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>
                            <h5 class="well text-center" id="EmptyTable" style="display: none">No data available.</h5>
                        </div>
                        <div class="form-group row" style="padding-bottom: 0px; margin-bottom: 0px; margin-top: 10px;" id="DivPager">
                            <div class="col-md-2">
                                <select class="form-control border-primary input-sm" id="ddlPageSize" onchange="BindCurrencyList(1)">
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
</asp:Content>


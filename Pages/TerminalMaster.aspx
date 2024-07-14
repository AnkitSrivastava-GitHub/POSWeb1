<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="TerminalMaster.aspx.cs" Inherits="Pages_TerminalMaster" %>

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
        <h1>Terminal Master</h1>
    </section>
    <div class="content" id="divForm" ondragstart="return false;" ondrop="return false;">
        <div class="row">
            <input type="hidden" id="hdnTerminalId" />
            <div class="col-md-12">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <b>Terminal List</b>
                        <img src="../Style/img/add-png.png" class="Add-btnp" onclick="OpenModel();" id="btnAdd" />
                    </div>
                    <div class="panel-body">
                        <div class="row" style="margin-bottom: 10px;">
                            <div class="col-md-3" style="display: none;">
                                <select id="ddlSCompanyName" style="padding-top: 2px;" class="form-control input-sm">
                                    <option value="0">All Store</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <input type="text" id="txtSTerminalName" class="form-control input-sm" placeholder="Terminal Name" />
                            </div>
                            <div class="col-md-3">
                                <input type="text" id="txtCurrentUser" class="form-control input-sm" placeholder="Current Cashier" />
                            </div>
                            <%--<div class="col-md-3">
                                <input type="text" id="ddlOccupyStatus" class="form-control input-sm" placeholder="Terminal Name" />
                            </div>--%>
                            <div class="col-md-3">
                                <select id="ddlSStatus" class="form-control input-sm">
                                    <option value="2">All Status</option>
                                    <option value="1">Active</option>
                                    <option value="0">Inactive</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <button id="btnSearch" type="button" onclick="BindTerminalList(1);" class="btn btn-sm catsearch-btn pull-right">Search</button>
                            </div>
                        </div>
                        <div class="form-group"></div>
                        <div class="table-responsive">
                            <table id="tblTerminalList" class="table table-striped table-bordered well" style="margin-bottom: 0px;display:none;">
                                <thead>
                                    <tr class="thead">
                                        <td class="Action" style="width: 50px;">Action</td>
                                        <td class="TerminalAutoId" style="display: none;">TerminalAutoId</td>
                                        <td class="CompanyName" style="white-space: nowrap; text-align: center; display: none;">Store Name</td>
                                        <td class="TerminalName" style="white-space: nowrap; text-align: center;">Terminal Name</td>
                                        <td class="CurrentUser" style="width: 150px; text-align: center;">Current Cashier</td>
                                        <td class="OccupyStatus" style="width: 150px; text-align: center;">Occupy Status</td>
                                        <td class="Status" style="width: 100px; text-align: center;">Status</td>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>
                            <h5 class="well text-center" id="EmptyTable" style="display: none">No data available.</h5>
                        </div>
                        <div class="form-group row" style="padding-bottom: 0px; margin-bottom: 0px; margin-top: 10px;" id="DivPager">
                            <div class="col-md-2">
                                <select class="form-control border-primary input-sm" id="ddlPageSize" style="display:none;" onchange="BindTerminalList(1)">
                                    <option value="10">10</option>
                                    <option value="50">50</option>
                                    <option value="100">100</option>
                                    <option value="500">500</option>
                                    <option value="1000">1000</option>
                                    <option value="0">All</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <div class="Pager" id="Pager"></div>
                            </div>
                            <div class="col-md-4 text-right">
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
                    <h5 class="modal-title">Terminal Details 
                    <img src="../Images/del.png" class="del-btnp" id="CloseModalD" data-dismiss="modal" />
                    </h5>
                </div>                
                <div class="modal-body" style="padding: 15px 0 0 0;">
                    <div class="row" style="display: none;">
                        <label class="col-md-4 form-group">
                            Store Name&nbsp;<span class="required">*</span>
                        </label>
                        <div class="col-md-8 form-group">
                            <select id="ddlCompanyName" style="padding-top: 2px;" class="form-control input-sm">
                                <option value="1">Select Store</option>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <label class="col-md-4 form-group">
                            Terminal Name<span class="required"> *</span>
                        </label>
                        <div class="col-md-8 form-group">
                            <input type="text" id="txtTerminalName" class="form-control input-sm" placeholder="Terminal Name" />
                        </div>
                    </div>
                    <div class="row">
                        <label class="col-md-4 form-group">
                            Terminal Address
                        </label>
                        <div class="col-md-8 form-group">
                            <input type="text" id="txtTerminalAddress" class="form-control input-sm" placeholder="Terminal Address" />
                        </div>
                    </div>
                    <div class="row">
                        <label class="col-md-4 form-group">
                            Status
                        </label>
                        <div class="col-md-8 form-group">
                            <select id="ddlStatus" class="form-control input-sm">
                                <option value="1">Active</option>
                                <option value="0">Inactive</option>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12 form-group">
                            <div class="pull-right">
                                <button type="button" id="btnSave" onclick="InsertTerminal();" class="btn btn-sm catsave-btn">Save</button>
                                <button type="button" id="btnUpdate" onclick="UpdateTerminal();" class="btn btn-sm catsave-btn" style="display: none">Update</button>
                                <button type="button" id="btnReset" onclick="Reset();" class="btn btn-sm catreset-btn">Reset</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>


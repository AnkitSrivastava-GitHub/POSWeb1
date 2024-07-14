<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="TermAndConditionMaster.aspx.cs" Inherits="Pages_TermAndConditionMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <section class="content-header">
        <h1>Terms And Conditions Master</h1>
    </section>
    <div class="content" id="divForm" ondragstart="return false;" ondrop="return false;">
        <div class="row">
            <div class="col-md-6">
                <input type="hidden" id="hdntermsId"/>
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <b>Order Details</b>
                    </div>
                    <div class="panel-body" id="panelStoreDetail">
                        <div class="row">
                            <label class="col-md-4 form-group">
                                Terms And Conditions<span class="required"> *</span>
                            </label>
                            <div class="col-md-8 form-group">
                                <textarea id="txtConditions" class="form-control input-sm" rows="5" placeholder="Terms And Conditions"></textarea>
                            </div>
                        </div>
                        <div class="row">
                            <label class="col-md-4 form-group">
                                Order<span class="required"> *</span>
                            </label>
                            <div class="col-md-8 form-group">
                                <select id="ddlOrder" class="form-control input-sm">
                                    <option value="0">Select Order</option>                         
                                </select>
                            </div>
                        </div>
                        <hr />
                        <div class="row">
                            <div class="col-md-12 form-group">
                                <div class="pull-right">
                                    <button type="button" id="btnSave" onclick="InsertTerms();" class="btn btn-sm btn-success">Save</button>
                                    <button type="button" id="btnUpdate" onclick="UpdateTerms();" class="btn btn-sm btn-primary" style="display: none">Update</button>
                                    <button type="button" id="btnReset" onclick="Reset();" class="btn btn-sm btn-default">Reset</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <b>Order List</b>
                    </div>
                    <div class="panel-body">
                        <div class="panel panel-default">
                            <div class="panel-body">
                                <div class="row">
                                    <div class="col-md-6">
                                        <input type="text" id="txtSTerms" class="form-control input-sm" placeholder="Terms and Conditions" />
                                    </div>
                                    <div class="col-md-4">
                                        <select id="ddlSOrder" class="form-control input-sm">
                                            <option value="0">All Order</option>
                                        </select>
                                    </div>
                                    <div class="col-md-2">
                                        <button id="btnSearch" type="button" onclick="BindTermsList(1);" class="btn btn-sm btn-success">Search</button>
                                    </div>
                                </div>
                                <div class="form-group"></div>                               
                            </div>
                        </div>
                        <div class="table-responsive">
                            <table id="tblOrderList" class="table table-striped table-bordered well">
                                <thead>
                                    <tr class="thead">
                                        <td class="Action" style="width: 50px;">Action</td>
                                        <td class="termsAutoId" style="display: none;">TermsAutoId</td>
                                        <td class="Terms" style="white-space: nowrap">Terms and Conditions</td>
                                        <td class="Order" style="width: 100px;text-align:center;">Order</td>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>
                            <h5 class="well text-center" id="EmptyTable" style="display: none">No data available.</h5>

                        </div>
                        <div class="form-group row" style="padding-bottom: 0px; margin-bottom: 0px; margin-top: 10px;" id="DivPager">
                            <div class="col-md-2">
                                <select class="form-control border-primary input-sm" id="ddlPageSize" onchange="BindTermsList(1)">
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
</asp:Content>


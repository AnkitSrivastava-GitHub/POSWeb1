<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="ModuleMaster.aspx.cs" Inherits="Pages_ModuleMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>Module Master</h1>
    </section>
    <div class="content" id="divForm" ondragstart="return false;" ondrop="return false;">
        <div class="row">
            <div class="col-md-5">
                <input type="hidden" id="hdnModuleId" />
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <b>Module Master</b>
                    </div>
                    <div class="panel-body" id="panelStoreDetail">
                        <div class="row">
                            <label class="col-md-4 form-group">
                                Module Name<span class="required"> *</span>
                            </label>
                            <div class="col-md-8 form-group">
                                <input type="text" onkeypress="return /[0-9a-zA-Z ]/i.test(event.key)" maxlength="100" id="txtModuleName" class="form-control input-sm" placeholder="Enter Module Name" />
                            </div>
                        </div>

                        <div>
                        </div>

                        <div class="row">
                            <label class="col-md-4 form-group">
                                Sequence No.
                            </label>
                            <div class="col-md-8 form-group">   
                                <input type="text" id="txtSeqNo" onkeypress="return isNumberKey(event)" class="form-control input-sm numbersOnly" maxlength="5" placeholder="Enter Sequence No." />
                            </div>
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
                                    <button type="button" id="btnSave" onclick="InsertModule();" class="btn btn-sm catsave-btn">Save</button>
                                    <button type="button" id="btnUpdate" onclick="UpdateModule();" class="btn btn-sm catsave-btn" style="display: none">Update</button>
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
                        <b>Module List</b>
                    </div>
                    <div class="panel-body">
                        <div class="row" style="margin-bottom: 10px;">
                            <div class="col-md-6">
                                <input type="text" id="txtModulesName" class="form-control input-sm" placeholder="Module Name" />
                            </div>
                            <div class="col-md-4">
                                <select id="ddlSStatus" class="form-control input-sm">
                                    <option value="2">All Status</option>
                                    <option value="1">Active</option>
                                    <option value="0">Inactive</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <button id="btnSearch" type="button" onclick="BindModuleList(1);" class="btn btn-sm catsearch-btn pull-right">Search</button>
                            </div>
                        </div>
                        <div class="form-group"></div>  
                        <div class="table-responsive">
                            <table id="tblModuleList" class="table table-striped table-bordered well" style="margin-bottom: 0px;">
                                <thead>
                                    <tr class="thead">
                                        <td class="Action" style="width: 50px;">Action</td>
                                        <td class="ModuleAutoId" style="display: none;">ModuleAutoId</td>
                                        <td class="ModuleName" style="white-space: nowrap; text-align: center;">Module Name</td>
                                        <td class="SequenceNo" style="white-space: nowrap; text-align: center;">Sequence No.</td>
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
                                <select class="form-control border-primary input-sm" id="ddlPageSize" onchange="BindCategoryList(1)">
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


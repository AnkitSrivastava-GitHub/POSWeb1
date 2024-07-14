<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="AgeRestrictionMaster.aspx.cs" Inherits="Pages_AgeRestrictionMaster" %>

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
        <h1>Age Restriction Master</h1>
    </section>
    <div class="content" id="divForm" ondragstart="return false;" ondrop="return false;">
        <div class="row">
            <input type="hidden" id="hdnAgeId" />
            <div class="col-md-12">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <b>Age Restriction List</b>
                          <img src="../Style/img/add-png.png" class="Add-btnp" onclick="OpenForInsert();" id="btnAdd" />
                    </div>
                    <div class="panel-body">
                        <div class="row">
                            <div class="col-md-6">
                                <input type="text" id="txtSAgeRestrict" class="form-control input-sm" placeholder="Age Restriction Name" />
                            </div>
                            <div class="col-md-4">
                                <input type="text" id="txtSAge" onkeypress="return  isNumberKey(this)" maxlength="3" class="form-control input-sm" placeholder="Age"
                                    oncopy="return false" onpaste="return false" oncut="return false" />
                            </div>
                            <div class="col-md-2">
                                <button id="btnSearch" type="button" onclick="BindAgeList(1);" class="btn btn-sm catsearch-btn pull-right">Search</button>
                            </div>
                        </div>
                        <div class="form-group"></div>
                        <div class="table-responsive">
                            <table id="tblAgeList" class="table table-striped table-bordered well" style="margin-bottom: 0px;display:none;">
                                <thead>
                                    <tr class="thead">
                                        <td class="Action" style="width: 50px; text-align: center;">Action</td>
                                        <td class="AgeAutoId" style="display: none;">AgeAutoId</td>
                                        <td class="AgeRestriction" style="white-space: nowrap; text-align: center;">Age Restriction Name</td>
                                        <td class="Age" style="width: 100px; text-align: center;">Age</td>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>
                            <h5 class="well text-center" id="EmptyTable" style="display: none">No data available.</h5>
                        </div>
                        <div class="form-group row" style="padding-bottom: 0px; margin-bottom: 0px; margin-top: 10px;" id="DivPager">
                            <div class="col-md-2">
                                <select class="form-control border-primary input-sm" id="ddlPageSize" style="display:none;" onchange="BindAgeList(1)">
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
                    <h5 class="modal-title">Age Restriction Details
                        <img src="../Images/del.png" class="del-btnp" id="CloseModalD" data-dismiss="modal" />
                    </h5>
                </div>

                <div class="modal-body" style="padding: 15px 0 0 0;">
                    <div class="row">
                        <label class="col-md-4 form-group" style="white-space: nowrap;">
                            Age Restriction Name<span class="required"> *</span>
                        </label>
                        <div class="col-md-8 form-group">
                            <input type="text" id="txtrestriction" class="form-control input-sm" placeholder="Enter Age Restriction Name" />
                        </div>
                    </div>
                    <div class="row">
                        <label class="col-md-4 form-group">
                            Age<span class="required"> *</span>
                        </label>
                        <div class="col-md-8 form-group">
                            <input type="text" id="txtage" onkeypress="return  isNumberKey(this)" maxlength="3" class="form-control input-sm"
                                placeholder="Enter Age" oncopy="return false" onpaste="return false" oncut="return false" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12 form-group">
                            <div class="pull-right">
                                <button type="button" id="btnSave" onclick="InsertAge();" class="btn btn-sm catsave-btn">Save</button>
                                <button type="button" id="btnUpdate" onclick="UpdateAge();" class="btn btn-sm catsave-btn" style="display: none">Update</button>
                                <button type="button" id="btnReset" onclick="Reset();" class="btn btn-sm catreset-btn">Reset</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>


<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="BrandMaster.aspx.cs" Inherits="Pages_BrandMaster" %>

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
        <h1>Brand Master</h1>
    </section>
    <div class="content" id="divForm" ondragstart="return false;" ondrop="return false;">
        <div class="row">
            <input type="hidden" id="hdnBrandId" />
            <div class="col-md-12">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <b>Brand List</b>
                         <img src="../Style/img/add-png.png" class="Add-btnp" onclick="OpenModel();" id="btnAdd" />
                    </div>
                    <div class="panel-body">
                        <div class="row" style="margin-bottom: 10px;">
                            <label class="col-md-2 form-group" style="font-size: 16px; margin-top: 3px;">
                                Brand Name
                            </label>
                            <div class="col-md-4">
                                <input type="text" id="txtSBrandName" maxlength="80" onkeypress="return /[0-9a-zA-Z ]/i.test(event.key)" class="form-control input-sm" placeholder="Brand Name" />
                            </div>
                            <label class="col-md-1 form-group" style="font-size: 16px; margin-top: 3px;">
                                Status
                            </label>
                            <div class="col-md-3">
                                <select id="ddlSStatus" class="form-control input-sm">
                                    <option value="2">All Status</option>
                                    <option value="1">Active</option>
                                    <option value="0">Inactive</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <button id="btnSearch" type="button" onclick="BindBrandList(1);" class="btn btn-sm catsearch-btn pull-right">Search</button>
                            </div>
                        </div>
                        <div class="form-group"></div>
                        <div class="table-responsive">
                            <table id="tblBrandList" class="table table-striped table-bordered well" style="margin-bottom: 0px;">
                                <thead>
                                    <tr class="thead">
                                        <td class="Action" style="width: 50px;">Action</td>
                                        <td class="BrandAutoId" style="display: none;">BrandAutoId</td>
                                        <td class="BrandName" style="white-space: nowrap; text-align: center;">Brand Name</td>
                                        <td class="Status" style="width: 200px; text-align: center;">Status</td>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>
                            <h5 class="well text-center" id="EmptyTable" style="display: none">No data available.</h5>
                        </div>
                        <div class="form-group row" style="padding-bottom: 0px; margin-bottom: 0px; margin-top: 10px;" id="DivPager">
                            <div class="col-md-2">
                                <select class="form-control border-primary input-sm" id="ddlPageSize" onchange="BindBrandList(1)">
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
                    <h5 class="modal-title">Brand Details 
                <img src="../Images/del.png" class="del-btnp" id="CloseModalD" data-dismiss="modal" />
                    </h5>
                </div>
                
                <div class="modal-body" style="padding: 15px 0 0 0;">
                    <div class="row">
                        <label class="col-md-4 form-group">
                            Brand Name<span class="required"> *</span>
                        </label>
                        <div class="col-md-8 form-group">
                            <input type="text" id="txtBrandName" maxlength="80" onkeypress="return /[0-9a-zA-Z ]/i.test(event.key)" class="form-control input-sm" placeholder="Enter Brand Name" />
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
                                <button type="button" id="btnSave" onclick="InsertBrand();" class="btn btn-sm catsave-btn">Save</button>
                                <button type="button" id="btnUpdate" onclick="UpdateBrand();" class="btn btn-sm catsave-btn" style="display: none">Update</button>
                                <button type="button" id="btnReset" onclick="Reset();" class="btn btn-sm catreset-btn">Reset</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>


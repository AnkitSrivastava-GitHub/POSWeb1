<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="POList.aspx.cs" Inherits="Pages_POList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <style>
        .del-btn {
            width: 25px;
            height: 25px;
            opacity: 1.2;
            position: absolute;
            top: 10px;
            right: 9px;
            z-index: 2;
            cursor: pointer;
            border: 0;
            padding: 0;
            font-size: 0;
        }
    </style>
    <section class="content-header">
        <h1>PO List
            <a href="/Pages/POMaster.aspx" class="btn btn-sm btn-warning pull-right">Add New PO</a>
        </h1>
    </section>
    <div class="content" id="divForm" ondragstart="return false;" ondrop="return false;">
        <div class="row">
            <div class="col-md-12">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <b>PO List</b>
                    </div>
                    <div class="panel-body">
                        <div class="row">
                            <div class="col-md-3 form-group">
                                <input type="text" id="txtPONumber" class="form-control input-sm" placeholder="Enter PO Number" maxlength="20" />
                            </div>
                            <div class="col-md-3 form-group">
                                <select id="ddlVendor" class="form-control input-sm">
                                    <option value="0">All Vendor</option>
                                </select>
                            </div>
                            <div class="col-md-2 form-group">
                                <select id="ddlStatus" class="form-control input-sm">
                                    <option value="All">All Status</option>
                                    <option value="New">New</option>
                                    <option value="Process">Process</option>
                                    <option value="Closed">Closed</option>
                                    <option value="Inactive">Inactive</option>
                                </select>
                            </div>
                            <div class="col-md-1 form-group" style="text-align: right;">
                                <button type="button" id="btnSearchPO" onclick="BindPOList(1);" class="btn btn-sm catsearch-btn">Search</button>
                            </div>
                        </div>
                        <div class="table-responsive" style="padding-top: 5px;">
                            <table id="tblPOList" class="table table-striped table-bordered well" style="margin-bottom: 0px;display:none;">
                                <thead>
                                    <tr class="thead">
                                        <td class="Action" style="width: 100px; text-align: center;">Action</td>
                                        <td class="POAutoId" style="white-space: nowrap; text-align: center; display: none;">POAutoId</td>
                                        <td class="PONumber" style="white-space: nowrap; text-align: center">PO Number</td>
                                        <td class="Vendor" style="white-space: nowrap; text-align: center">Vendor</td>
                                        <td class="PODate" style="white-space: nowrap; text-align: center">PO Date</td>
                                        <td class="POItems" style="white-space: nowrap; text-align: center;">View PO Items</td>
                                        <%-- <td class="CreatedDetails" style="white-space: nowrap; text-align: center;">Created Details</td>--%>
                                        <td class="UpdationDetails" style="white-space: nowrap; text-align: center;">Creation Details</td>
                                        <td class="PO_Status" style="white-space: nowrap; text-align: center;">Status</td>
                                    </tr>
                                </thead>
                            </table>
                            <h5 class="well text-center" id="POEmptyTable" style="display: none">No data available.</h5>
                        </div>
                        <div class="form-group row" style="padding-bottom: 0px; margin-bottom: 0px; margin-top: 10px;" id="DivPager">
                            <div class="col-md-1">
                                <select class="form-control border-primary input-sm" style="display:none;" id="ddlPageSize" onchange="BindPOList(1)">
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
                                <span id="spPOSortBy" style="color: red; font-size: small;"></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="POProductListModal" tabindex="-1" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content" style="padding: 1px;">
                <div class="modal-header" style="padding: 8px;">
                    <h5 class="modal-title" id="exampleModalLongTitle"><strong style="font-size: 20px;">Product List</strong>
                        <img src="../Images/del.png" class="del-btn close" data-dismiss="modal" id="CloseModalD" />
                        <%--<button type="button" class="close" data-dismiss="modal"  aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>--%>
                    </h5>
                </div>
                <div class="modal-body" id="DivProductList" style="padding: 0px; margin: 0px;">
                    <div class="table-responsive" <%--style="padding-top: 5px;"--%>>
                        <table id="tblPOProductList" class="table table-striped table-bordered well" style="margin-bottom: 0px;">
                            <thead>
                                <tr class="thead">
                                    <%--  <td class="Action" style="width: 50px; text-align: center;">Action</td>--%>
                                    <td class="PoItemAutoId" style="width: 50px; text-align: center; display: none;">PoItemAutoId</td>
                                    <td class="ProductAutoId" style="white-space: nowrap; text-align: center; display: none;">ProductAutoId</td>
                                    <td class="ProductName" style="white-space: nowrap; text-align: center">Product Name</td>
                                    <td class="UnitType" style="white-space: nowrap; text-align: center">Unit Type</td>
                                    <td class="UnitAutoId" style="white-space: nowrap; text-align: center; display: none;">UnitAutoId</td>
                                    <td class="Quantity" style="white-space: nowrap; text-align: center">Quantity</td>
                                </tr>
                            </thead>
                        </table>
                        <h5 class="well text-center" id="POProductEmptyTable" style="display: none">No data available.</h5>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>


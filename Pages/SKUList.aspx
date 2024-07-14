<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="SKUList.aspx.cs" Inherits="Pages_SKUList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>SKU List
            <a href="/Pages/SKUMaster.aspx" class="btn btn-sm btn-warning pull-right">Create SKU</a>
        </h1>
    </section>
    <div class="content" id="divForm" ondragstart="return false;" ondrop="return false;">
        <div class="row">
            <div class="col-md-12">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <b>Search Criteria</b>
                    </div>
                    <div class="panel-body">
                        <div class="row ">
                            <div class="col-md-3 form-group">
                                <%--<label style="font-size: 16px;">SKU Name</label>--%>
                                <input type="text" id="ddlSKU" maxlength="100" class="form-control input-sm" placeholder="Enter SKU Name" />
                            </div>
                            <div class="col-md-3 form-group">
                                <%--<label style="font-size: 16px;">Barcode</label>--%>
                                <input type="text" id="txtSKUBarcode" maxlength="50" class="form-control input-sm" onkeypress="return alpha(event)" onchange="RemoveSpace(e)" onpaste="var e=this; setTimeout(function(){RemoveSpace(e)}, 4);" placeholder="Enter Barcode" />
                            </div>
                            <div class="col-md-2 form-group">
                                <%--  <label style="font-size: 16px;">Status</label>--%>
                                <select id="ddlSKUStatus" class="form-control input-sm">
                                    <option value="0">All</option>
                                    <option value="1" selected="selected">Active</option>
                                    <option value="2">Inactive</option>
                                </select>
                            </div>
                            <div class="col-md-4 form-group" style="text-align: right;">
                                <button type="button" id="btnAddProduct" onclick="BindSKUList(1);" class="btn btn-sm catsearch-btn">Search</button>
                            </div>
                        </div>
                        <div class="table-responsive" style="padding-top: 5px;">
                            <table id="tblSKUList" class="table table-striped table-bordered well" style="margin-bottom: 0px;display:none;">
                                <thead>
                                    <tr class="thead">
                                        <td class="Action" style="width: 50px; text-align: center;">Action</td>
                                        <td class="SKUAutoId" style="white-space: nowrap; text-align: center; display: none;">SKUAutoId</td>
                                        <td class="SKU_Barcode" style="white-space: nowrap; text-align: center; display: none">Barcode</td>
                                        <td class="SKUId" style="white-space: nowrap; text-align: center; display: none">SKUId</td>
                                        <td class="SKU_Name" style="text-align: center">SKU Name</td>
                                        <td class="SKU_Description" style="white-space: nowrap; text-align: center; display: none">Description</td>
                                        <td class="SKU_UnitPrice" style="white-space: nowrap; text-align: center;">Unit Price (<span class="symbol"></span>)</td>
                                        <td class="SKU_Discount" style="white-space: nowrap; text-align: center">Discount (<span class="symbol"></span>)</td>
                                        <td class="SKU_SubTotal" style="white-space: nowrap; text-align: center;">Sub<br />
                                            Total (<span class="symbol"></span>)</td>
                                        <td class="SKU_Tax" style="white-space: nowrap; text-align: center">Tax (<span class="symbol"></span>)</td>
                                        <td class="SKU_Total" style="white-space: nowrap; text-align: center;">Total (<span class="symbol"></span>)</td>
                                        <td class="CreatedDetails" style="white-space: nowrap; text-align: center; display: none">Creation Details</td>
                                        <td class="UpdationDetails" style="white-space: nowrap; text-align: center;">Last Update<br />
                                            Details</td>
                                        <td class="SKU_Status" style="white-space: nowrap; text-align: center;">Status</td>

                                    </tr>
                                </thead>
                            </table>
                            <h5 class="well text-center" id="SKUEmptyTable" style="display: none">No data available.</h5>
                        </div>
                        <div class="form-group row" style="padding-bottom: 0px; margin-bottom: 0px; margin-top: 10px;" id="DivPager">
                            <div class="col-md-1">
                                <select class="form-control border-primary input-sm" style="display:none;" id="ddlPageSize" onchange="BindSKUList(1)">
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
                                <span id="spSKUSortBy" style="color: red; font-size: small;"></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="ModalBarcode" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-dialog-centered actionb-p" role="document">
            <div class="modal-content card-p">
                <div class="modal-header cardm-head">
                    <h5 class="modal-title"><span id="spnSKUName"></span>
                        <img src="../Images/del.png" class="del-btnp" data-dismiss="modal" />
                    </h5>
                </div>
                <div class="modal-body" style="padding: 15px 0 0 0;">
                    <div class="row">
                        <div class="col-md-12">
                            <div class="table-responsive" style="padding-top: 5px;">
                                <table id="tblBarcodeList" class="table table-striped table-bordered well" style="margin-bottom: 0px;">
                                    <thead>
                                        <tr class="thead">
                                            <td class="SNO text-center" style="width: 10%;">S.No.</td>
                                            <td class="Barcode text-center">Barcode </td>
                                        </tr>
                                    </thead>
                                </table>
                                <h5 class="well text-center" id="emptyTable1">No Barcode are available.</h5>
                            </div>
                        </div>
                    </div>
                </div>
                <%--<div class="modal-footer text-center">
                    <button type="button" onclick="LoginAsAdmin()" class="draft-btn btn btn-primary">Login as Admin</button>
                </div>--%>
            </div>
        </div>
    </div>

</asp:Content>


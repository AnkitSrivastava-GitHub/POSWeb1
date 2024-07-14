<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="MixNMatchList.aspx.cs" Inherits="Pages_MixNMatchList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>Product Group List
            <a href="/Pages/ProductGroup.aspx" class="btn btn-sm btn-warning pull-right">Create Product Group</a>
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
                            <div class="col-md-4 form-group">
                                <%--<label style="font-size: 16px;">SKU Name</label>--%>
                                <input type="text" id="txtGroupName" maxlength="100" class="form-control input-sm" placeholder="Enter Group Name" />
                            </div>
                            <div class="col-md-2 form-group">
                                <%--  <label style="font-size: 16px;">Status</label>--%>
                                <select id="ddlGroupStatus" class="form-control input-sm">
                                    <option value="2">All</option>
                                    <option value="1" selected="selected">Active</option>
                                    <option value="0">Inactive</option>
                                </select>
                            </div>
                            <div class="col-md-4 form-group" style="text-align: right;">
                                <button type="button" id="btnSearchGroup" onclick="BindMixNMatchList(1);" class="btn btn-sm catsearch-btn">Search</button>
                            </div>
                        </div>
                        <div class="table-responsive" style="padding-top: 5px;">
                            <table id="tblMixNMatchList" class="table table-striped table-bordered well" style="margin-bottom: 0px;">
                                <thead>
                                    <tr class="thead">
                                        <td class="Action" style="width: 83px; text-align: center;">Action</td>
                                        <td class="MixNMatchAutoId" style="white-space: nowrap; text-align: center; display: none;">SKUAutoId</td>
                                        <td class="GroupName" style="white-space: nowrap; text-align: center;">Group Name</td>
                                        <td class="MixQty" style="white-space: nowrap; text-align: center;">Quantity</td>
                                        <td class="DiscountType" style="text-align: center">Discount Type</td>
                                        <td class="CreationDetails" style="white-space: nowrap; text-align: center;">Creation Details</td>
                                        <td class="Status" style="white-space: nowrap; text-align: center;">Status</td>
                                    </tr>
                                </thead>
                            </table>
                            <h5 class="well text-center" id="MixNMatchEmptyTable" style="display: none">No data available.</h5>
                        </div>
                        <div class="form-group row" style="padding-bottom: 0px; margin-bottom: 0px; margin-top: 10px;" id="DivPager">
                            <div class="col-md-1">
                                <select class="form-control border-primary input-sm" style="display: none;" id="ddlPageSize" onchange="BindMixNMatchList(1)">
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
                                <span id="spMixNMatchSortBy" style="color: red; font-size: small;"></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="ModalGroupItemList" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
            <div class="modal-content card-p">
                <div class="modal-header cardm-head">
                    <h5 class="modal-title">Product Item List
                        <img src="../Images/del.png" class="del-btnp" data-dismiss="modal" />
                    </h5>
                </div>
                <div class="modal-body" style="padding: 15px 0 0 0;">
                    <div class="row">
                        <div class="col-md-12">
                            <input type="hidden" id="hdnDiscountTypeId" />
                            <input type="hidden" id="hdnDiscountVal" />
                            <div class="table-responsive" style="padding-top: 5px;">
                                <table id="tblGroupItemList" class="table table-striped table-bordered well" style="margin-bottom: 0px;">
                                    <thead>
                                        <tr class="thead">
                                            <td class="ItemAutoId" style="white-space: nowrap; text-align: center; display: none;">AutoId</td>
                                            <td class="Action" style="white-space: nowrap; text-align: center; display: none;">Action</td>
                                            <td class="Department" style="white-space: nowrap; text-align: center">Department</td>
                                            <td class="Category1" style="white-space: nowrap; text-align: center">Category</td>
                                            <td class="SKUName" style="white-space: nowrap; text-align: center">Product Name</td>
                                            <td class="Unitprice" style="white-space: nowrap; text-align: center">Original
                                            <br />
                                                Unit Price (<span class="symbol"></span>)</td>
                                            <td class="UnitDiscount" style="white-space: nowrap; text-align: center; width: 10%;">Discount<br />
                                                (<span class="symbol"></span>)</td>
                                            <td class="UnitDiscountP" style="white-space: nowrap; text-align: center; width: 10%;">Discount<br />
                                                (%)</td>
                                            <td class="Discount" style="white-space: nowrap; text-align: center; display: none;">Discount<br />
                                                (<span class="symbol"></span>)</td>
                                            <td class="DiscountedUnitPrice" style="white-space: nowrap; text-align: center; width: 10%;">Discounted
                                            <br />
                                                Unit Price (<span class="symbol"></span>)</td>
                                            <td class="TaxPer" style="white-space: nowrap; text-align: center;">Tax<br />
                                                Percentage(%)</td>
                                            <td class="Tax" style="white-space: nowrap; text-align: center">Tax<br />
                                                (<span class="symbol"></span>)</td>
                                            <td class="TaxAutoId" style="white-space: nowrap; align-content: center; display: none;">TaxAutoId</td>
                                            <td class="Total" style="white-space: nowrap; text-align: center;">Total<br />
                                                (<span class="symbol"></span>)</td>
                                        </tr>
                                    </thead>
                                </table>
                                <h5 class="well text-center" id="GroupItemListEmptyTable" style="display: none">No data available.</h5>
                            </div>
                            <div class="form-group row" style="padding-bottom: 0px; margin-bottom: 0px; margin-top: 10px;" id="GroupItemListDivPager">
                                <div class="col-md-2">
                                    <select class="form-control border-primary input-sm" style="display: none;" id="ddlGroupItemListPageSize" onchange="ViewGroupItemList(1)">
                                        <option value="10">10</option>
                                        <option value="50">50</option>
                                        <option value="100">100</option>
                                        <option value="500">500</option>
                                        <option value="1000">1000</option>
                                        <option value="0">All</option>
                                    </select>
                                </div>
                                <div class="col-md-7">
                                    <div class="GroupItemListPager Pager" id="GroupItemListPager"></div>
                                </div>
                                <div class="col-md-3 text-right">
                                    <span id="spGroupItemListSortBy" style="color: red; font-size: small;"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>


<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="ShowCouponMaster.aspx.cs" Inherits="Pages_ShowCouponMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>Coupon List
            <a href="/Pages/CouponMaster.aspx" class="btn btn-sm btn-warning pull-right">Add New Coupon</a>
        </h1>
    </section>
    <div class="content" id="divForm" ondragstart="return false;" ondrop="return false;">
        <div class="row">
            <div class="col-md-12">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <b>Coupon List </b>
                    </div>
                    <div class="panel-body">
                        <div class="row" style="margin-bottom: 10px;">
                            <div class="col-md-3">
                                <input type="text" id="txtSCouponCode" class="form-control input-sm" placeholder="Coupon Code" />
                            </div>
                            <div class="col-md-2">
                                <input type="text" id="txtStartDate" class="form-control input-sm date" placeholder="Start Date" />
                            </div>
                            <div class="col-md-2">
                                <input type="text" id="txtEndDate" class="form-control input-sm date" placeholder="End Date" />
                            </div>
                            <div class="col-md-2">
                                <select id="ddlSStatus" class="form-control input-sm ">
                                    <option value="2">All</option>
                                    <option value="1">Active</option>
                                    <option value="0">Inactive</option>
                                </select>
                            </div>
                            <div class="col-md-2" style="display:none">
                                <select id="ddlUsed" class="form-control input-sm" style="font-size:16px">
                                    <option value="2">All Used & Unused</option>
                                    <option value="1">Used</option>
                                    <option value="0">Unused</option>
                                </select>
                            </div>
                            <div class="col-md-1 pull-right">
                                <button id="btnSearch" type="button" onclick="BindCouponList(1);" class="btn btn-sm catsearch-btn pull-right">Search</button>
                            </div>
                        </div>
                        <div class="form-group"></div>
                        <div class="table-responsive">
                            <table id="tblCouponList" class="table table-striped table-bordered well" style="margin-bottom: 0px;display:none;">
                                <thead>
                                    <tr class="thead">
                                        <td class="Action" style="width: 50px;">Action</td>
                                        <td class="CouponAutoId" style="display: none;">CouponAutoId</td>
                                        <td class="CouponCode" style="white-space: nowrap; text-align: center;">Coupon Code</td>
                                        <%--<td class="CouponName" style="white-space: nowrap; text-align: center;">Coupon Name</td>--%>
                                        <%--<td class="TermsAndDescription" style="white-space: nowrap; text-align: center;">Terms & Description</td>--%>
                                        <td class="CouponType" style="white-space: nowrap; text-align: center;">Coupon Type</td>
                                        <td class="Discount" style="white-space: nowrap; text-align: center;">Discount</td>
                                        <td class="MinAmount" style="white-space: nowrap; text-align: center;">Min. Amount(<span class="symbol"></span>)</td>
                                        <td class="StartDate" style="white-space: nowrap; text-align: center;">Start Date</td>
                                        <td class="EndDate" style="white-space: nowrap; text-align: center;">End Date</td>
                                        <td class="Created" style="white-space: nowrap; text-align: center;">Creation Details</td>
                                        <td class="Updated" style="white-space: nowrap; text-align: center;">Updation Details</td>
                                        <%--<td class="Used" style="white-space: nowrap; text-align: center;">Used Status</td>--%>
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
                                <select class="form-control border-primary input-sm" id="ddlPageSize" style="display:none;" onchange="BindCouponList(1);">
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


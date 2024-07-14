<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="SchemeList.aspx.cs" Inherits="Pages_SchemeList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>Scheme List
            <a href="/Pages/SchemeMaster.aspx" class="btn btn-sm btn-warning pull-right">Create Scheme</a>
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
                        <div class="row">
                            <div class="col-md-3 form-group">
                                <input type="text" id="txtS_SchemeName" maxlength="100" class="form-control input-sm" placeholder="Enter Scheme Name" />
                            </div>
                            <div class="col-md-3 form-group">
                                <select id="ddlS_SKUList1" class="form-control input-sm">
                                    <option value="0">All SKU/Product</option>
                                </select>
                            </div>
                            <div class="col-md-2 form-group">
                                <select id="ddlS_SchemeStatus" class="form-control input-sm">
                                    <option value="2">All</option>
                                    <option value="1">Active</option>
                                    <option value="0">Inactive</option>
                                </select>
                            </div>

                            <div class="col-md-4 form-group" style="text-align: right;">
                                <button type="button" id="btnSearchScheme" onclick="BindSchemeList(1);" class="btn btn-sm catsearch-btn">Search</button>
                            </div>
                        </div>

                        <div class="table-responsive" style="padding-top: 5px;">
                            <table id="tblSchemeList" class="table table-striped table-bordered well" style="margin-bottom:0px;display:none;">
                                <thead>
                                    <tr class="thead">
                                        <td class="Action" style="width: 50px; text-align: center;">Action</td>
                                        <td class="SchemeAutoId" style="white-space: nowrap; text-align: center; display: none;">SchemeAutoId</td>
                                        <td class="Scheme_Name" style="white-space: nowrap; text-align: center">Scheme Name</td>
                                        <td class="SKU_Name" style="white-space: nowrap; text-align: center">SKU/<br />Product Name</td>
                                        <td class="Quantity" style="white-space: nowrap; text-align: center">SKU/Product<br /> Quantity</td>
                                        <td class="SKUUnitPrice" style="white-space: nowrap; text-align: center;">SKU/Product <br />Price(<span class="symbol"></span>)/Unit</td>
                                        <td class="Scheme_Tax" style="white-space: nowrap; text-align: center;">Tax(<span class="symbol"></span>)<br />/Unit</td>
                                        <td class="Scheme_Discount" style="white-space: nowrap; text-align: center;">Discount(<span class="symbol"></span>)<br />/Unit</td>
                                        <td class="Scheme_UnitPrice" style="white-space: nowrap; text-align: center;">Scheme Price(<span class="symbol"></span>)<br />/Unit</td>
                                        <td class="CreatedDetails" style="white-space: nowrap; text-align: center;display:none">Creation  Details</td>
                                        <td class="UpdationDetails" style="white-space: nowrap; text-align: center;">Updation Details</td>
                                        <td class="Sheme_Status" style="white-space: nowrap; text-align: center;">Status</td>
                                    </tr>
                                </thead>
                            </table>
                            <h5 class="well text-center" id="SchemeEmptyTable" style="display: none">No data available.</h5>
                        </div>
                        <div class="form-group row" style="padding-bottom: 0px; margin-bottom: 0px; margin-top: 10px;" id="DivPager">
                            <div class="col-md-1">
                                <select class="form-control border-primary input-sm" id="ddlPageSize" style="display:none;" onchange="BindSchemeList(1)">
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
                                <span id="spSchemeSortBy" style="color: red; font-size: small;"></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>


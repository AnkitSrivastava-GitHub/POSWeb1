<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="showCustomerMaster.aspx.cs" Inherits="Pages_showCustomerMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <section class="content-header">
        <h1>Customer Master</h1>
    </section>
    <div class="content" id="divForm" ondragstart="return false;" ondrop="return false;">
        <div class="row">
            <div class="col-md-12">
                <div class="panel panel-default">
                    <div class="panel-heading">
                         Customer List
                    </div>
                    <div class="panel-body">
                        <div class="panel panel-default">
                            <div class="panel-body">
                                <div class="row">
                                    <div class="col-md-4">
                                        <input type="text" id="txtSname" class="form-control input-sm" placeholder="Name" />
                                    </div>
                                 <div class="col-md-4">
                                      <input type="text" id="txtSEmailid" class="form-control input-sm" placeholder="EmailID" />
                                    </div>
                                    
                                    <div class="col-md-4">
                                          <input type="text" id="txtSMob" class="form-control input-sm" placeholder="MobileNo" />
                                    </div>
                                </div>
                                 <div class="row">
                                    
                                     <div class="col-md-2">
                                        <button id="btnSearch" type="button" onclick="BindCustomerList(1);" class="btn btn-sm btn-success">Search</button>
                                    </div>
                                 </div>
                                <div class="form-group"></div>                               
                            </div>
                        </div>
                        <div class="table-responsive">
                            <table id="tblCustomerList" class="table table-striped table-bordered well">
                                <thead>
                                    <tr class="thead">
                                        <td class="Action" style="width: 50px;">Action</td>
                                        <%--<td class="AutoId" style="display: none;">AutoId</td>--%>
                                        <td class="CustomerName" style="white-space: nowrap">Customer Name</td>                                    
                                        <td class="EmailId" style="width:100px;text-align:center;">Email ID</td>
                                        <td class="Mob" style="width:100px;text-align:center;">Mobile No</td>
                                        <td class="address" style="white-space:nowrap;text-align:center;">Address</td>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>
                            <h5 class="well text-center" id="EmptyTable" style="display: none">No data available.</h5>

                        </div>
                        <div class="form-group row" style="padding-bottom: 0px; margin-bottom: 0px; margin-top: 10px;" id="DivPager">
                            <div class="col-md-2">
                                <select class="form-control border-primary input-sm" id="ddlPageSize" onchange="BindCustomerList(1)">
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


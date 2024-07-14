<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="PrintBarcode.aspx.cs" Inherits="Pages_PrintBarcode" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>Barcode Print</h1>
    </section>
    <div class="content" id="divForm" ondragstart="return false;" ondrop="return false;">

        <div class="row">
            <input type="hidden" id="hdnSafeCashId" />
            <div class="col-md-12">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <b>Barcode Print</b>
                        <img src="../Style/img/add-png.png" style="display: none" class="Add-btnp" onclick="OpenModel();" id="btnAdd" />
                    </div>
                    <div class="panel-body">
                        <div class="row" style="margin-bottom: 10px;">

                            <div class="col-md-4">
                                <label>Barcode Type </label>
                                <select class="form-control border-primary input-sm " id="ddlLabelOption" onchange="bindEnableField(this)">
                                    <option value="0">Select Barcode Template</option>
                                    <option value="1">160" x 160" [QR Code]</option>
                                    <option value="2">1.5" x 1" [UPC A : 12 Digit]</option>
                                    <option value="3">1.5" x 1" [Code 128 : 14 Digit]</option>
                                </select>
                            </div>
                            <div class="col-md-8">
                                <label style="margin-top: 28px; color: crimson;"><span id="spn_msg"></span></label>
                            </div>
                        </div>
                        <div class="row" style="margin-bottom: 10px;">
                            <div class="col-md-4">
                                <label>SKU/Product </label>
                                <select id="ddlProduct" disabled class="form-control border-primary input-sm">
                                    <option value="0">Select SKU/Product</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <label>Quantity </label>
                                <input type="text" id="txtQty" disabled maxlength="3" onkeypress="return isNumberKey(event)" onpaste="return false" class="form-control border-primary input-sm req" placeholder="Qty To Print" />
                            </div>
                            <div class="col-md-2 form-group">
                                <button type="button" disabled style="margin-top: 28px; font-size: 16px; padding: 4px 25px" class="btn btn-sm catsave-btn pull-right" id="Add" onclick="AddinList()">Add</button>

                            </div>
                        </div>

                        <div class="form-group"></div>
                        <div class="table-responsive">
                            <table id="tblSafeCashList" class="table table-striped table-bordered well" style="margin-bottom: 0px;">
                                <thead>
                                    <tr class="thead">
                                        <td class="action text-center width3per">Action</td>
                                        <td class="ProductId text-center width3per">SKU/Product ID</td>
                                        <td class="ProductName text-center width3per">SKU/Product Name </td>
                                        <td class="Barcode text-center width3per">Barcode</td>
                                        <td class="Qty text-center width3per">Qty To  Print</td>
                                        <td class="SRP text-center width3per">Price(<span class="symbol"></span>)</td>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>
                            <h5 class="well text-center" id="EmptyTable" style="display: none">No data available.</h5>
                        </div>

                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12 text-right">
                <div class="btn-group mr-1">
                    <button type="button" class="btn btn-sm catsearch-btn" data-animation="pulse" style="display: none; margin: 0 3px 0 3px" id="btnprint" onclick="printtemplate();">Print</button>
                    <button type="button" class="btn btn-sm catreset-btn" id="Reset" onclick="resetField()">Reset</button>
                </div>

            </div>
        </div>
    </div>
    <div id="showBarcodeModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <!-- Modal content-->
            <div class="modal-content" style="width: 600px">
                <div class="modal-header">
                    <div class="row">
                        <div class="col-md-12">
                            <h4 class="modal-title">Select Barcode</h4>
                        </div>
                    </div>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-12">
                            <div class="row">
                                <div class="col-md-4 form-group">
                                    <label>Product ID</label>
                                </div>
                                <div class="col-md-8 form-group">
                                    <label id="ProductId"></label>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-4 form-group">
                                    <label>Product Name</label>
                                </div>
                                <div class="col-md-8 form-group">
                                    <label id="ProductName"></label>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-4 form-group">
                                    <label>Barcode Count</label>
                                </div>
                                <div class="col-md-8 form-group">
                                    <label id="BarcodeCnt"></label>
                                </div>
                            </div>

                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="table-responsive">
                                <table class="table table-striped table-bordered" id="tblBarcode">
                                    <thead class="bg-blue white">
                                        <tr>
                                            <td class="Barcode text-center">Barcode</td>
                                            <td class="Count text-center" style="display: none">Count</td>
                                            <td class="Action text-center">Action</td>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    </tbody>
                                </table>
                                <h5 class="well text-center" id="EmptyTable2" style="display: none">No data available.</h5>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-danger buttonAnimation pull-right round box-shadow-1 btn-sm pulse" onclick="closModal()" data-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

